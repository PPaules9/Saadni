//
//  myJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

enum MyJobsTab: String, CaseIterable {
    case myJobs = "My Jobs"
    case applicants = "Applicants"
    case calendar = "Calendar"
}

struct myJobs: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ServicesStore.self) var servicesStore
    @Environment(ApplicationsStore.self) var applicationsStore
    @Environment(AppCoordinator.self) var appCoordinator

    @State private var selectedTab: MyJobsTab = .myJobs
    @State private var userServices: [JobService] = []
    @State private var receivedApplications: [JobApplication] = []
    @State private var applicantUsers: [String: User] = [:]
    @State private var isLoading: Bool = true
    @State private var filterOption: ServiceFilterOption = .active
    @State private var selectedApplicantID: ApplicantID?
    @State private var selectedCalendarDate: Date = Date()

    var filteredServices: [JobService] {
        switch filterOption {
        case .all:
            return userServices
        case .active:
            return userServices.filter {
                $0.status == .published || $0.status == .active
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
        .sheet(item: $selectedApplicantID) { identifier in
            UserProfileSheet(userId: identifier.id)
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
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.accent)
                    Text("Loading your jobs...")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
            } else if filteredServices.isEmpty {
                ContentUnavailableView(
                    emptyStateTitle,
                    systemImage: "briefcase",
                    description: Text(emptyStateDescription)
                )
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filteredServices) { service in
                        NavigationLink(value: ServiceProviderDestination.serviceDetail(service)) {
                            ServiceCard(service: service)
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
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.accent)
                    Text("Loading applicants...")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
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
                            Button(action: {
                                selectedApplicantID = ApplicantID(id: application.applicantId)
                            }) {
                                ApplicantCard(
                                    application: application,
                                    service: service,
                                    applicant: applicantUsers[application.applicantId]
                                )
                            }
                            .foregroundColor(.primary)
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
        await loadServices()
        await loadReceivedApplications()
        isLoading = false
    }

    private func loadServices() async {
        guard let userId = authManager.currentUserId else {
            return
        }
        userServices = await servicesStore.fetchUserServices(userId: userId)
    }

    private func loadReceivedApplications() async {
        receivedApplications = applicationsStore.receivedApplications
            .sorted { $0.appliedAt > $1.appliedAt }

        // Load applicant user data
        for application in receivedApplications {
            if applicantUsers[application.applicantId] == nil {
                do {
                    let user = try await FirestoreService.shared.fetchUser(id: application.applicantId)
                    applicantUsers[application.applicantId] = user
                } catch {
                    // Continue loading other users even if one fails
                }
            }
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

enum ServiceFilterOption: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"

    var title: String { rawValue }
}

#Preview {
    let userCache = UserCache()
    let authManager = AuthenticationManager(userCache: userCache)
    return myJobs()
        .environment(authManager)
        .environment(ServicesStore())
        .environment(ApplicationsStore())
        .environment(AppCoordinator(authManager: authManager, userCache: userCache))
}
