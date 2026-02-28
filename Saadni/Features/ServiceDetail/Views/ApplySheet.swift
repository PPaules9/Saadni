import SwiftUI

struct ApplySheet: View {
    let serviceTitle: String
    let serviceId: String
    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ApplicationsStore.self) var applicationsStore

    @State private var coverMessage = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.swiftUIColor(.appBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Apply to")
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                            Text(serviceTitle)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 20)

                        // Cover Message (Optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cover Message (Optional)")
                                .font(.headline)
                                .foregroundStyle(.white)

                            Text("Tell the service provider why you're a good fit")
                                .font(.caption)
                                .foregroundStyle(.gray)

                            TextEditor(text: $coverMessage)
                                .frame(height: 120)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                                )
                                .foregroundStyle(.white)
                        }

                        // Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }

                        // Info Box
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("What happens next?")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)

                                Text("The service owner will review your application and may contact you via chat.")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)

                        Spacer()
                    }
                    .padding()
                }

                // Submit Button at bottom
                VStack {
                    Spacer()

                    BrandButton(
                        isSubmitting ? "Submitting..." : "Submit Application",
                        size: .large,
                        isDisabled: isSubmitting,
                        hasIcon: true,
                        icon: "paperplane.fill",
                        secondary: false
                    ) {
                        Task {
                            await submitApplication()
                        }
                    }
                    .padding()
                    .background(Colors.swiftUIColor(.appBackground))
                }
            }
            .navigationTitle("Apply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.accent)
                }
            }
        }
    }

    private func submitApplication() async {
        guard let user = authManager.currentUser else {
            errorMessage = "You must be signed in to apply"
            return
        }

        isSubmitting = true
        errorMessage = nil

        do {
            try await applicationsStore.submitApplication(
                serviceId: serviceId,
                applicantId: user.id,
                applicantName: user.displayName ?? user.email,
                applicantPhotoURL: user.photoURL,
                coverMessage: coverMessage.isEmpty ? nil : coverMessage
            )

            // Success - dismiss sheet
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
        }
    }
}

#Preview {
    ApplySheet(serviceTitle: "Help me clean", serviceId: "123")
        .environment(AuthenticationManager())
        .environment(ApplicationsStore())
}
