//
//  HelpFAQView.swift
//  GoodShift
//

import SwiftUI

struct HelpFAQView: View {

    private let faqGroups: [FAQGroup] = [
        FAQGroup(title: "Getting Started", items: [
            FAQItem(
                question: "How does GoodShift work?",
                answer: "GoodShift connects workers looking for short-term shifts with businesses that need extra staff. Workers browse and apply to open shifts; providers post shifts, review applicants, and hire. Payments flow through the in-app wallet so everything stays safe and transparent."
            ),
            FAQItem(
                question: "Who can use GoodShift?",
                answer: "Anyone can sign up as a worker or a provider. You can even hold both roles on the same account and switch between them anytime from your Profile."
            ),
            FAQItem(
                question: "What documents do I need to register?",
                answer: "You'll need a valid national ID (NID), a clear face selfie for identity verification, and a working mobile number. Your NID and selfie are never displayed publicly — they're used only to verify you are a real person."
            ),
        ]),

        FAQGroup(title: "For Workers", items: [
            FAQItem(
                question: "How do I get paid?",
                answer: "When a provider confirms your shift is complete, the payment is released to your GoodShift wallet. You can then withdraw it to your bank account or keep it in the wallet for future use."
            ),
            FAQItem(
                question: "What is a strike?",
                answer: "A strike is issued when you accept a shift and do not show up without prior notice. You can receive up to 2 strikes before your account is permanently banned on the 3rd. You can always see your current strike count in your Profile."
            ),
            FAQItem(
                question: "What happens if I can't make it to a shift?",
                answer: "Contact the provider as soon as possible through the in-app chat. While we understand emergencies happen, failing to show up without any notice counts as a no-show and results in a strike."
            ),
            FAQItem(
                question: "Can a provider leave me a bad review unfairly?",
                answer: "Reviews must be honest and based on real experiences. If you believe a review violates our Community Guidelines, contact us at pavlypaules9@gmail.com and we'll investigate."
            ),
        ]),

        FAQGroup(title: "For Providers", items: [
            FAQItem(
                question: "How do I post a shift?",
                answer: "Tap the '+' button on your home screen, fill in the shift details (category, description, location, hours, and pay), then publish. Your shift will be visible to workers immediately."
            ),
            FAQItem(
                question: "Do I pay before or after hiring?",
                answer: "You pay before. GoodShift requires full payment upfront before you can hire any worker. This protects both you and the worker — your funds are held securely in escrow until the shift is completed."
            ),
            FAQItem(
                question: "Can I cancel a shift after posting it?",
                answer: "Yes, but only before you hire someone. Once a worker has been accepted for a shift, cancellation is not available. If you need help with an exceptional case, reach out to support."
            ),
            FAQItem(
                question: "What if a worker doesn't show up?",
                answer: "If a worker is a no-show, you will receive a full refund of the shift fee plus one free job boost credit. The worker also receives a strike against their account."
            ),
            FAQItem(
                question: "What commission does GoodShift charge?",
                answer: "GoodShift charges a platform commission on each completed shift. The exact percentage is shown clearly before you confirm payment when posting a shift."
            ),
        ]),

        FAQGroup(title: "Payments & Wallet", items: [
            FAQItem(
                question: "Is my money safe in the GoodShift wallet?",
                answer: "Yes. All funds are held securely and only released when a shift is completed and confirmed. GoodShift acts as an escrow — neither party can access the funds until the conditions are met."
            ),
            FAQItem(
                question: "How long does a refund take?",
                answer: "Refunds for cancelled shifts (before hiring) are processed instantly back to your wallet. Disputes and exceptional refunds may take 3–5 business days after review."
            ),
        ]),

        FAQGroup(title: "Account & Safety", items: [
            FAQItem(
                question: "How do I report a user?",
                answer: "You can report any user from their public profile or through your shift details page. Tap the three-dot menu and select 'Report'. Alternatively, email us directly at pavlypaules9@gmail.com."
            ),
            FAQItem(
                question: "How do I delete my account?",
                answer: "Go to Profile → Delete Account. You'll be asked to confirm with your password. Your data will be permanently erased within 30 days, and any pending wallet balance will be processed before deletion."
            ),
            FAQItem(
                question: "Is my national ID stored securely?",
                answer: "Absolutely. Your NID and face selfie are encrypted and stored securely on our servers. They are never displayed publicly and are only used for identity verification. If you delete your account, this data is erased within 30 days."
            ),
        ]),
    ]

    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Help & FAQ")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        Text("Find quick answers to the most common questions below.")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }

                    Divider()

                    // FAQ Groups
                    ForEach(faqGroups) { group in
                        FAQGroupView(group: group)
                    }

                    Divider()

                    // Contact Us
                    ContactUsCard()
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - FAQ Group

private struct FAQGroupView: View {
    let group: FAQGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(group.title)
                .font(.headline)
                .foregroundStyle(.accent)

            VStack(spacing: 0) {
                ForEach(group.items) { item in
                    FAQItemRow(item: item)

                    if item.id != group.items.last?.id {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
        }
    }
}

// MARK: - FAQ Item Row (Toggle)

private struct FAQItemRow: View {
    let item: FAQItem
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Text(item.question)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(item.answer)
                    .font(.subheadline)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Contact Us Card

private struct ContactUsCard: View {
    private let supportEmail = "pavlypaules9@gmail.com"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.accent)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Still need help?")
                        .font(.headline)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text("Our team is happy to assist you.")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }

            Button {
                if let url = URL(string: "mailto:\(supportEmail)?subject=GoodShift%20Support") {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack {
                    Image(systemName: "envelope.badge.fill")
                    Text("Contact Us")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }

            Text("Typically replies within 24 hours on business days.")
                .font(.caption)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(20)
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
    }
}

// MARK: - Models

private struct FAQGroup: Identifiable {
    let id = UUID()
    let title: String
    let items: [FAQItem]
}

private struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

#Preview {
    NavigationStack {
        HelpFAQView()
    }
}
