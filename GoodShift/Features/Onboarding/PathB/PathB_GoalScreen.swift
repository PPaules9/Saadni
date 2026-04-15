//
//  PathB_GoalScreen.swift
//  GoodShift
//
//  Service Provider — what kind of staff do you usually need?
//

import SwiftUI

struct PathB_GoalScreen: View {
	@Binding var selected: Set<OnboardingStaffCategory>
	let onNext: () -> Void

	private let columns = [GridItem(.flexible()), GridItem(.flexible())]

	var body: some View {
		VStack(spacing: 0) {
			OnboardingScreenHeader(
				headline: "What kind of staff\ndo you usually need?",

			)

			ScrollView(showsIndicators: false) {
				LazyVGrid(columns: columns, spacing: 12) {
					ForEach(OnboardingStaffCategory.allCases, id: \.self) { category in
						let isSelected = selected.contains(category)
						Button {
							if isSelected { selected.remove(category) } else { selected.insert(category) }
						} label: {
							OnboardingImageCell(
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
			.padding(.bottom, 40)
		}
	}
}

#Preview {
	@Previewable @State var selected: Set<OnboardingStaffCategory> = []
	PathB_GoalScreen(selected: $selected) {}
		.background(Colors.swiftUIColor(.appBackground))
}
