//
//  CommunityGuidelinesView.swift
//  GoodShift
//

import SwiftUI

struct CommunityGuidelinesView: View {
    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Community Guidelines")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        Text("Last updated: April 2026")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text("GoodShift is built on trust. These guidelines keep our community safe, fair, and professional for everyone — job seekers and providers alike.")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    GuidelineSection(
                        icon: "hands.and.sparkles.fill",
                        title: "Respect Everyone",
                        bodyContent: "Treat every person on GoodShift with dignity. Harassment, discrimination, hate speech, or offensive language — whether based on gender, religion, nationality, age, or anything else — will result in immediate account suspension."
                    )

                    GuidelineSection(
                        icon: "clock.fill",
                        title: "Show Up & Follow Through",
                        bodyContent: "Workers: if you accept a shift, show up on time and do your best work. Missing a confirmed shift without notice is a strike against your account. Three strikes and your account is permanently banned.\n\nProviders: if you post a shift, you're committing to it. You cannot cancel a shift once a worker has been hired."
                    )

                    GuidelineSection(
                        icon: "checkmark.seal.fill",
                        title: "Be Honest",
                        bodyContent: "Create one account per person and represent yourself truthfully. Don't misrepresent your skills, experience, or identity. Providers must accurately describe the work, location, pay, and hours for every shift posted."
                    )

                    GuidelineSection(
                        icon: "star.fill",
                        title: "Leave Fair Reviews",
                        bodyContent: "Reviews help the whole community make better decisions. Leave honest, factual ratings based on your real experience. Do not threaten, bribe, or coerce anyone into giving you a positive review. Fake or retaliatory reviews will be removed."
                    )

                    GuidelineSection(
                        icon: "banknote.fill",
                        title: "Keep Payments on Platform",
                        bodyContent: "All payments must go through GoodShift's wallet. Attempting to move payments outside the platform to avoid fees is a violation of our terms and will result in account removal for both parties."
                    )

                    GuidelineSection(
                        icon: "lock.shield.fill",
                        title: "Protect Privacy",
                        bodyContent: "Do not share another user's personal information (phone number, address, ID, photos) with third parties. Any data you access through GoodShift is strictly for the purpose of completing the shift — nothing else."
                    )

                    GuidelineSection(
                        icon: "exclamationmark.triangle.fill",
                        title: "Report Problems",
                        bodyContent: "If you witness or experience a violation of these guidelines, please report it through the app or email us at pavlypaules9@gmail.com. We review every report and take action seriously."
                    )

                    GuidelineSection(
                        icon: "hammer.fill",
                        title: "Consequences",
                        bodyContent: "Violations may result in a warning, temporary suspension, or permanent ban depending on severity. GoodShift reserves the right to remove any account that endangers or degrades the community."
                    )

                    Text("By using GoodShift, you agree to uphold these standards. Thank you for being part of a community that works.")
                        .font(.footnote)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .padding(.top, 4)
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Community Guidelines")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Section Component

private struct GuidelineSection: View {
    let icon: String
    let title: String
    let bodyContent: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.accent)
                    .frame(width: 24)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            Text(bodyContent)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 34)
        }
    }
}

#Preview {
    NavigationStack {
        CommunityGuidelinesView()
    }
}
