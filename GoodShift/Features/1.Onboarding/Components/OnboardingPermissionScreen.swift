//
//  OnboardingPermissionScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct OnboardingPermissionScreen: View {
    let icon: String          // SF Symbol
    let headline: String
    let subheadline: String
    let bullets: [String]
    let enableCTA: String
    let onEnable: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 100, height: 100)

                Image(systemName: icon)
                    .font(.system(size: 42, weight: .medium))
                    .foregroundStyle(Color.accentColor)
            }

            Spacer().frame(height: 32)

            // Headline
            Text(headline)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer().frame(height: 12)

            Text(subheadline)
                .font(.system(size: 16))
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            Spacer().frame(height: 32)

            // Bullet points
            VStack(alignment: .leading, spacing: 14) {
                ForEach(bullets, id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.accentColor)

                        Text(bullet)
                            .font(.system(size: 15))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            // CTAs
            VStack(spacing: 12) {
                BrandButton(enableCTA, size: .large, hasIcon: false, icon: "", secondary: false) {
                    onEnable()
                }
                .padding(.horizontal, 24)

                Button(action: onSkip) {
                    Text("Not now")
                        .font(.system(size: 15))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingPermissionScreen(
        icon: "location.fill",
        headline: "Find shifts near you",
        subheadline: "We'll show you jobs you can actually get to — no wasted commutes.",
        bullets: [
            "See shifts sorted by distance from you",
            "Filter by area or neighbourhood",
            "Get notified when a new shift opens near you"
        ],
        enableCTA: "Enable Location",
        onEnable: {},
        onSkip: {}
    )
    .background(Colors.swiftUIColor(.appBackground))
}
