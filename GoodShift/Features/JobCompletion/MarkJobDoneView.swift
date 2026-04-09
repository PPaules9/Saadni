import SwiftUI
import PhotosUI

struct MarkJobDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore
    @Environment(AuthenticationManager.self) private var authManager

    let service: JobService
    var onSuccess: (() -> Void)? = nil

    @State private var note: String = ""
    @State private var selectedPhoto: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var isSubmitting: Bool = false
    @State private var isUploadingPhoto: Bool = false
    @State private var errorMessage: String?

    private var canSubmit: Bool { selectedPhoto != nil && !isSubmitting }

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
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.primary)

                            Text("Take a photo as proof, then let the provider know you've completed the work.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 8)

                    // Service summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text(service.title)
                            .font(.subheadline.weight(.semibold))
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

                    // MARK: - Photo proof (required)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Proof Photo")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text("Required")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(6)
                        }

                        Text("Take a clear photo of the completed work. The provider will review it before confirming.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        PhotosPicker(
                            selection: $photosPickerItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let photo = selectedPhoto {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: photo)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))

                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 4)
                                        .padding(10)
                                }
                            } else {
                                VStack(spacing: 10) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(.accent)
                                    Text("Tap to Add Photo")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.accent)
                                    Text("JPG, PNG — max 10 MB")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.accentColor.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                )
                            }
                        }
                        .onChange(of: photosPickerItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    await MainActor.run {
                                        selectedPhoto = uiImage.resizedToMaxDimension(1024)
                                    }
                                }
                            }
                        }
                    }

                    // Optional note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completion Note (Optional)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Any details the provider should know.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $note)
                            .frame(minHeight: 80)
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
                            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                            Text(error).font(.caption).foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Submit button
                    Button {
                        Task { await submit() }
                    } label: {
                        HStack(spacing: 8) {
                            if isSubmitting {
                                ProgressView().tint(.white).scaleEffect(0.85)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(isSubmitting
                                 ? (isUploadingPhoto ? "Uploading Photo…" : "Submitting…")
                                 : "I'm Done — Submit for Review")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(canSubmit ? Color.green : Color.green.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(!canSubmit)

                    if selectedPhoto == nil {
                        Text("A photo is required to submit completion.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
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
        guard let photo = selectedPhoto,
              let workerId = authManager.currentUserId else { return }

        isSubmitting = true
        isUploadingPhoto = true
        errorMessage = nil

        do {
            // Upload proof photo
            let photoURL = try await StorageService.shared.uploadCompletionProof(photo, serviceId: service.id, workerId: workerId)
            isUploadingPhoto = false

            let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
            try await applicationsStore.requestCompletion(
                serviceId: service.id,
                note: trimmedNote.isEmpty ? nil : trimmedNote,
                photoURL: photoURL
            )
            onSuccess?()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
            isUploadingPhoto = false
        }
    }
}
