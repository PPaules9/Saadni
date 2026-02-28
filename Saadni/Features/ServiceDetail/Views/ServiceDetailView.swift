//
//  ServiceDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

enum ServiceDetailData {
    case flexibleJob(FlexibleJobService)
    case shift(ShiftService)

    var title: String {
        switch self {
        case .flexibleJob(let service): return service.title
        case .shift(let service): return service.title
        }
    }

    var price: String {
        switch self {
        case .flexibleJob(let service): return "\(service.price) EGP"
        case .shift(let service): return "\(service.price) EGP"
        }
    }

    var location: String {
        switch self {
        case .flexibleJob(let service): return service.location.name
        case .shift(let service): return service.location.name
        }
    }

    var description: String {
        switch self {
        case .flexibleJob(let service): return service.description
        case .shift(let service): return service.description
        }
    }

    var createdAt: Date {
        switch self {
        case .flexibleJob(let service): return service.createdAt
        case .shift(let service): return service.createdAt
        }
    }

    var image: ServiceImage {
        switch self {
        case .flexibleJob(let service): return service.image
        case .shift(let service): return service.image
        }
    }

    var providerName: String {
        switch self {
        case .flexibleJob(let service): return service.providerName ?? "Unknown"
        case .shift(let service): return service.providerName ?? "Unknown"
        }
    }

    var jobType: JobType {
        switch self {
        case .flexibleJob: return .flexibleJobs
        case .shift: return .shift
        }
    }

    var isShift: Bool {
        switch self {
        case .shift: return true
        case .flexibleJob: return false
        }
    }
}

struct ServiceDetailView: View {
    let serviceData: ServiceDetailData
    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ApplicationsStore.self) var applicationsStore

    @State private var showingApplySheet = false
    @State private var showingApplications = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header Image
                if let uiImage = serviceData.image.localImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    ZStack {
                        Color(.systemGray6)
                        Image(systemName: "briefcase.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(60)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // Info Row
                HStack {
                    Text(formatDate(serviceData.createdAt))
                        .foregroundStyle(.gray)
                    Text("|")
                        .foregroundStyle(.gray)
                    Text(serviceData.location)
                        .foregroundStyle(.gray)

                    Spacer()

                    Text(serviceData.price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
                .font(.subheadline)

                // Title & Description
                VStack(alignment: .leading, spacing: 10) {
                    Text(serviceData.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text(serviceData.description)
                        .font(.body)
                        .foregroundStyle(.gray)
                }

                // Service Type Badge
                HStack {
                    Text(serviceData.isShift ? "Shift" : "Flexible Job")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(serviceData.isShift ? Color.blue.opacity(0.3) : Color.green.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundStyle(serviceData.isShift ? .blue : .green)

                    Spacer()
                }

                // Shift-specific details
                if serviceData.isShift,
                   case .shift(let shift) = serviceData {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shift Details")
                            .font(.headline)
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(label: "Shift Name", value: shift.shiftName)
                            DetailRow(label: "Category", value: shift.categoryDisplayName)
                            DetailRow(label: "Date", value: formatDate(shift.schedule.startDate))
                            DetailRow(label: "Time", value: "\(formatTime(shift.schedule.startTime)) - \(formatTime(shift.schedule.endTime))")

                            if shift.schedule.isRepeated {
                                DetailRow(label: "Repeat", value: "Yes (\(shift.schedule.repeatDates.count) days)")
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                    .padding(.vertical, 12)
                }

                // Map Placeholder
                ZStack(alignment: .bottomTrailing) {
                    Color(.systemGray6).opacity(0.2)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 50))
                        path.addLine(to: CGPoint(x: 400, y: 150))
                        path.move(to: CGPoint(x: 50, y: 0))
                        path.addLine(to: CGPoint(x: 50, y: 200))
                    }
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)

                    VStack {
                        Image(systemName: "map.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                        Text(serviceData.location)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "map")
                            Text("Get Directions")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6).opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                    }
                    .padding()
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

                // Provider Info
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray)
                        .background(Color(.systemGray6).opacity(0.3))
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(serviceData.providerName)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Joined 6 February 2026")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Button {
                        // Chat Action
                    } label: {
                        Image(systemName: "bubble.left.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                    }
                }
                .padding()

                // Action Buttons Section
                VStack(spacing: 12) {
                    // Apply Button
                    if !isOwnService {
                        if hasAlreadyApplied {
                            // Show "Applied" state
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Applied")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.green, lineWidth: 2)
                            )
                        } else {
                            BrandButton(
                                "Apply Now",
                                size: .large,
                                isDisabled: false,
                                hasIcon: true,
                                icon: "hand.raised.fill",
                                secondary: false
                            ) {
                                showingApplySheet = true
                            }
                        }
                    }

                    // Chat/View Applications Button
                    BrandButton(
                        isOwnService ? "View Applications" : "Chat with Owner",
                        size: .large,
                        isDisabled: false,
                        hasIcon: true,
                        icon: isOwnService ? "person.3.fill" : "bubble.left.fill",
                        secondary: true
                    ) {
                        if isOwnService {
                            showingApplications = true
                        } else {
                            // Navigate to chat (Phase 7)
                            print("📝 Chat feature coming soon")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)

            }
            .padding()
        }
        .background(Colors.swiftUIColor(.appBackground))
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Favorite
                } label: {
                    Image(systemName: "heart")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showingApplySheet) {
            applySheetContent
        }
        .sheet(isPresented: $showingApplications) {
            applicationsListContent
        }
    }

    private var isOwnService: Bool {
        guard let currentUserId = authManager.currentUserId else { return false }

        switch serviceData {
        case .flexibleJob(let service):
            return service.providerId == currentUserId
        case .shift(let service):
            return service.providerId == currentUserId
        }
    }

    private var hasAlreadyApplied: Bool {
        let serviceId: String
        switch serviceData {
        case .flexibleJob(let service): serviceId = service.id
        case .shift(let service): serviceId = service.id
        }

        return applicationsStore.hasApplied(to: serviceId)
    }

    private var serviceInfo: (id: String, title: String) {
        switch serviceData {
        case .flexibleJob(let service):
            return (id: service.id, title: service.title)
        case .shift(let service):
            return (id: service.id, title: service.title)
        }
    }

    private var applySheetContent: some View {
        ApplySheet(serviceTitle: serviceInfo.title, serviceId: serviceInfo.id)
    }

    private var applicationsListContent: some View {
        NavigationStack {
            ApplicationsList(serviceId: serviceInfo.id, serviceTitle: serviceInfo.title)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        ServiceDetailView(
            serviceData: .flexibleJob(
                FlexibleJobService(
                    id: "1",
                    title: "Help Cleaning",
                    price: 500,
                    location: ServiceLocation(name: "Cairo, Egypt", coordinate: nil),
                    description: "Need help cleaning my apartment before guests arrive",
                    image: ServiceImage(localId: "1", remoteURL: nil, localImage: nil),
                    createdAt: Date(),
                    providerId: "provider_1",
                    providerName: "Ahmed",
                    providerImageURL: nil,
                    status: .published,
                    isFeatured: false,
                    category: .helpCleaning
                )
            )
        )
    }
}
