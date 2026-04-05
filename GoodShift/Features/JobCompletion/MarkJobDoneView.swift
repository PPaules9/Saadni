import SwiftUI

struct MarkJobDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore

    let service: JobService
    var onSuccess: (() -> Void)? = nil

    @State private var note: String = ""
    @State private var isSubmitting: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // Icon + headline
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.12))
                                .frame(width: 80, height: 80)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.green)
                        }

                        VStack(spacing: 6) {
                            Text("Mark Job as Done")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Text("Let the provider know you've completed the work.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 8)

                    // Service summary card
                    VStack(alignment: .leading, spacing: 8) {
                        Text(service.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)

                        HStack(spacing: 12) {
                            if let name = service.providerName {
                                Label(name, systemImage: "person.fill")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Label(service.formattedPrice, systemImage: "banknote")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Optional note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completion Note (Optional)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)

                        Text("Describe what you completed or anything the provider should know.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $note)
                            .frame(minHeight: 100)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
                            )
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

                    // Submit button
                    Button {
                        Task { await submit() }
                    } label: {
                        HStack(spacing: 8) {
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(0.85)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(isSubmitting ? "Submitting…" : "I'm Done — Mark as Complete")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isSubmitting ? Color.green.opacity(0.6) : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(isSubmitting)
                }
                .padding(20)
            }
            .navigationTitle("Mark as Done")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isSubmitting)
                }
            }
        }
    }

    private func submit() async {
        isSubmitting = true
        errorMessage = nil
        do {
            try await applicationsStore.requestCompletion(
                serviceId: service.id,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note
            )
            onSuccess?()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
        }
    }
}
