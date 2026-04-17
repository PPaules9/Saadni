//
//  PathB_NotifPermScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct PathB_NotifPermScreen: View {
    let onEnable: () -> Void
    let onSkip: () -> Void

    var body: some View {
        OnboardingPermissionScreen(
            icon: "bell.fill",
            headline: "Know the moment\nsomeone applies",
            subheadline: "Shifts fill fast — don't miss your best candidates.",
            bullets: [
                "Get notified instantly when a new applicant matches your shift",
                "Know when a worker confirms or cancels",
                "Receive shift-day reminders for your team"
            ],
            enableCTA: "Enable Notifications",
            onEnable: {
                NotificationPermissionHelper.request { onEnable() }
            },
            onSkip: onSkip
        )
    }
}

#Preview {
    PathB_NotifPermScreen(onEnable: {}, onSkip: {})
        .background(Colors.swiftUIColor(.appBackground))
}
