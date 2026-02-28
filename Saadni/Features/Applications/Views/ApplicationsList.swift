import SwiftUI

struct ApplicationsList: View {
    let serviceId: String
    let serviceTitle: String
    @Environment(ApplicationsStore.self) var applicationsStore
    @State private var selectedApplication: JobApplication?

    private var applications: [JobApplication] {
        applicationsStore.getApplications(for: serviceId)
    }

    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            if applications.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)

                    Text("No Applications Yet")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("When someone applies to your service, you'll see them here.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(applications) { application in
                            ApplicationCard(application: application)
                                .onTapGesture {
                                    selectedApplication = application
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Applications")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedApplication) { application in
            ApplicationDetailSheet(application: application)
        }
    }
}

// MARK: - Application Card
struct ApplicationCard: View {
    let application: JobApplication

    var body: some View {
        HStack(spacing: 12) {
            // Applicant avatar
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(application.applicantName.prefix(1))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                )

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(application.applicantName)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Applied \(formatDate(application.appliedAt))")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            // Status badge
            Text(application.statusDisplayText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(statusColor(for: application.status))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func statusColor(for status: JobApplicationStatus) -> Color {
        switch status {
        case .pending: return .blue.opacity(0.5)
        case .accepted: return .green.opacity(0.5)
        case .rejected: return .red.opacity(0.5)
        case .withdrawn: return .gray.opacity(0.5)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Application Detail Sheet
struct ApplicationDetailSheet: View {
    let application: JobApplication
    @Environment(\.dismiss) var dismiss
    @Environment(ApplicationsStore.self) var applicationsStore
    @State private var isProcessing = false

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.swiftUIColor(.appBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Applicant info
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(application.applicantName.prefix(2))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.accent)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(application.applicantName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)

                                Text("Applied \(formatFullDate(application.appliedAt))")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.top, 20)

                        // Cover message
                        if let coverMessage = application.coverMessage, !coverMessage.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Cover Message")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(coverMessage)
                                    .font(.body)
                                    .foregroundStyle(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                            }
                        }

                        // Actions (if pending)
                        if application.status == .pending {
                            VStack(spacing: 12) {
                                BrandButton(
                                    "Accept Application",
                                    size: .large,
                                    isDisabled: isProcessing,
                                    hasIcon: true,
                                    icon: "checkmark.circle.fill",
                                    secondary: false
                                ) {
                                    Task {
                                        await acceptApplication()
                                    }
                                }

                                BrandButton(
                                    "Decline Application",
                                    size: .large,
                                    isDisabled: isProcessing,
                                    hasIcon: true,
                                    icon: "xmark.circle.fill",
                                    secondary: true
                                ) {
                                    Task {
                                        await rejectApplication()
                                    }
                                }
                            }
                            .padding(.top, 20)
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Application")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.accent)
                }
            }
        }
    }

    private func acceptApplication() async {
        isProcessing = true
        do {
            try await applicationsStore.updateApplicationStatus(
                applicationId: application.id,
                newStatus: .accepted,
                responseMessage: "Your application has been accepted!"
            )
            dismiss()
        } catch {
            print("❌ Error accepting application: \(error)")
        }
        isProcessing = false
    }

    private func rejectApplication() async {
        isProcessing = true
        do {
            try await applicationsStore.updateApplicationStatus(
                applicationId: application.id,
                newStatus: .rejected,
                responseMessage: "Thank you for applying."
            )
            dismiss()
        } catch {
            print("❌ Error rejecting application: \(error)")
        }
        isProcessing = false
    }

    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        ApplicationsList(serviceId: "123", serviceTitle: "Help me clean")
            .environment(ApplicationsStore())
    }
}
