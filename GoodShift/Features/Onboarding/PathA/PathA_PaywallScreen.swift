//
//  PathA_PaywallScreen.swift
//  GoodShift
//
//  Placeholder paywall for the Job Seeker path.
//  TODO: Connect to StoreKit when subscription product is configured.
//

import SwiftUI

struct PathA_PaywallScreen: View {
    let onContinue: () -> Void

    private let perks: [(icon: String, text: String)] = [
        ("star.fill",              "Featured badge on your profile"),
        ("chart.line.uptrend.xyaxis", "Priority placement in search results"),
        ("bell.fill",              "Early access to shifts before they go public"),
        ("message.fill",           "Direct message employers before applying")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                // App mark
                Image(systemName: "hands.and.sparkles.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.accentColor)

                Spacer().frame(height: 20)

                Text("Get hired faster with\nGoodShift Featured")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 8)

                Text("Stand out from other applicants and get to the top of every employer's list.")
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
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 28)

                            Text(perk.text)
                                .font(.system(size: 15))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
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
                        quote: "I got my first shift within 24 hours of going Featured. Worth every pound.",
                        name: "Ahmed M.",
                        tag: "Logistics"
                    )
                )
                .padding(.horizontal, 24)

                Spacer().frame(height: 28)

                // Price block
                VStack(spacing: 4) {
                    Text("49 EGP / month")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text("Try free for 7 days — cancel anytime")
                        .font(.system(size: 13))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                Spacer().frame(height: 20)

                // CTA
                // TODO: Replace onContinue with StoreKit purchase when product is configured
                BrandButton("Start Free Trial", size: .large, hasIcon: false, icon: "", secondary: false) {
                    AnalyticsService.shared.track(.paywallTrialStarted(role: "job_seeker"))
                    onContinue()
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 12)

                Button(action: {
                    AnalyticsService.shared.track(.paywallDismissed(role: "job_seeker"))
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
            AnalyticsService.shared.track(.paywallViewed(role: "job_seeker"))
        }
    }
}
