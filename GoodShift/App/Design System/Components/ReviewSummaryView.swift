//
//  ReviewSummaryView.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ReviewSummaryView: View {
    let averageRating: Double?
    let totalReviews: Int

    var body: some View {
        HStack(spacing: 12) {
            // Large rating number
            if let rating = averageRating {
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)

                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: Double(star) <= rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundStyle(Double(star) <= rating ? .yellow : .gray)
                        }
                    }
                }
            } else {
                Text("No ratings")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            // Review count
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(totalReviews)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(totalReviews == 1 ? "Review" : "Reviews")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.2))
        .cornerRadius(16)
    }
}

#Preview {
    VStack(spacing: 20) {
        ReviewSummaryView(averageRating: 4.5, totalReviews: 12)
        ReviewSummaryView(averageRating: nil, totalReviews: 0)
    }
    .padding()
    .background(Color(.systemGray6))
}
