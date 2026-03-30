//
//  ApplyJobSheet.swift
//  Saadni
//
//  Created by Claude Code on 15/03/2026.
//

import SwiftUI

struct ApplyJobSheet: View {
    let service: JobService

    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ApplicationsStore.self) var applicationsStore

    @State private var coverMessage = ""
    @State private var proposedPrice = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @State private var showProfileCompletionPopup = false
    @State private var profileCompletionPercentage = 0
    @State private var showEditProfile = false
    @State private var showPosterProfile = false
    @State private var posterUser: User?
    @State private var isLoadingPoster = false

    var isFormValid: Bool {
        // Form is always valid since both fields are optional
        !isSubmitting
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("Apply for This Job")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text(service.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // MARK: - Service Summary
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Image(systemName: "briefcase.fill")
                                .font(.title3)
                                .foregroundStyle(.accent)
                                .frame(width: 24)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Price")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text(service.formattedPrice)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }

                            Spacer()
                        }

                        HStack(spacing: 16) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundStyle(.accent)
                                .frame(width: 24)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Location")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text(service.location.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }

                            Spacer()
                        }

                        if let hours = service.estimatedDurationHours {
                            HStack(spacing: 16) {
                                Image(systemName: "clock.fill")
                                    .font(.title3)
                                    .foregroundStyle(.accent)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Duration")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    Text(String(format: "%.0f hours", hours))
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }

                                Spacer()
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(8)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // MARK: - Job Poster Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Job Poster")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Button(action: {
                            showPosterProfile = true
                        }) {
                            if let poster = posterUser {
                                HStack(spacing: 12) {
                                    // Poster photo
                                    if let photoURL = poster.photoURL, let url = URL(string: photoURL) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            Circle()
                                                .fill(Color(.systemGray5))
                                                .frame(width: 50, height: 50)
                                        }
                                    } else {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 50, height: 50)
                                            .overlay(Text("👤").font(.system(size: 24)))
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(poster.displayName ?? "Service Provider")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        if let bio = poster.bio {
                                            Text(bio)
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                                .lineLimit(2)
                                        }
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray)
                                }
                                .padding(12)
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(8)
                            } else if isLoadingPoster {
                                HStack(spacing: 12) {
                                    ProgressView()
                                        .tint(.accent)
                                    Text("Loading poster info...")
                                        .foregroundStyle(.gray)
                                }
                                .padding(12)
                            }
                        }
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // MARK: - Cover Message Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cover Message (Optional)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Text("Tell the job poster why you're interested and why you're a good fit")
                            .font(.caption)
                            .foregroundStyle(.gray.opacity(0.7))

                        TextEditor(text: $coverMessage)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(8)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)

                        Text("\(coverMessage.count)/500")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    // MARK: - Proposed Price Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Proposed Price (Optional)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        Text("Counter-offer a different price if needed")
                            .font(.caption)
                            .foregroundStyle(.gray.opacity(0.7))

                        HStack(spacing: 8) {
                            Image(systemName: "dollarsign")
                                .foregroundStyle(.accent)

                            TextField("Enter price", text: $proposedPrice)
                                .keyboardType(.decimalPad)
                                .foregroundStyle(.white)
                        }
                        .padding(12)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(8)

                        if !proposedPrice.isEmpty && Double(proposedPrice) == nil {
                            Text("Please enter a valid number")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }

                    Spacer()

                    // MARK: - Submit Button
                    Button {
                        handleSubmit()
                    } label: {
                        if isSubmitting {
                            HStack {
                                ProgressView()
                                    .tint(.white)
                                Text("Submitting...")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(12)
                            .foregroundStyle(.white)
                        } else {
                            Text("Submit Application")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!isFormValid)
                }
                .padding()
            }
            .background(Color(.systemGray6).opacity(0.1))
            .navigationTitle("Apply for Job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.blue)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Application Sent!", isPresented: $showSuccess) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Your application has been submitted successfully. The job poster will review it soon.")
            }
        }
        .sheet(isPresented: $showProfileCompletionPopup) {
            ProfileCompletionPopup(
                completionPercentage: profileCompletionPercentage,
                onComplete: {
                    showProfileCompletionPopup = false
                    showEditProfile = true
                },
                onDismiss: {
                    showProfileCompletionPopup = false
                }
            )
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet()
        }
        .sheet(isPresented: $showPosterProfile) {
            if let poster = posterUser {
                UserProfileSheet(userId: poster.id)
            }
        }
        .task {
            await loadPosterInfo()
        }
    }

    private func loadPosterInfo() async {
        isLoadingPoster = true
        do {
            posterUser = try await FirestoreService.shared.fetchUser(id: service.providerId)
        } catch {
            // Silently fail - poster info is optional
        }
        isLoadingPoster = false
    }

    private func handleSubmit() {
        guard let user = authManager.currentUser else { return }

        // Check JOB SEEKER profile completion (applying requires job seeker role)
        if user.jobSeekerCompletionPercentage < 100 {
            profileCompletionPercentage = user.jobSeekerCompletionPercentage
            showProfileCompletionPopup = true
            return
        }

        // Proceed with application
        Task {
            await submitApplication()
        }
    }

    private func submitApplication() async {
        guard let currentUserId = authManager.currentUserId,
              let currentUser = authManager.currentUser else {
            errorMessage = "You must be logged in to submit an application"
            showError = true
            return
        }

        // Validate proposed price if provided
        if !proposedPrice.isEmpty, Double(proposedPrice) == nil {
            errorMessage = "Please enter a valid price"
            showError = true
            return
        }

        isSubmitting = true

        do {
            let proposedPriceDouble = proposedPrice.isEmpty ? nil : Double(proposedPrice)

            try await applicationsStore.submitApplication(
                serviceId: service.id,
                providerId: service.providerId,
                applicantId: currentUserId,
                applicantName: currentUser.displayName,
                applicantPhotoURL: currentUser.photoURL,
                coverMessage: coverMessage.isEmpty ? nil : coverMessage
            )

            showSuccess = true
            isSubmitting = false
        } catch {
            errorMessage = "Failed to submit application: \(error.localizedDescription)"
            showError = true
            isSubmitting = false
        }
    }
}

#Preview {
    ApplyJobSheet(
        service: JobService.sampleData[0]
    )
    .environment(AuthenticationManager(userCache: UserCache()))
    .environment(ApplicationsStore())
}
