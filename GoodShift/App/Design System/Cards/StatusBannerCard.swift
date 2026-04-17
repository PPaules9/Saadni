//
//  StatusBannerCard.swift
//  GoodShift
//
//  A tinted inline banner used to communicate a job/shift status to the user.
//  Consolidates workerWaitingForProviderBanner, pendingCompletionBanner,
//  disputedBanner and similar inline patterns.
//

import SwiftUI

struct StatusBannerCard: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var tint: Color = .accent
    /// Show a ProgressView in place of the icon (e.g. while awaiting a server call)
    var isLoading: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            if isLoading {
                ProgressView().tint(tint)
            } else {
                Image(systemName: icon)
                    .foregroundStyle(tint)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }

            Spacer()
        }
        .padding(14)
        .background(tint.opacity(0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(tint.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBannerCard(
            icon: "clock.badge.checkmark.fill",
            title: "Arrival Confirmed — Waiting for Provider",
            subtitle: "The provider needs to confirm you're on-site.",
            tint: .accent
        )
        StatusBannerCard(
            icon: "clock.badge.checkmark.fill",
            title: "Awaiting Provider Confirmation",
            subtitle: "Submitted 2 minutes ago",
            tint: .purple
        )
        StatusBannerCard(
            icon: "exclamationmark.triangle.fill",
            title: "Provider Has a Concern",
            subtitle: "They flagged an issue with the shift.",
            tint: .red
        )
        StatusBannerCard(
            icon: "clock.fill",
            title: "Confirming Arrival…",
						tint: .accent, isLoading: true
        )
    }
    .padding(24)
}
