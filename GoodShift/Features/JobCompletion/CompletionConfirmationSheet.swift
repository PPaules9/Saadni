import SwiftUI
import Kingfisher

struct CompletionConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore

    let service: JobService
    let application: JobApplication

    @State private var isConfirming: Bool = false
    @State private var isDisputing: Bool = false
    @State private var showDisputeInput: Bool = false
    @State private var disputeReason: String = ""
    @State private var errorMessage: String?

    private var isLoading: Bool { isConfirming || isDisputing }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // Icon + headline
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.12))
                                .frame(width: 80, height: 80)
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.accent)
                        }

                        VStack(spacing: 6) {
                            Text("Job Completion Requested")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Text("\(application.applicantName) says they've finished the work.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 8)

                    // Service summary
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Job Details", systemImage: "briefcase.fill")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        Text(service.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        HStack(spacing: 12) {
                            Label(service.formattedPrice, systemImage: "banknote")
                                .font(.caption)
                                .foregroundStyle(.green)

                            Label(service.location.name, systemImage: "mappin.and.ellipse")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Proof photo
                    if let photoURL = service.completionPhotoURL, let url = URL(string: photoURL) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Proof Photo", systemImage: "camera.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                    }

                    // Student's completion note
                    if let note = service.completionNote, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Student's Note", systemImage: "text.quote")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            Text(note)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color.accentColor.opacity(0.07))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.accentColor.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // Requested at
                    if let requestedAt = service.completionRequestedAt {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text("Submitted \(requestedAt.formatted(.relative(presentation: .named)))")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Dispute input
                    if showDisputeInput {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reason for Dispute (Optional)")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            TextEditor(text: $disputeReason)
                                .frame(minHeight: 90)
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                    }

                    // Error
                    if let error = errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Action buttons
                    VStack(spacing: 10) {
                        // Confirm
                        Button {
                            Task { await confirm() }
                        } label: {
                            HStack(spacing: 8) {
                                if isConfirming {
                                    ProgressView().tint(.white).scaleEffect(0.85)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                                Text(isConfirming ? "Confirming…" : "Confirm Completion")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isLoading ? Color.green.opacity(0.6) : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .disabled(isLoading)

                        // Dispute
                        if showDisputeInput {
                            Button {
                                Task { await dispute() }
                            } label: {
                                HStack(spacing: 8) {
                                    if isDisputing {
                                        ProgressView().tint(.white).scaleEffect(0.85)
                                    } else {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                    }
                                    Text(isDisputing ? "Submitting…" : "Submit Dispute")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(isLoading ? Color.red.opacity(0.6) : Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                            }
                            .disabled(isLoading)
                        } else {
                            Button {
                                withAnimation { showDisputeInput = true }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Dispute — Work Not Done")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(14)
                            }
                            .disabled(isLoading)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Review Completion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isLoading)
                }
            }
        }
    }

    private func confirm() async {
        isConfirming = true
        errorMessage = nil
        do {
            try await applicationsStore.confirmCompletion(
                serviceId: service.id,
                applicationId: application.id
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isConfirming = false
        }
    }

    private func dispute() async {
        isDisputing = true
        errorMessage = nil
        do {
            let reason = disputeReason.trimmingCharacters(in: .whitespacesAndNewlines)
            try await applicationsStore.disputeCompletion(
                serviceId: service.id,
                reason: reason.isEmpty ? nil : reason
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isDisputing = false
        }
    }
}
