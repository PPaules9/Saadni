//
//  PathB_PaywallScreen.swift
//  GoodShift
//
//  Placeholder paywall for the Service Provider path.
//  TODO: Connect to StoreKit when subscription product is configured.
//

import SwiftUI

struct PathB_PaywallScreen: View {
    let onContinue: () -> Void

    private let perks: [(icon: String, text: String)] = [
        ("infinity",               "Unlimited active shift posts"),
        ("line.3.horizontal.decrease.circle", "Advanced applicant filters — rating, experience, distance"),
        ("chart.bar.fill",         "Shift analytics and attendance reports"),
        ("message.fill",           "Direct message workers before confirming"),
        ("bolt.fill",              "Featured placement — your shifts appear first")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                // App mark
                Image(systemName: "building.2.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Colors.swiftUIColor(.primaryDark))

                Spacer().frame(height: 20)

                Text("GoodShift Pro —\nhire without limits")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 8)

                Text("Everything you need to staff your business, at scale.")
                    .font(.system(size: 15))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 28)

                // Perks
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(perks, id: \.text) { perk in
                        HStack(spacing: 14) {
                            Image(systemName: perk.icon)
                                .font(.system(size: 16))
                                .foregroundStyle(Colors.swiftUIColor(.primaryDark))
                                .frame(width: 28)

                            Text(perk.text)
                                .font(.system(size: 15))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Colors.swiftUIColor(.cardBackground))
                )
                .padding(.horizontal, 24)

                Spacer().frame(height: 24)

                // Testimonial
                OnboardingTestimonialCard(
                    testimonial: OnboardingTestimonial(
                        quote: "The analytics alone saved us from a no-show situation twice. We could see who was likely to confirm and who wasn't.",
                        name: "Nadia F.",
                        tag: "Operations Lead"
                    )
                )
                .padding(.horizontal, 24)

                Spacer().frame(height: 28)

                // Price
                VStack(spacing: 4) {
                    Text("299 EGP / month")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                    Text("Try free for 14 days — cancel anytime")
                        .font(.system(size: 13))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                Spacer().frame(height: 20)

                // CTA
                // TODO: Replace onContinue with StoreKit purchase when product is configured
                BrandButton("Start Free Trial", size: .large, hasIcon: false, icon: "", secondary: false) {
                    AnalyticsService.shared.track(.paywallTrialStarted(role: "provider"))
                    onContinue()
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 12)

                Button(action: {
                    AnalyticsService.shared.track(.paywallDismissed(role: "provider"))
                    onContinue()
                }) {
                    Text("Maybe later")
                        .font(.system(size: 14))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                Spacer().frame(height: 8)

                Button(action: {
                    // TODO: StoreKit restore purchases
                }) {
                    Text("Restore purchases")
                        .font(.system(size: 13))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.7))
                }

                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            AnalyticsService.shared.track(.paywallViewed(role: "provider"))
        }
    }
}
