//
//  TermsAndConditionsView.swift
//  GoodShift
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terms & Conditions")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        Text("Last updated: April 2026  ·  Effective: April 2026")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text("Please read these terms carefully before using GoodShift. By creating an account or using the app, you agree to be bound by them.")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    TermsSection(number: "1", title: "Who We Are") {
                        Text("GoodShift is a gig-shift marketplace operated by **Nethrope**, a software company registered in Egypt. We connect job seekers with businesses that need short-term staff for shifts.\n\nRegistered Company: Nethrope\nCountry: Egypt\nWebsite: www.nethrope.com\nSupport: pavlypaules9@gmail.com")
                    }

                    TermsSection(number: "2", title: "Eligibility & Accounts") {
                        Text("You may use GoodShift regardless of age. You are responsible for providing accurate information when registering, including your full name, mobile number, valid national ID, and a selfie for identity verification.\n\nEach person may hold one account. Creating multiple accounts is a violation that will result in all accounts being permanently banned.")
                    }

                    TermsSection(number: "3", title: "Two Roles: Job Seekers & Providers") {
                        Text("**Job Seekers (Workers):** Browse available shifts, apply, and earn money through the GoodShift wallet once a shift is completed and confirmed.\n\n**Service Providers (Businesses):** Post shifts, set pay rates, review applicants, and hire workers. Providers must pre-fund the shift payment before a worker can be hired. GoodShift charges a commission from the provider on each completed shift.")
                    }

                    TermsSection(number: "4", title: "Payment & Commissions") {
                        Text("Providers are required to pay in full before hiring any worker. Funds are held securely in the GoodShift wallet until the shift is completed and confirmed.\n\nGoodShift deducts a platform commission from the provider's payment. The remaining amount is transferred to the worker's GoodShift wallet upon shift completion.\n\nAll transactions are processed through the GoodShift platform. Any attempt to bypass platform payments is a serious violation of these terms.")
                    }

                    TermsSection(number: "5", title: "Cancellation Policy") {
                        Text("**Before hiring a worker:** A provider may cancel a posted shift at any time and will receive a full refund to their wallet.\n\n**After hiring a worker:** A shift cannot be cancelled or deleted once a worker has been accepted. This protects the worker's commitment and expected income.\n\nIf exceptional circumstances arise, contact support at pavlypaules9@gmail.com and we will review the case manually.")
                    }

                    TermsSection(number: "6", title: "No-Show & Strike Policy") {
                        Text("Workers are expected to honour every shift they accept. If a worker fails to show up for a confirmed shift without prior notice:\n\n• 1st no-show: 1 Strike — account status becomes Risky\n• 2nd no-show: 2 Strikes — account status becomes Critical\n• 3rd no-show: Account permanently banned\n\nWhen a worker no-show is confirmed, the provider receives:\n① A full refund of the job fee paid\n② One complimentary job boost credit\n\nStrikes are visible to the worker in their profile. GoodShift reserves the right to ban accounts immediately for severe violations.")
                    }

                    TermsSection(number: "7", title: "Ratings & Reviews") {
                        Text("After each completed shift, both workers and providers may leave a public rating (out of 5) and written review. Ratings affect visibility and trust scores on the platform.\n\nReviews must be honest and based on real experiences. GoodShift may remove reviews that contain false information, personal attacks, or violate our Community Guidelines.")
                    }

                    TermsSection(number: "8", title: "User Content & Uploads") {
                        Text("You may upload a profile photo and, if you are a provider, images for your job postings. By uploading content, you grant GoodShift a non-exclusive, royalty-free licence to display it within the app.\n\nYou are responsible for ensuring that any photos you upload do not infringe third-party rights and comply with our Community Guidelines.")
                    }

                    TermsSection(number: "9", title: "Prohibited Conduct") {
                        Text("You must not:\n• Post false, misleading, or fraudulent shifts\n• Use the platform for any illegal activity\n• Harass, threaten, or discriminate against other users\n• Attempt to access other users' accounts\n• Scrape, copy, or reproduce platform data\n• Bypass platform payments\n\nViolations may result in immediate account termination without refund.")
                    }

                    TermsSection(number: "10", title: "Limitation of Liability") {
                        Text("GoodShift acts as a marketplace — we do not employ workers or guarantee shift quality. We are not liable for any losses arising from worker no-shows, provider non-payment, or disputes between users, beyond what is covered by our refund and strike policies.\n\nOur total liability to you in any circumstance shall not exceed the amount you paid to GoodShift in the 30 days preceding the event giving rise to the claim.")
                    }

                    TermsSection(number: "11", title: "Account Termination") {
                        Text("You may delete your account at any time from the Profile section. GoodShift may terminate or suspend any account that violates these terms, with or without prior notice.\n\nUpon termination, any pending wallet balance will be processed according to our payout schedule. Earned funds will not be forfeited unless the termination is due to fraud.")
                    }

                    TermsSection(number: "12", title: "Governing Law") {
                        Text("These terms are governed by the laws of the Arab Republic of Egypt. Any disputes shall be subject to the exclusive jurisdiction of the Egyptian courts.")
                    }

                    TermsSection(number: "13", title: "Changes to These Terms") {
                        Text("We may update these terms from time to time. When we do, we will notify you via the app and update the effective date above. Continued use of GoodShift after changes take effect constitutes acceptance of the updated terms.")
                    }

                    TermsSection(number: "14", title: "Contact Us") {
                        Text("Questions about these terms?\n\nEmail: pavlypaules9@gmail.com\nWebsite: www.nethrope.com\nCompany: Nethrope, Egypt")
                    }
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Terms Section Component

private struct TermsSection<Content: View>: View {
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

#Preview {
    NavigationStack {
        TermsAndConditionsView()
    }
}
