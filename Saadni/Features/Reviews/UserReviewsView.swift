//
//  UserReviewsView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct UserReviewsView: View {
    let userId: String

    @Environment(ReviewsStore.self) var reviewsStore
    @Environment(AuthenticationManager.self) var authManager

    @State private var reviews: [Review] = []
    @State private var isLoading: Bool = true
    @State private var averageRating: Double?
    @State private var totalReviews: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Rating summary
                if totalReviews > 0 {
                    ReviewSummaryView(
                        averageRating: averageRating,
                        totalReviews: totalReviews
                    )
                    .padding()
                }

                // Reviews list
                if isLoading {
                    VStack {
                        ProgressView()
                            .tint(.white)
                        Text("Loading reviews...")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else if reviews.isEmpty {
                    ContentUnavailableView(
                        "No Reviews Yet",
                        systemImage: "star",
                        description: Text("Reviews will appear here after you complete services")
                    )
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Reviews")
        .background(Color(.systemGray6).opacity(0.1))
        .task {
            await loadReviews()
        }
    }

    private func loadReviews() async {
        isLoading = true

        // Get reviews from the store
        reviews = reviewsStore.getReviewsReceivedBy(userId: userId)

        // Calculate statistics
        averageRating = reviewsStore.getAverageRatingForUser(userId: userId)
        totalReviews = reviewsStore.getTotalReviewsForUser(userId: userId)

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        UserReviewsView(userId: "user-1")
            .environment(ReviewsStore())
            .environment(AuthenticationManager(userCache: UserCache()))
    }
}
