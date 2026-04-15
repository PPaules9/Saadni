//
//  PathA_SolutionScreen.swift
//  GoodShift
//
//  Mirrors the user's selected pain points back at them,
//  showing exactly how GoodShift solves each one.
//

import SwiftUI

struct PathA_SolutionScreen: View {
    let painPoints: Set<String>
    let onNext: () -> Void

    // All possible pain → solution mappings
    private let allSolutions: [(pain: String, solution: String, icon: String)] = [
        ("I never know if the job is real",
         "Every shift is posted by a verified business — no fake listings.",
         "checkmark.seal.fill"),

        ("I got paid late, or not at all",
         "Payment goes through the app. Your money is protected.",
         "lock.shield.fill"),

        ("My schedule changes — I need flexibility",
         "Filter by date, time, and location. Apply only to what fits.",
         "calendar.badge.checkmark"),

        ("I didn't have enough experience to get hired",
         "Your GoodShift rating builds your reputation shift by shift.",
         "star.fill"),

        ("I showed up and there was no job",
         "Businesses confirm every shift before it goes live.",
         "checkmark.circle.fill"),

        ("I didn't know who to contact or how to apply",
         "Apply in one tap. The business gets notified instantly.",
         "bolt.fill")
    ]

    // Show matched solutions first, fallback to top 3 if nothing matched
    private var displayedSolutions: [(pain: String, solution: String, icon: String)] {
        let matched = allSolutions.filter { painPoints.contains($0.pain) }
        if matched.isEmpty {
            return Array(allSolutions.prefix(3))
        }
        return Array(matched.prefix(4))
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "GoodShift was built\nfor exactly this.",
                subheadline: "Here's how we fix what's been holding you back."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(displayedSolutions, id: \.pain) { item in
                        SolutionRow(pain: item.pain, solution: item.solution, icon: item.icon)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("Show me the shifts", size: .large, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PathA_SolutionScreen(
        painPoints: ["I never know if the job is real", "I got paid late, or not at all"],
        onNext: {}
    )
    .background(Colors.swiftUIColor(.appBackground))
}

// MARK: - Solution Row

private struct SolutionRow: View {
    let pain: String
    let solution: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(pain)
                    .font(.system(size: 12))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .lineLimit(2)

                Text(solution)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.swiftUIColor(.cardBackground))
        )
    }
}
