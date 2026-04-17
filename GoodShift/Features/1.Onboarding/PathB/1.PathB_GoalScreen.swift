//
//  PathB_GoalScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct PathB_GoalScreen: View {
	@Binding var selected: Set<OnboardingJobCategory>
	let onNext: () -> Void
	
	private let columns = [GridItem(.flexible()), GridItem(.flexible())]
	
	var body: some View {
		VStack(spacing: 0) {
			BrandHeaderText(
				headline: "What kind of staff\ndo you usually need?",
			)
			.multilineTextAlignment(.center)
			
			ScrollView(showsIndicators: false) {
				LazyVGrid(columns: columns, spacing: 12) {
					ForEach(OnboardingJobCategory.allCases, id: \.self) { category in
						let isSelected = selected.contains(category)
						Button {
							if isSelected { selected.remove(category) } else { selected.insert(category) }
						} label: {
							BrandImageWTextCard(
								imageName: category.imageName,
								label: category.rawValue,
								isSelected: isSelected
							)
						}
						.buttonStyle(.plain)
						.animation(.easeInOut(duration: 0.15), value: isSelected)
					}
				}
				.padding(.horizontal, 24)
				.padding(.vertical, 8)
			}
			
			Spacer()
			
			BrandButton("Continue", size: .large, isDisabled: selected.isEmpty, hasIcon: false, icon: "", secondary: false) {
				AnalyticsService.shared.track(.onboardingCategoriesSelected(
					categories: selected.map(\.rawValue),
					role: "provider"
				))
				onNext()
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 36)
		}
	}
}

#Preview {
	@Previewable @State var selected: Set<OnboardingJobCategory> = []
	PathB_GoalScreen(selected: $selected) {}
		.background(Colors.swiftUIColor(.appBackground))
}
