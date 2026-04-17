//
//  PathB_SolutionScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct PathB_SolutionScreen: View {
	let painPoints: Set<String>
	let onNext: () -> Void
	
	
	private var displayedSolutions: [(pain: String, solution: String, icon: String)] {
		let matched = allSolutions.filter { painPoints.contains($0.pain) }
		return Array((matched.isEmpty ? allSolutions : matched).prefix(4))
	}
	
	var body: some View {
		VStack(spacing: 0) {
			BrandHeaderText(
				headline: "Here's how GoodShift\nchanges the way you hire.",
				subheadline: "Every problem you mentioned — solved."
			)
			.multilineTextAlignment(.center)
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 14) {
					ForEach(displayedSolutions, id: \.pain) { item in
						ProviderSolutionRow(pain: item.pain, solution: item.solution, icon: item.icon)
					}
				}
				.padding(.horizontal, 24)
				.padding(.vertical, 8)
			}
			
			Spacer()
			
			BrandButton("See how it works", size: .large, hasIcon: false, icon: "", secondary: false) {
				onNext()
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 36)
		}
	}
	
	
	
	private let allSolutions: [(pain: String, solution: String, icon: String)] = [
		("Finding people last minute is a nightmare",
		 "Post a shift and get applicants within hours — not days.",
		 "bolt.fill"),
		
		("Workers show up late or don't show up at all",
		 "Every worker has a verified attendance record and rating.",
		 "checkmark.seal.fill"),
		
		("Too much back-and-forth to confirm a shift",
		 "One screen to review applicants, approve, and confirm.",
		 "checkmark.circle.fill"),
		
		("I can't tell if someone is reliable before hiring them",
		 "See ratings, completed shifts, and badges before you hire.",
		 "star.fill"),
		
		("I end up paying for hours where people did nothing",
		 "Shift completion is confirmed by both sides in the app.",
		 "lock.shield.fill"),
		
		("Managing multiple workers across different shifts is chaos",
		 "Your dashboard shows every active shift and worker in one view.",
		 "list.bullet.clipboard")
	]
	
}

#Preview {
	PathB_SolutionScreen(
		painPoints: ["Finding people last minute is a nightmare", "Workers show up late or don't show up at all"],
		onNext: {}
	)
	.background(Colors.swiftUIColor(.appBackground))
}

