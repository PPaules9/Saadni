//
//  myJobs.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

// MARK: - State Holder (keeps FirestoreService out of the View)
@Observable private final class ApplicantUsersCache {
    var users: [String: User] = [:]

    func load(applications: [JobApplication]) async {
        // Fetch all unknown users concurrently instead of serially
        await withTaskGroup(of: (String, User?).self) { group in
            for application in applications {
                guard users[application.applicantId] == nil else { continue }
                let applicantId = application.applicantId
                group.addTask {
                    let user = try? await FirestoreService.shared.fetchUser(id: applicantId)
                    return (applicantId, user)
                }
            }
            for await (id, user) in group {
                if let user { users[id] = user }
            }
        }
    }
}

enum MyJobsTab: String, CaseIterable {
    case myJobs = "My Jobs"
    case applicants = "Applicants"
    case calendar = "Calendar"
}

struct MyJobsView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ServicesStore.self) var servicesStore
    @Environment(ApplicationsStore.self) var applicationsStore
    @Environment(AppCoordinator.self) var appCoordinator
    @Environment(ReviewsStore.self) var reviewsStore

    @State private var selectedTab: MyJobsTab = .myJobs
    @State private var userServices: [JobService] = []
    @State private var receivedApplications: [JobApplication] = []
    @State private var applicantCache = ApplicantUsersCache()
    private var applicantUsers: [String: User] { applicantCache.users }
    @State private var isLoading: Bool = true
    @State private var filterOption: ServiceFilterOption = .active
    @Environment(JobSeekerCoordinator.self) var coordinator
    @State private var selectedCalendarDate: Date = Date()
    @State private var selectedCompletionService: JobService?
    @State private var actionError: String?
    @State private var showActionError = false
    @State private var loadError: String?
    @State private var showLoadError = false
    @State private var expandedGroups: Set<String> = []

    var pendingCompletionServices: [JobService] {
        userServices.filter { $0.status == .pendingCompletion }
    }

    var filteredServices: [JobService] {
        switch filterOption {
        case .all:
            return userServices
        case .active:
            return userServices.filter {
                $0.status == .published || $0.status == .active ||
                $0.status == .pendingCompletion || $0.status == .disputed
            }
        case .completed:
            return userServices.filter { $0.status == .completed }
        }
    }

    var providerJobDates: Set<DateComponents> {
        Set(userServices.compactMap { service in
            guard let serviceDate = service.serviceDate else { return nil }
            return Calendar.current.dateComponents([.year, .month, .day], from: serviceDate)
        })
    }

    var servicesForSelectedDate: [JobService] {
        userServices.filter { service in
            guard let serviceDate = service.serviceDate else { return false }
            return Calendar.current.isDate(serviceDate, inSameDayAs: selectedCalendarDate)
        }
    }

    /// Collapses shifts that share a jobGroupId into a single group entry.
    /// Services without a group ID stay as individual entries.
    var groupedEntries: [JobGroupEntry] {
        var result: [JobGroupEntry] = []
        var seen: Set<String> = []

        for service in filteredServices {
            if let groupId = service.jobGroupId {
                guard !seen.contains(groupId) else { continue }
                seen.insert(groupId)
                let siblings = filteredServices.filter { $0.jobGroupId == groupId }
                    .sorted { ($0.serviceDate ?? .distantPast) < ($1.serviceDate ?? .distantPast) }
                result.append(.group(id: groupId, shifts: siblings))
            } else {
                result.append(.single(service))
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            Picker("Tab", selection: $selectedTab) {
                ForEach(MyJobsTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // Tab Content
            switch selectedTab {
            case .myJobs:
                myJobsContent
            case .applicants:
                applicantsContent
            case .calendar:
                calendarContent
            }
        }
        .background(Colors.swiftUIColor(.appBackground))
        .sheet(item: $selectedCompletionService) { service in
            if let application = applicationsStore.receivedApplications.first(where: {
                $0.serviceId == service.id && $0.status == .accepted
            }) {
                CompletionConfirmationSheet(service: service, application: application)
                    .environment(applicationsStore)
            } else {
                ContentUnavailableView(
                    "Application Not Found",
                    systemImage: "person.fill.questionmark",
                    description: Text("Could not load the hired applicant's details.")
                )
            }
        }
        .alert("Error", isPresented: $showActionError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(actionError ?? "An error occurred")
        }
        .alert("Could Not Load Jobs", isPresented: $showLoadError) {
            Button("Retry") { Task { await loadData() } }
            Button("Dismiss", role: .cancel) { showLoadError = false }
        } message: {
            Text(loadError ?? "Please check your connection and try again.")
        }
        .task {
            await loadData()
        }
        .refreshable {
            await loadData()
        }
    }

    // MARK: - My Jobs Tab

    var myJobsContent: some View {
        ScrollView {
            if isLoading {
                LoadingStateView(message: "Loading your jobs...")
            } else if filteredServices.isEmpty {
                ContentUnavailableView(
                    emptyStateTitle,
                    systemImage: "briefcase",
                    description: Text(emptyStateDescription)
                )
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 16) {
                    // Completion banners at the top
                    ForEach(pendingCompletionServices) { service in
                        CompletionRequestBanner(service: service) {
                            openCompletionConfirmation(for: service)
                        }
                    }

                    ForEach(groupedEntries) { entry in
                        switch entry {
                        case .single(let service):
                            NavigationLink(value: ServiceProviderDestination.serviceDetail(service)) {
                                ServiceCard(service: service)
                            }
                        case .group(let groupId, let shifts):
                            JobGroupCard(
                                groupId: groupId,
                                shifts: shifts,
                                isExpanded: expandedGroups.contains(groupId),
                                onToggle: {
                                    if expandedGroups.contains(groupId) {
                                        expandedGroups.remove(groupId)
                                    } else {
                                        expandedGroups.insert(groupId)
                                    }
                                },
                                onSelectShift: { service in
                                    coordinator.navigate(to: ServiceProviderDestination.serviceDetail(service))
                                }
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .background(Colors.swiftUIColor(.appBackground))
    }

    // MARK: - Applicants Tab

    var applicantsContent: some View {
        ScrollView {
            if isLoading {
                LoadingStateView(message: "Loading applicants...")
            } else if receivedApplications.isEmpty {
                ContentUnavailableView(
                    "No Applicants Yet",
                    systemImage: "person.fill.questionmark",
                    description: Text("Applicants will appear here once someone applies to your jobs")
                )
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(receivedApplications) { application in
                        if let service = userServices.first(where: { $0.id == application.serviceId }) {
                            VStack(spacing: 0) {
                                Button(action: {
                                    coordinator.presentSheet(.userProfile(userId: application.applicantId))
                                }) {
                                    ApplicantCard(
                                        application: application,
                                        service: service,
                                        applicant: applicantUsers[application.applicantId]
                                    )
                                }
                                .foregroundColor(.primary)

                                // Accept / Reject row for pending applications
                                if application.status == .pending {
                                    HStack(spacing: 10) {
                                        Button {
                                            Task { await accept(application, service: service) }
                                        } label: {
                                            Label("Accept", systemImage: "checkmark")
                                                .font(.system(size: 13, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        .buttonStyle(.plain)

                                        Button {
                                            Task { await reject(application) }
                                        } label: {
                                            Label("Reject", systemImage: "xmark")
                                                .font(.system(size: 13, weight: .semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.bottom, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Colors.swiftUIColor(.appBackground))
    }

    // MARK: - Calendar Tab

    var calendarContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                CustomCalendarWithJobIndicators(
                    selectedDate: $selectedCalendarDate,
                    jobDates: providerJobDates,
                    onDateSelected: { _ in }
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)

                Divider()
                    .padding(.horizontal, 16)

                if servicesForSelectedDate.isEmpty {
                    ContentUnavailableView(
                        "No Jobs on This Day",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("You have no posted jobs on \(selectedCalendarDate.formatted(.dateTime.day().month(.wide)))")
                    )
                    .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(servicesForSelectedDate) { service in
                            ServiceListCard(service: service)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Colors.swiftUIColor(.appBackground))
    }

    // MARK: - Data Loading

    private func loadData() async {
        isLoading = true
        loadError = nil
        do {
            try await loadServices()
            await loadReceivedApplications()
        } catch {
            loadError = error.localizedDescription
            showLoadError = true
        }
        isLoading = false
    }

    private func loadServices() async throws {
        guard let userId = authManager.currentUserId else { return }
        userServices = await servicesStore.fetchUserServices(userId: userId)
    }

    private func loadReceivedApplications() async {
        receivedApplications = applicationsStore.receivedApplications
            .sorted { $0.appliedAt > $1.appliedAt }

        // Load applicant user data through the state holder — not directly from Firestore
        await applicantCache.load(applications: receivedApplications)
    }

    private func openCompletionConfirmation(for service: JobService) {
        selectedCompletionService = service
    }

    private func accept(_ application: JobApplication, service: JobService) async {
        do {
            try await applicationsStore.acceptApplication(
                applicationId: application.id,
                serviceId: service.id
            )
            await loadData()
        } catch {
            actionError = error.localizedDescription
            showActionError = true
        }
    }

    private func reject(_ application: JobApplication) async {
        do {
            try await applicationsStore.updateApplicationStatus(
                applicationId: application.id,
                newStatus: .rejected
            )
        } catch {
            actionError = error.localizedDescription
            showActionError = true
        }
    }

    private var emptyStateTitle: String {
        switch filterOption {
        case .all: return "No Jobs Posted"
        case .active: return "No Active Jobs"
        case .completed: return "No Completed Jobs"
        }
    }

    private var emptyStateDescription: String {
        switch filterOption {
        case .all: return "Start by creating your first job posting"
        case .active: return "You don't have any active job postings"
        case .completed: return "No jobs have been completed yet"
        }
    }
}

// MARK: - Job Group Entry

enum JobGroupEntry: Identifiable {
    case single(JobService)
    case group(id: String, shifts: [JobService])

    var id: String {
        switch self {
        case .single(let s): return s.id
        case .group(let id, _): return id
        }
    }
}

// MARK: - Job Group Card

struct JobGroupCard: View {
    let groupId: String
    let shifts: [JobService]
    let isExpanded: Bool
    let onToggle: () -> Void
    let onSelectShift: (JobService) -> Void

    private var representative: JobService? { shifts.first }

    private var dateRangeText: String {
        let dates = shifts.compactMap { $0.serviceDate }.sorted()
        guard let first = dates.first, let last = dates.last else { return "Multiple dates" }
        if Calendar.current.isDate(first, inSameDayAs: last) {
            return first.formatted(.dateTime.day().month(.abbreviated).year())
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return "\(formatter.string(from: first)) – \(formatter.string(from: last))"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Group header — tap to expand/collapse
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(representative?.title ?? "Job")
                                .font(.headline)
                                .foregroundStyle(Colors.swiftUIColor(.textPrimary))
                            Text("\(shifts.count) shifts")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundStyle(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(dateRangeText)
                                .font(.caption)
                        }
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        if let price = representative?.formattedPrice {
                            Text(price)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textPrimary))
                        }
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(14)
                .background(Colors.swiftUIColor(.cardBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            // Expanded individual shift rows
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(shifts) { shift in
                        Button {
                            onSelectShift(shift)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    if let date = shift.serviceDate {
                                        Text(date.formatted(.dateTime.weekday(.wide).day().month(.abbreviated)))
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(Colors.swiftUIColor(.textPrimary))
                                        Text(date.formatted(.dateTime.hour().minute()))
                                            .font(.caption)
                                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                    } else {
                                        Text("No date set")
                                            .font(.subheadline)
                                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                    }
                                }
                                Spacer()
                                ShiftStatusBadge(status: shift.status)
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Colors.swiftUIColor(.cardBackground).opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 6)
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
        }
    }
}

struct ShiftStatusBadge: View {
    let status: ServiceStatus

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var label: String {
        switch status {
        case .published: return "Open"
        case .active: return "Active"
        case .pendingCompletion: return "Pending"
        case .completed: return "Done"
        case .disputed: return "Disputed"
        case .cancelled: return "Cancelled"
        case .draft: return "Draft"
        }
    }

    private var color: Color {
        switch status {
        case .published: return .blue
        case .active: return .green
        case .pendingCompletion: return .orange
        case .completed: return .gray
        case .disputed: return .red
        case .cancelled: return .red
        case .draft: return .gray
        }
    }
}

enum ServiceFilterOption: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"

    var title: String { rawValue }
}

#Preview {
    let userCache = UserCache()
    let authManager = AuthenticationManager(userCache: userCache)
    return MyJobsView()
        .environment(authManager)
        .environment(ServicesStore())
        .environment(ApplicationsStore())
        .environment(AppCoordinator(authManager: authManager, userCache: userCache))
}
