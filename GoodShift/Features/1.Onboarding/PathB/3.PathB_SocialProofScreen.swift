//
//  PathB_SocialProofScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct PathB_SocialProofScreen: View {
	let onNext: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			BrandHeaderText(
				headline: "Businesses like yours\nfill shifts the same day.",
				subheadline: "Here's what they have to say."
			)
			.multilineTextAlignment(.center)
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 14) {
					ForEach(testimonials, id: \.name) { testimonial in
						testimonial
					}
				}
				.padding(.horizontal, 24)
				.padding(.vertical, 8)
			}
			
			Spacer()
			
			BrandButton("That's what I need →", size: .large, hasIcon: false, icon: "", secondary: false) {
				onNext()
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 36)
		}
	}
	
	
	private let testimonials: [TestimonialCard] = [
		TestimonialCard(
			quote: "We used to spend 2 days calling around for weekend staff. Now we post, approve, and we're done in an hour.",
			name: "Karim M.",
			tag: "Operations Manager · F&B Chain"
		),
		TestimonialCard(
			quote: "Every applicant has a rating. We stopped guessing and started hiring people we could actually trust.",
			name: "Sara H.",
			tag: "HR Coordinator · Retail"
		),
		TestimonialCard(
			quote: "We scaled from 2 branches to 5 without hiring a single extra admin person for staffing.",
			name: "Ahmed R.",
			tag: "Owner · Event Company"
		)
	]
	
	
}

#Preview {
	PathB_SocialProofScreen {}
		.background(Colors.swiftUIColor(.appBackground))
}
