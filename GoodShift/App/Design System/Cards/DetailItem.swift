//
//  DetailItem.swift
//  GoodShift
//
//  A single icon + label + value row used inside detail views.
//  label is caption/secondary, value is subheadline/primary.
//

import SwiftUI

struct DetailItem: View {
    let icon: String
    let label: String
    let value: String
    var labelColor: SemanticColor = .textSecondary
    var valueColor: SemanticColor = .textMain

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.accent)
                .font(.subheadline)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Colors.swiftUIColor(labelColor))
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.swiftUIColor(valueColor))
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    VStack {
        DetailItem(icon: "mappin.and.ellipse", label: "Location", value: "Cairo, Egypt")
        DetailItem(icon: "calendar", label: "Service Date", value: "Apr 20, 2026")
        DetailItem(icon: "clock.fill", label: "Duration", value: "4 hours")
        DetailItem(icon: "person.2.fill", label: "Workers Needed", value: "2",
                   labelColor: .textSecondary, valueColor: .primary)
    }
    .padding(24)
}
