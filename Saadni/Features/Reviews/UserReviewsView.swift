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

    var reviews: [Review] {
        reviewsStore.getReviewsReceivedBy(userId: userId)
    }

    var isLoading: Bool {
        reviewsStore.isLoadingReviews
    }

    var averageRating: Double? {
        reviewsStore.getAverageRatingForUser(userId: userId)
    }

    var totalReviews: Int {
        reviewsStore.getTotalReviewsForUser(userId: userId)
    }

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
        .refreshable {
            // Manual refresh: listeners update data automatically, but users can pull-to-refresh
            try? await Task.sleep(nanoseconds: 500_000_000) // Brief pause for UX
        }
    }

}

#Preview {
    NavigationStack {
        UserReviewsView(userId: "user-1")
            .environment(ReviewsStore())
            .environment(AuthenticationManager(userCache: UserCache()))
    }
}
