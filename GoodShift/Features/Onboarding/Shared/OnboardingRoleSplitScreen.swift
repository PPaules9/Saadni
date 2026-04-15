//
//  OnboardingRoleSplitScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import SwiftUI
import Kingfisher

struct OnboardingRoleSplitScreen: View {
	let onSelect: (OnboardingRole) -> Void
	
	private func select(_ role: OnboardingRole) {
		let roleName = role == .jobSeeker ? "job_seeker" : "provider"
		AnalyticsService.shared.track(.onboardingRoleSelected(role: roleName))
		onSelect(role)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			
			VStack(spacing: 16) {
				Text("What brings you\nto GoodShift?")
					.font(.system(size: 30, weight: .bold))
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.multilineTextAlignment(.center)
					.lineSpacing(2)
				
			}
			.padding(.horizontal, 24)
			
			Spacer().frame(height: 48)
			
			// Role cards — tapping immediately navigates
			VStack(spacing: 16) {
				RoleCard(
					icon: "brandImage2",
					title: "I'm looking for work",
					accentColor: Color.accentColor
				) {
					select(.jobSeeker)
				}
				
				RoleCard(
					icon: "brandImage4",
					title: "I'm looking to hire",
					accentColor: Colors.swiftUIColor(.primaryDark)
				) {
					select(.provider)
				}
			}
			.padding(.horizontal, 24)
			
			Spacer()
		}
	}
}


#Preview {
	OnboardingRoleSplitScreen { _ in }
		.background(Colors.swiftUIColor(.appBackground))
}
