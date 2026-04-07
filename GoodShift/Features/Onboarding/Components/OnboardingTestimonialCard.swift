//
//  OnboardingTestimonialCard.swift
//  GoodShift
//

import SwiftUI

struct OnboardingTestimonial {
    let quote: String
    let name: String
    let tag: String   // e.g. "University student · Food & Beverage"
}

struct OnboardingTestimonialCard: View {
    let testimonial: OnboardingTestimonial

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Stars
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.yellow)
                }
            }

            Text("\(testimonial.quote)")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                // Avatar initials circle
                Text(initials(from: testimonial.name))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.accentColor))

                VStack(alignment: .leading, spacing: 2) {
                    Text(testimonial.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text(testimonial.tag)
                        .font(.system(size: 12))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Colors.swiftUIColor(.cardBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.12), lineWidth: 1)
        )
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let letters = parts.compactMap { $0.first }.prefix(2)
        return String(letters).uppercased()
    }
}
