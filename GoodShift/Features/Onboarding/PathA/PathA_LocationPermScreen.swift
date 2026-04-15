//
//  PathA_LocationPermScreen.swift
//  GoodShift
//
//
//  Created by Pavly Paules on 14/04/2026.
//

import SwiftUI
import CoreLocation

struct PathA_LocationPermScreen: View {
	let onEnable: () -> Void
	let onSkip: () -> Void
	
	var body: some View {
		OnboardingPermissionScreen(
			icon: "location.fill",
			headline: "Find shifts near you",
			subheadline: "We'll show you jobs you can actually get to — no wasted commutes.",
			bullets: [
				"See shifts sorted by distance from you",
				"Filter by area or neighbourhood",
				"Get notified when a new shift opens near you"
			],
			enableCTA: "Enable Location",
			onEnable: {
				LocationPermissionHelper.request { onEnable() }
			},
			onSkip: onSkip
		)
	}
}

#Preview {
	PathA_LocationPermScreen(onEnable: {}, onSkip: {})
		.background(Colors.swiftUIColor(.appBackground))
}
