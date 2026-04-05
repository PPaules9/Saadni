//
//  SubmitReviewSheet.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct SubmitReviewSheet: View {
    let service: JobService
    let revieweeId: String
    let revieweeName: String
    let reviewerRole: ReviewerRole

    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ReviewsStore.self) var reviewsStore

    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var isSubmitting: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var isFormValid: Bool {
        rating > 0 && rating <= 5
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Service context
                    VStack(spacing: 8) {
                        Text("Rate Your Experience")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Service: \(service.title)")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Review for: \(revieweeName)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // Star rating picker
                    VStack(spacing: 16) {
                        Text("How would you rate this experience?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        StarRatingPicker(rating: $rating, size: 50)

                        if rating > 0 {
                            Text(ratingDescription(rating))
                                .font(.caption)
                                .foregroundStyle(.yellow)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // Comment section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Review (Optional)")
                            .font(.subheadline)
                            .foregroundStyle(.gray)

                        TextEditor(text: $comment)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(8)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)

                        Text("\(comment.count)/500")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    Spacer()

                    // Submit button
                    Button {
                        Task {
                            await submitReview()
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
                            Text("Submit Review")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!isFormValid || isSubmitting)
                }
                .padding()
            }
            .background(Color(.systemGray6).opacity(0.1))
            .navigationTitle("Write a Review")
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
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func submitReview() async {
        guard let currentUserId = authManager.currentUserId,
              let currentUser = authManager.currentUser else {
            errorMessage = "You must be logged in to submit a review"
            showError = true
            return
        }

        isSubmitting = true

        let review = Review(
            serviceId: service.id,
            reviewerId: currentUserId,
            revieweeId: revieweeId,
            reviewerRole: reviewerRole,
            rating: rating,
            comment: comment.isEmpty ? nil : comment,
            reviewerName: currentUser.displayName,
            reviewerPhotoURL: currentUser.photoURL,
            revieweeName: revieweeName,
            serviceName: service.title
        )

        do {
            try await reviewsStore.submitReview(review)
            dismiss()
        } catch {
            errorMessage = "Failed to submit review: \(error.localizedDescription)"
            showError = true
            isSubmitting = false
        }
    }

    private func ratingDescription(_ stars: Int) -> String {
        switch stars {
        case 1:
            return "😞 Poor"
        case 2:
            return "😕 Fair"
        case 3:
            return "😐 Good"
        case 4:
            return "😊 Very Good"
        case 5:
            return "😄 Excellent"
        default:
            return ""
        }
    }
}

#Preview {
    SubmitReviewSheet(
        service: JobService.sampleData[0],
        revieweeId: "user-1",
        revieweeName: "Ahmed Hassan",
        reviewerRole: .seeker
    )
    .environment(AuthenticationManager(userCache: UserCache()))
    .environment(ReviewsStore())
}
