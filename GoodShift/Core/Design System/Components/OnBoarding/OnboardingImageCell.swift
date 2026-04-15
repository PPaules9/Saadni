//
//  OnboardingImageCell.swift
//  GoodShift
//

import SwiftUI

struct OnboardingImageCell: View {
    let imageName: String
    let label: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .clipped()

            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .padding(.horizontal, 8)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Colors.swiftUIColor(.cardBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 2.5)
        )
        .overlay(alignment: .topTrailing) {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.accent)
                    .background(Circle().fill(Colors.swiftUIColor(.appBackground)).padding(2))
                    .padding(8)
            }
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }
}
