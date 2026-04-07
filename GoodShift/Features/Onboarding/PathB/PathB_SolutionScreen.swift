//
//  PathB_SolutionScreen.swift
//  GoodShift
//

import SwiftUI

struct PathB_SolutionScreen: View {
    let painPoints: Set<String>
    let onNext: () -> Void

    private let allSolutions: [(pain: String, solution: String, icon: String)] = [
        ("Finding people last minute is a nightmare",
         "Post a shift and get applicants within hours — not days.",
         "bolt.fill"),

        ("Workers show up late or don't show up at all",
         "Every worker has a verified attendance record and rating.",
         "checkmark.seal.fill"),

        ("Too much back-and-forth to confirm a shift",
         "One screen to review applicants, approve, and confirm.",
         "checkmark.circle.fill"),

        ("I can't tell if someone is reliable before hiring them",
         "See ratings, completed shifts, and badges before you hire.",
         "star.fill"),

        ("I end up paying for hours where people did nothing",
         "Shift completion is confirmed by both sides in the app.",
         "lock.shield.fill"),

        ("Managing multiple workers across different shifts is chaos",
         "Your dashboard shows every active shift and worker in one view.",
         "list.bullet.clipboard")
    ]

    private var displayedSolutions: [(pain: String, solution: String, icon: String)] {
        let matched = allSolutions.filter { painPoints.contains($0.pain) }
        return Array((matched.isEmpty ? allSolutions : matched).prefix(4))
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "Here's how GoodShift\nchanges the way you hire.",
                subheadline: "Every problem you mentioned — solved."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(displayedSolutions, id: \.pain) { item in
                        ProviderSolutionRow(pain: item.pain, solution: item.solution, icon: item.icon)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("See how it works", size: .large, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Solution Row

private struct ProviderSolutionRow: View {
    let pain: String
    let solution: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Colors.swiftUIColor(.primaryDark).opacity(0.12))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Colors.swiftUIColor(.primaryDark))
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
