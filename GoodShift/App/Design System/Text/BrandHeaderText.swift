//
//  OnboardingScreenHeader.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/04/2026.
//

import SwiftUI

struct BrandHeaderText: View {
	var headline: String? = nil
	var subheadline: String? = nil
	
	var body: some View {
		VStack(spacing: 8) {
			if let headline = headline {
				Text(headline)
					.font(.title)
					.bold()
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.fixedSize(horizontal: false, vertical: true)
			}
			
			if let subheadline = subheadline {
				Text(subheadline)
					.font(.system(size: 15))
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					.lineSpacing(3)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.frame(maxWidth: .infinity)
		.padding(.horizontal, 24)
		.padding(.top, 16)
		.padding(.bottom, 20)
	}
}

#Preview {
	VStack {
		BrandHeaderText(
			headline: "What's your main goal fds fdsfds ds?",
			subheadline: "We'll personalize your experience based on your answer."
		)
		.multilineTextAlignment(.leading)
		BrandHeaderText(headline: "No subheadline example")
			.multilineTextAlignment(.center)
		
	}
}
