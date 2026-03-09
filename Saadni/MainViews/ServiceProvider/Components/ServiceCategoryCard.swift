//
//  ServiceCategoryCard.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct ServiceCategoryCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 80)
                .clipped()
                .cornerRadius(8)

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(height: 32, alignment: .topLeading)
        }
        .padding(8)
        
        
    }
}

#Preview {
    ServiceCategoryCard(
        title: "TV Mounting",
        imageName: "tv_mounting"
    )
    .background(
     RoundedRectangle(cornerRadius: 24)
      .fill(.accent)
    )
    .padding()
}
