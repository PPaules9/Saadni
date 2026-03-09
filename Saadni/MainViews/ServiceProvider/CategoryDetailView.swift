//
//  CategoryDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CategoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    let category: ServiceCategory

    var body: some View {
        VStack(spacing: 20) {
            Text(category.title)
                .font(.title2)
                .fontWeight(.bold)

            Text("Category details will appear here")
                .font(.body)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CategoryDetailView(
        category: ServiceCategory(
            title: "TV Mounting",
            imageName: "tv_mounting",
            backgroundColor: .blue
        )
    )
}
