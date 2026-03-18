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
                        Task {
                            await submitApplication()
                        }
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
                applicantId: currentUserId,
                applicantName: currentUser.displayName,
                applicantPhotoURL: currentUser.photoURL,
                coverMessage: coverMessage.isEmpty ? nil : coverMessage,
                proposedPrice: proposedPriceDouble
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
