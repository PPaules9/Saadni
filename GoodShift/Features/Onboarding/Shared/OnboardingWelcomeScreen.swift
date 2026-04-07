//
//  OnboardingWelcomeScreen.swift
//  GoodShift
//

import SwiftUI

struct OnboardingWelcomeScreen: View {
    let onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Hero illustration
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.08))
                    .frame(width: 260, height: 260)

                Circle()
                    .fill(Color.accentColor.opacity(0.14))
                    .frame(width: 200, height: 200)

                VStack(spacing: 8) {
                    Image(systemName: "hands.and.sparkles.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(Color.accentColor)

                    // Mini shift card preview
                    HStack(spacing: 8) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.accentColor)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Barista · CFC Branch")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            Text("250 EGP · 6h")
                                .font(.system(size: 11))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        }

                        Spacer()

                        Text("Apply")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.accentColor))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.swiftUIColor(.cardBackground))
                            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                }
            }

            Spacer().frame(height: 48)

            // Headline block
            VStack(spacing: 14) {
                Text("Your next shift\nstarts here.")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)

                Text("Find work that fits your life, or find the right people for the job — in minutes.")
                    .font(.system(size: 16))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }

            Spacer()

            // CTAs
            VStack(spacing: 12) {
                BrandButton("Get Started", size: .large, hasIcon: false, icon: "", secondary: false) {
                    onGetStarted()
                }
                .padding(.horizontal, 24)

                // Sign in handled after onboarding is complete
            }
            .padding(.bottom, 48)
        }
    }
}

#Preview {
    OnboardingWelcomeScreen {}
        .background(Colors.swiftUIColor(.appBackground))
}
