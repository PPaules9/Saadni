//
//  SectionCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    var titleColor: SemanticColor = .textMain
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                Text(title)
                    .font(.headline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Colors.swiftUIColor(titleColor))
            }

            content()
                .padding(14)
                .background(Colors.swiftUIColor(.cardBackground))
                .cornerRadius(12)
        }
    }
}

#Preview {
    SectionCard(title: "Job Details", icon: "briefcase.fill") {
        Text("Content goes here")
            .font(.subheadline)
    }
    .padding(24)
}
