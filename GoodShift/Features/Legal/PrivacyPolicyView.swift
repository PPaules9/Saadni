//
//  PrivacyPolicyView.swift
//  GoodShift
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        Text("Last updated: April 2026  ·  Effective: April 2026")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text("Nethrope (\"we\", \"us\", \"our\") operates the GoodShift app. This policy explains what data we collect, why we collect it, and how we protect it.")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    PrivacySection(number: "1", title: "What We Collect") {
                        VStack(alignment: .leading, spacing: 12) {
                            PrivacyDataRow(
                                label: "Identity",
                                value: "Full name, national ID (NID), face selfie — used for identity verification only"
                            )
                            PrivacyDataRow(
                                label: "Contact",
                                value: "Email address and mobile phone number"
                            )
                            PrivacyDataRow(
                                label: "Profile photo",
                                value: "A photo you choose to display publicly on your profile"
                            )
                            PrivacyDataRow(
                                label: "Location",
                                value: "Approximate location when you use the app, to show nearby jobs or workers (only while the app is in use)"
                            )
                            PrivacyDataRow(
                                label: "Wallet & payments",
                                value: "Transaction records within the GoodShift wallet"
                            )
                            PrivacyDataRow(
                                label: "Usage data",
                                value: "App interactions, pages visited, and feature usage — to improve the product"
                            )
                            PrivacyDataRow(
                                label: "Device",
                                value: "Device model, OS version, and push notification token (FCM) for delivering notifications"
                            )
                        }
                    }

                    PrivacySection(number: "2", title: "Why We Collect It") {
                        Text("We use your data to:\n\n• Verify your identity and prevent fraud\n• Match workers with suitable shifts and providers with suitable workers\n• Process payments through the GoodShift wallet\n• Send you shift alerts, application updates, and important account notifications\n• Calculate your ratings, strikes, and trust score\n• Improve app features and fix bugs\n• Comply with Egyptian law and respond to lawful requests")
                    }

                    PrivacySection(number: "3", title: "Who We Share It With") {
                        Text("We do not sell your personal data. We share data only with:\n\n**Google / Firebase:** Our backend infrastructure provider (Firestore database, file storage, push notifications). Data is processed under Google's Data Processing Agreement.\n\n**Other users:** Your public profile (name, photo, rating, reviews) is visible to other GoodShift users. Your NID, selfie, and financial details are never shared publicly.\n\n**Legal authorities:** If required by Egyptian law or a court order, we may disclose data to competent authorities.")
                    }

                    PrivacySection(number: "4", title: "Identity Verification Data") {
                        Text("Your national ID and face selfie are collected solely for the purpose of verifying that you are a real person. This data is stored securely and is never displayed publicly. It is not used for advertising or shared with third parties beyond our verification process.\n\nIf you delete your account, this data is permanently erased within 30 days.")
                    }

                    PrivacySection(number: "5", title: "Data Retention") {
                        Text("We keep your data for as long as your account is active. If you delete your account:\n\n• Profile and personal data: deleted within 30 days\n• Transaction records: retained for 5 years as required by Egyptian financial regulations\n• Reviews: anonymised and may remain visible without linking to your identity")
                    }

                    PrivacySection(number: "6", title: "Your Rights") {
                        Text("You have the right to:\n\n• **Access** the data we hold about you\n• **Correct** inaccurate data at any time (via Edit Profile)\n• **Delete** your account and data (via Profile → Delete Account)\n• **Object** to how we use your data for purposes beyond service delivery\n\nTo exercise any of these rights, contact us at pavlypaules9@gmail.com.")
                    }

                    PrivacySection(number: "7", title: "Security") {
                        Text("We use industry-standard security measures to protect your data, including encrypted transmission (HTTPS/TLS), Firebase security rules, and restricted access controls. However, no system is 100% secure — please use a strong, unique password for your account.")
                    }

                    PrivacySection(number: "8", title: "Children's Privacy") {
                        Text("GoodShift does not knowingly collect data from children under 13. If you believe a child's data has been submitted without parental consent, please contact us immediately and we will delete it promptly.")
                    }

                    PrivacySection(number: "9", title: "Changes to This Policy") {
                        Text("We may update this policy from time to time. We will notify you in-app when significant changes are made. The effective date at the top of this page will always reflect the latest version.")
                    }

                    PrivacySection(number: "10", title: "Contact Us") {
                        Text("Privacy questions or requests:\n\nEmail: pavlypaules9@gmail.com\nWebsite: www.nethrope.com\nCompany: Nethrope, Egypt")
                    }
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Components

private struct PrivacySection<Content: View>: View {
    let number: String
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(number + ".")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.accent)
                    .frame(width: 24, alignment: .leading)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            content
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 32)
        }
    }
}

private struct PrivacyDataRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label + ":")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .frame(width: 90, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
