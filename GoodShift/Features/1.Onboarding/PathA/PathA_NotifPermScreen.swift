//
//  PathA_NotifPermScreen.swift
//  GoodShift
//

import SwiftUI

struct PathA_NotifPermScreen: View {
    let onEnable: () -> Void
    let onSkip: () -> Void

    var body: some View {
        OnboardingPermissionScreen(
            icon: "bell.fill",
            headline: "Never miss a new shift",
            subheadline: "New shifts fill up fast — sometimes within hours.",
            bullets: [
                "Get notified the moment a shift matches your preferences",
                "Know instantly when your application is accepted",
                "Receive shift reminders so you're always on time"
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
    PathA_NotifPermScreen(onEnable: {}, onSkip: {})
        .background(Colors.swiftUIColor(.appBackground))
}
