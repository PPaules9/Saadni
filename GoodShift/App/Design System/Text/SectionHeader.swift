//
//  SectionHeader.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/04/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var textColor: SemanticColor = .textMain
    var showViewAll: Bool = false
    var viewAllLabel: String = "See All"
    var onViewAllTap: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.headline)
                .fontDesign(.monospaced)
                .kerning(-1)
                .foregroundStyle(Colors.swiftUIColor(textColor))

            if showViewAll {
                Spacer()
                Button(action: { onViewAllTap?() }) {
                    Text(viewAllLabel)
                        .font(.subheadline)
                        .fontDesign(.monospaced)
                        .kerning(-0.5)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        SectionHeader(title: "Recent Activity")
        SectionHeader(title: "Open Shifts", showViewAll: true)
        SectionHeader(title: "My Jobs", textColor: .textSecondary, showViewAll: true, viewAllLabel: "View All")
    }
    .padding(24)
}
