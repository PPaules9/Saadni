//
//  ReviewCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with reviewer info
            HStack(spacing: 12) {
                // Avatar
                if let photoURL = review.reviewerPhotoURL, !photoURL.isEmpty {
                    AsyncImage(url: URL(string: photoURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .empty:
                            ProgressView()
                        case .failure:
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.gray)
                        @unknown default:
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 32))
                        }
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundStyle(.white)
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.reviewerName ?? "Anonymous")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(review.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Spacer()

                // Star rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(star <= review.rating ? .yellow : .gray)
                    }
                }
            }

            // Review comment
            if let comment = review.comment, !comment.isEmpty {
                Text(comment)
                    .font(.body)
                    .foregroundStyle(.white)
                    .lineLimit(nil)
            }

            // Service context
            if let serviceName = review.serviceName {
                Text("For: \(serviceName)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
}

#Preview {
    ReviewCard(
        review: Review(
            serviceId: "service-1",
            reviewerId: "user-1",
            revieweeId: "user-2",
            reviewerRole: .provider,
            rating: 5,
            comment: "Excellent work! Very professional and completed the task ahead of schedule.",
            reviewerName: "Ahmed Hassan",
            reviewerPhotoURL: nil,
            revieweeName: "Fatima Khalil",
            serviceName: "Home Cleaning Service"
        )
    )
    .padding()
    .background(Color(.systemGray6))
}
