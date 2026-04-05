//
//  UserPerformanceView.swift
//  GoodShift
//
//  Created by Pavly Paules on 04/04/2026.
//

import SwiftUI

struct UserPerformanceView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ReviewsStore.self) var reviewsStore
    @Environment(ApplicationsStore.self) var applicationsStore
    @Environment(ServicesStore.self) var servicesStore

    @State private var selectedRole: UserRole = .provider

    private var user: User? { authManager.currentUser }
    private var isDualRole: Bool {
        (user?.isServiceProvider ?? false) && (user?.isJobSeeker ?? false)
    }

    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if isDualRole {
                        Picker("Role", selection: $selectedRole) {
                            Text("Worker").tag(UserRole.provider)
                            Text("Employer").tag(UserRole.jobSeeker)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    }

                    if let user {
                        if selectedRole == .provider {
                            workerSections(user: user)
                        } else {
                            employerSections(user: user)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Performance")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let user {
                selectedRole = user.isServiceProvider ? .provider : .jobSeeker
            }
        }
    }

    // MARK: - Worker Sections

    @ViewBuilder
    private func workerSections(user: User) -> some View {
        let score = UserScoreCalculator.calculateProviderScore(for: user)
        let userId = user.id
        let avgRating = reviewsStore.getAverageRatingForUser(userId: userId)
        let totalReviews = reviewsStore.getTotalReviewsForUser(userId: userId)

        // 1. Earnings
        sectionCard(title: "Earnings", icon: "banknote.fill") {
            statRow(icon: "dollarsign.circle.fill", label: "Total Earned", value: user.totalEarnings.map { formatCurrency($0) } ?? "—")
            divider()
            statRow(icon: "calendar", label: "This Month", value: user.monthlyEarnings.map { formatCurrency($0) } ?? "—")
            divider()
            statRow(icon: "wallet.pass.fill", label: "Wallet Balance", value: user.walletBalance.map { formatCurrency($0) } ?? "—")
            divider()
            statRow(icon: "timer", label: "Avg Hourly Rate", value: user.avgHourlyRate.map { formatCurrency($0) + "/hr" } ?? "—")
        }

        // 2. Reputation
        reputationCard(userId: userId, avgRating: avgRating, totalReviews: totalReviews, reviewLabel: "review")

        // 3. Trust Score
        sectionCard(title: "Trust Score", icon: "shield.fill") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                    Text("/ 100")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    Spacer()
                    verificationBadge(level: user.verificationLevel)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 8)
                        Capsule()
                            .fill(scoreColor(score: score))
                            .frame(width: geo.size.width * CGFloat(score) / 100, height: 8)
                    }
                }
                .frame(height: 8)

                if user.isTrustedProvider {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                        Text("Trusted Provider")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
            }
            .padding(16)
        }

        // 4. Work Stats
        sectionCard(title: "Work Stats", icon: "briefcase.fill") {
            statRow(icon: "checkmark.circle.fill", label: "Jobs Completed", value: "\(user.totalJobsCompleted)", iconColor: .green)
            divider()
            statRow(
                icon: "chart.line.uptrend.xyaxis",
                label: "Completion Rate",
                value: user.completionRate.map { String(format: "%.0f%%", $0) } ?? "—"
            )
            divider()
            statRow(
                icon: "hand.thumbsup.fill",
                label: "Acceptance Rate",
                value: user.acceptanceRate.map { String(format: "%.0f%%", $0) } ?? "—"
            )
            divider()
            statRow(
                icon: "clock.fill",
                label: "Avg Response Time",
                value: user.averageResponseTime.map { formatDuration($0) } ?? "—",
                iconColor: Colors.swiftUIColor(.textSecondary)
            )
        }

        // 5. Completed Work
        sectionCard(title: "Completed Work", icon: "checkmark.circle.fill") {
            NavigationLink {
                CompletedServicesView()
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.totalJobsCompleted)")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.accent)
                        Text("View finished services")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .padding(16)
            }
        }

        // 6. Profile Strength
        profileStrengthCard(percentage: user.providerCompletionPercentage, role: .provider)
    }

    // MARK: - Employer Sections

    @ViewBuilder
    private func employerSections(user: User) -> some View {
        let received = applicationsStore.receivedApplications
        let pending   = received.filter { $0.status == .pending }.count
        let accepted  = received.filter { $0.status == .accepted }.count
        let rejected  = received.filter { $0.status == .rejected }.count
        let completed = received.filter { $0.status == .completed }.count
        let userId = user.id
        let avgRating    = reviewsStore.getAverageRatingForUser(userId: userId)
        let totalReviews = reviewsStore.getTotalReviewsForUser(userId: userId)

        // 1. Spending
        sectionCard(title: "Spending", icon: "creditcard.fill") {
            statRow(icon: "wallet.pass.fill", label: "Wallet Balance", value: user.walletBalance.map { formatCurrency($0) } ?? "—")
        }

        // 2. Reputation
        reputationCard(userId: userId, avgRating: avgRating, totalReviews: totalReviews, reviewLabel: "review from workers")

        // 3. Posting Activity
        sectionCard(title: "Posting Activity", icon: "doc.text.fill") {
            statRow(icon: "square.stack.fill", label: "Jobs Posted", value: "\(user.totalServicesPosted)")
            divider()
            statRow(icon: "person.2.fill", label: "Applications Received", value: "\(received.count)")
        }

        // 4. Applications Breakdown
        sectionCard(title: "Applications Breakdown", icon: "chart.pie.fill") {
            statRow(icon: "clock.fill", label: "Pending", value: "\(pending)", iconColor: .blue)
            divider()
            statRow(icon: "checkmark.circle.fill", label: "Accepted", value: "\(accepted)", iconColor: .green)
            divider()
            statRow(icon: "xmark.circle.fill", label: "Rejected", value: "\(rejected)", iconColor: .red)
            divider()
            statRow(icon: "flag.checkered", label: "Completed", value: "\(completed)", iconColor: .purple)
        }

        // 5. Hiring Stats
        sectionCard(title: "Hiring Stats", icon: "person.badge.clock.fill") {
            statRow(
                icon: "hand.thumbsup.fill",
                label: "Acceptance Rate",
                value: user.acceptanceRate.map { String(format: "%.0f%%", $0) } ?? "—"
            )
            divider()
            statRow(
                icon: "chart.line.uptrend.xyaxis",
                label: "Completion Rate",
                value: user.completionRate.map { String(format: "%.0f%%", $0) } ?? "—"
            )
            divider()
            statRow(
                icon: "clock.fill",
                label: "Avg Response Time",
                value: user.averageResponseTime.map { formatDuration($0) } ?? "—",
                iconColor: Colors.swiftUIColor(.textSecondary)
            )
        }

        // 6. Profile Strength
        profileStrengthCard(percentage: user.jobSeekerCompletionPercentage, role: .jobSeeker)
    }

    // MARK: - Reusable Components

    @ViewBuilder
    private func reputationCard(userId: String, avgRating: Double?, totalReviews: Int, reviewLabel: String) -> some View {
        sectionCard(title: "Reputation", icon: "star.fill") {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink {
                    UserReviewsView(userId: userId)
                } label: {
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(avgRating.map { String(format: "%.1f", $0) } ?? "—")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                                Text("/ 5")
                                    .font(.subheadline)
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            }
                            Text("\(totalReviews) \(reviewLabel)\(totalReviews == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        }
                        Spacer()
                        starsRow(rating: avgRating ?? 0)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .padding(.leading, 4)
                    }
                    .padding(16)
                }

                if totalReviews > 0 {
                    divider()
                    NavigationLink {
                        UserReviewsView(userId: userId)
                    } label: {
                        HStack {
                            Text("See All Reviews")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.accent)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        }
                        .padding(16)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }
            .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func statRow(icon: String, label: String, value: String, iconColor: Color = .accent) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(iconColor)
                .frame(width: 24)

            Text(label)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
        }
        .padding(16)
    }

    @ViewBuilder
    private func divider() -> some View {
        Divider()
            .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func starsRow(rating: Double) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundStyle(i < Int(rating.rounded()) ? Color.yellow : Colors.swiftUIColor(.textSecondary))
            }
        }
    }

    @ViewBuilder
    private func verificationBadge(level: VerificationLevel) -> some View {
        let (label, color): (String, Color) = {
            switch level {
            case .unverified: return ("Unverified", Colors.swiftUIColor(.textSecondary))
            case .bronze:     return ("Bronze", .brown)
            case .silver:     return ("Silver", Color(.systemGray))
            case .gold:       return ("Gold", .yellow)
            }
        }()

        HStack(spacing: 4) {
            Image(systemName: "seal.fill")
                .font(.system(size: 12))
                .foregroundStyle(color)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .cornerRadius(20)
    }

    @ViewBuilder
    private func profileStrengthCard(percentage: Int, role: UserRole) -> some View {
        sectionCard(title: "Profile Strength", icon: "person.crop.circle.badge.checkmark") {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.15), lineWidth: 6)
                        .frame(width: 72, height: 72)
                    Circle()
                        .trim(from: 0, to: CGFloat(percentage) / 100)
                        .stroke(Color.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("\(percentage)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                        Text("%")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(percentage == 100 ? "Profile Complete!" : "Keep going!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                    Text(profileStrengthHint(percentage: percentage, role: role))
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(16)
        }
    }

    // MARK: - Helpers

    private func scoreColor(score: Int) -> Color {
        if score >= 75 { return .green }
        if score >= 40 { return .yellow }
        return .red
    }

    private func formatCurrency(_ value: Double) -> String {
        "\(Currency.current.symbol) \(String(format: "%.0f", value))"
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 3600 {
            return "\(Int(seconds / 60))m"
        } else if seconds < 86400 {
            return "\(Int(seconds / 3600))h"
        } else {
            return "\(Int(seconds / 86400))d"
        }
    }

    private func profileStrengthHint(percentage: Int, role: UserRole) -> String {
        if percentage == 100 { return "Your profile is fully complete." }
        if percentage >= 75  { return "Almost there — add a few more details." }
        if percentage >= 50  { return "Fill in more details to attract better matches." }
        return "Complete your profile to get noticed."
    }
}

#Preview {
    NavigationStack {
        UserPerformanceView()
            .environment(AuthenticationManager(userCache: UserCache()))
            .environment(ReviewsStore())
            .environment(ApplicationsStore())
            .environment(ServicesStore())
    }
}
