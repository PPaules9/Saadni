//
//  OnboardingRoleSplitScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import SwiftUI

struct OnboardingRoleSplitScreen: View {
	let onSelect: (UserRole) -> Void

	// MARK: - Amplitude Analytics Choosing between Roles
	private func select(_ role: UserRole) {
		let roleName = role == .jobSeeker ? "job_seeker" : "provider"
		AnalyticsService.shared.track(.onboardingRoleSelected(role: roleName))
		onSelect(role)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			
			BrandHeaderText(headline: "What brings you\nto GoodShift?")
				.multilineTextAlignment(.center)

			Spacer()
				.frame(height: 48)
			
			// Role cards — tapping immediately navigates
			VStack(spacing: 16) {
				RoleCard(
					title: "I'm looking for work",
					accentColor: Color.accentColor
				) {
					select(.jobSeeker)
				}
				
				RoleCard(
					title: "I'm looking to hire",
					accentColor: Colors.swiftUIColor(.primaryDark)
				) {
					select(.provider)
				}
			}
			.padding(.horizontal, 24)
			
			Spacer()
		}
		.padding(.top)
	}
}


#Preview {
	OnboardingRoleSplitScreen { _ in }
		.background(Colors.swiftUIColor(.appBackground))
}
