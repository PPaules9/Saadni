//
//  PathA_CategoryPrefsScreen.swift
//  GoodShift
//
//
//  Created by Pavly Paules on 14/04/2026.
//

import SwiftUI

struct PathA_CategoryPrefsScreen: View {
	@Binding var selected: Set<OnboardingJobCategory>
	let onNext: () -> Void
	
	private let columns = [GridItem(.flexible()), GridItem(.flexible())]

	var body: some View {
		VStack(spacing: 0) {
			OnboardingScreenHeader(
				headline: "What kind of work\ndo you usually need?"
			)

			ScrollView(showsIndicators: false) {
				LazyVGrid(columns: columns, spacing: 12) {
					ForEach(OnboardingJobCategory.allCases, id: \.self) { category in
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
					role: "job_seeker"
				))
				onNext()
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 40)
		}
	}
}

#Preview {
	@Previewable @State var selected: Set<OnboardingJobCategory> = []
	PathA_CategoryPrefsScreen(selected: $selected) {}
		.background(Colors.swiftUIColor(.appBackground))
}

