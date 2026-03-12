//
//  StarRatingPicker.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct StarRatingPicker: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    let size: CGFloat

    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...maxRating, id: \.self) { star in
                Button {
                    rating = star
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: size))
                        .foregroundStyle(star <= rating ? .yellow : .gray)
                }
            }
        }
    }
}

#Preview {
    @State var rating = 0

    return VStack(spacing: 20) {
        Text("Rate this experience")
            .font(.headline)

        StarRatingPicker(rating: $rating, size: 40)

        Text("Selected: \(rating) stars")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
    .padding()
    .background(Color(.systemGray6))
}
