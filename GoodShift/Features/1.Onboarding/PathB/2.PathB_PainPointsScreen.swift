//
//  PathB_PainPointsScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import SwiftUI

struct PathB_PainPointsScreen: View {
	@Binding var selected: Set<String>
	let onNext: () -> Void
	
	private let options: [(emoji: String, label: String)] = [
		("🚨", "Finding people last minute is a nightmare"),
		("🕐", "Workers show up late or don't show up at all"),
		("🤷", "I can't tell if someone is reliable before hiring them"),
		("💬", "Too much back-and-forth to confirm a shift"),
		("💸", "I end up paying for hours where people did nothing"),
		("📋", "Managing multiple workers across different shifts is chaos")
	]
	
	var body: some View {
		VStack(spacing: 0) {
			BrandHeaderText(
				headline: "What makes hiring\nfor shifts painful?",
				subheadline: "Pick everything that sounds familiar."
			)
			.multilineTextAlignment(.center)
			
			ScrollView(showsIndicators: false) {
				VStack(spacing: 10) {
					ForEach(options, id: \.label) { option in
						OnboardingMultiOptionRow(
							emoji: option.emoji,
							label: option.label,
							isSelected: selected.contains(option.label)
						) {
							if selected.contains(option.label) {
								selected.remove(option.label)
							} else {
								selected.insert(option.label)
							}
						}
					}
				}
				.padding(.horizontal, 24)
				.padding(.vertical, 8)
			}
			
			Spacer()
			
			BrandButton("Continue", size: .large, isDisabled: selected.isEmpty, hasIcon: false, icon: "", secondary: false) {
				onNext()
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 36)
		}
	}
}

#Preview {
	@Previewable @State var selected: Set<String> = []
	PathB_PainPointsScreen(selected: $selected) {}
		.background(Colors.swiftUIColor(.appBackground))
}
