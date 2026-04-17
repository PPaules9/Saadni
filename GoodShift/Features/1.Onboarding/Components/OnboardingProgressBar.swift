//
//  OnboardingProgressBar.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import SwiftUI

struct OnboardingProgressBar: View {
	let progress: Double  // 0.0 – 1.0
	
	var body: some View {
		GeometryReader { geo in
			ZStack(alignment: .leading) {
				Capsule()
					.fill(Colors.swiftUIColor(.textSecondary).opacity(0.15))
					.frame(height: 4)
				
				Capsule()
					.fill(Color.accentColor)
					.frame(width: max(8, geo.size.width * progress), height: 4)
					.animation(.easeInOut(duration: 0.4), value: progress)
			}
		}
		.frame(height: 4)
	}
}

#Preview {
	VStack(spacing: 24) {
		OnboardingProgressBar(progress: 0.2)
		OnboardingProgressBar(progress: 0.6)
		OnboardingProgressBar(progress: 1.0)
	}
	.padding()
}
