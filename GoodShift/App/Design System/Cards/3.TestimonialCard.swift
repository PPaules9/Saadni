//
//  OnboardingTestimonialCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct TestimonialCard: View {
	let quote: String
	let name: String
	let tag: String   // e.g. "University student · Food & Beverage"
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			// Stars
			HStack(spacing: 2) {
				ForEach(0..<5, id: \.self) { _ in
					Image(systemName: "star.fill")
						.font(.system(size: 11))
						.foregroundStyle(Color.yellow)
				}
			}
			
			Text("\(quote)")
				.font(.system(size: 15, weight: .regular))
				.foregroundStyle(Colors.swiftUIColor(.textMain))
				.lineSpacing(3)
				.fixedSize(horizontal: false, vertical: true)
			
			HStack(spacing: 10) {
				// Avatar initials circle
				Text(initials(from: name))
					.font(.system(size: 13, weight: .bold))
					.foregroundStyle(.white)
					.frame(width: 34, height: 34)
					.background(Circle().fill(Color.accentColor))
				
				VStack(alignment: .leading, spacing: 2) {
					Text(name)
						.font(.system(size: 13, weight: .semibold))
						.foregroundStyle(Colors.swiftUIColor(.textMain))
					
					Text(tag)
						.font(.system(size: 12))
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
			}
		}
		.padding(18)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(
			RoundedRectangle(cornerRadius: 18)
				.fill(Colors.swiftUIColor(.cardBackground))
		)
		.overlay(
			RoundedRectangle(cornerRadius: 18)
				.strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.12), lineWidth: 1)
		)
	}
	
	private func initials(from name: String) -> String {
		let parts = name.split(separator: " ")
		let letters = parts.compactMap { $0.first }.prefix(2)
		return String(letters).uppercased()
	}
}

#Preview {
	TestimonialCard(
		quote: "We used to spend 2 days calling around for weekend staff. Now we post, approve, and we're done in an hour.",
		name: "Karim M.",
		tag: "Operations Manager · F&B Chain")
		
}
