//
//  OnboardingOptionRow.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

// MARK: - Single Select Row

struct OnboardingSingleOptionRow: View {
	let emoji: String
	let label: String
	let isSelected: Bool
	let onTap: () -> Void

	var body: some View {
		Button(action: onTap) {
			HStack(spacing: 14) {
				Text(emoji)
					.font(.system(size: 22))
					.frame(width: 36, height: 36)
					.background(
						Circle()
							.fill(isSelected
										? Color.accentColor.opacity(0.15)
										: Colors.swiftUIColor(.cardBackground))
					)

				Text(label)
					.font(.system(size: 16, weight: isSelected ? .semibold : .regular))
					.foregroundStyle(Colors.swiftUIColor(.textMain))

				Spacer()

				if isSelected {
					Image(systemName: "checkmark.circle.fill")
						.foregroundStyle(Color.accentColor)
						.font(.system(size: 20))
				}
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 14)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(isSelected
								? Colors.swiftUIColor(.selectionHighlight)
								: Colors.swiftUIColor(.cardBackground))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 14)
					.strokeBorder(
						isSelected ? Color.accentColor : Color.clear,
						lineWidth: 1.5
					)
			)
		}
		.buttonStyle(.plain)
		.animation(.easeInOut(duration: 0.15), value: isSelected)
	}
}

// MARK: - Multi Select Row

struct OnboardingMultiOptionRow: View {
	let emoji: String
	let label: String
	let isSelected: Bool
	let onTap: () -> Void

	var body: some View {
		Button(action: onTap) {
			HStack(spacing: 14) {
				ZStack {
					RoundedRectangle(cornerRadius: 6)
						.fill(isSelected ? Color.accentColor : Colors.swiftUIColor(.cardBackground))
						.frame(width: 22, height: 22)
						.overlay(
							RoundedRectangle(cornerRadius: 6)
								.strokeBorder(
									isSelected ? Color.clear : Colors.swiftUIColor(.textSecondary).opacity(0.4),
									lineWidth: 1.5
								)
						)

					if isSelected {
						Image(systemName: "checkmark")
							.font(.system(size: 11, weight: .bold))
							.foregroundStyle(.white)
					}
				}

				Text(emoji)
					.font(.system(size: 20))

				Text(label)
					.font(.system(size: 16, weight: isSelected ? .semibold : .regular))
					.foregroundStyle(Colors.swiftUIColor(.textMain))

				Spacer()
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 14)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(isSelected
								? Colors.swiftUIColor(.selectionHighlight)
								: Colors.swiftUIColor(.cardBackground))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 14)
					.strokeBorder(
						isSelected ? Color.accentColor : Color.clear,
						lineWidth: 1.5
					)
			)
		}
		.buttonStyle(.plain)
		.animation(.easeInOut(duration: 0.15), value: isSelected)
	}
}

// MARK: - Category Grid Cell

struct OnboardingCategoryCell: View {
	let icon: String       // SF Symbol name
	let label: String
	let isSelected: Bool
	let onTap: () -> Void

	var body: some View {
		Button(action: onTap) {
			VStack(spacing: 8) {
				Image(systemName: icon)
					.font(.system(size: 24, weight: .medium))
					.foregroundStyle(isSelected ? .white : Color.accentColor)
					.frame(width: 52, height: 52)
					.background(
						RoundedRectangle(cornerRadius: 14)
							.fill(isSelected
										? Color.accentColor
										: Color.accentColor.opacity(0.12))
					)

				Text(label)
					.font(.system(size: 12, weight: isSelected ? .semibold : .regular))
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.multilineTextAlignment(.center)
					.lineLimit(2)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 14)
			.padding(.horizontal, 8)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(isSelected
								? Colors.swiftUIColor(.selectionHighlight)
								: Colors.swiftUIColor(.cardBackground))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.strokeBorder(
						isSelected ? Color.accentColor : Color.clear,
						lineWidth: 1.5
					)
			)
		}
		.buttonStyle(.plain)
		.animation(.easeInOut(duration: 0.15), value: isSelected)
	}
}

// MARK: - Previews

#Preview("Single Option Row") {
	VStack(spacing: 12) {
		OnboardingSingleOptionRow(
			emoji: "🏥",
			label: "Healthcare",
			isSelected: false,
			onTap: {}
		)
		OnboardingSingleOptionRow(
			emoji: "🍽️",
			label: "Hospitality",
			isSelected: true,
			onTap: {}
		)
	}
	.padding()
	.background(Colors.swiftUIColor(.appBackground))
}

#Preview("Multi Option Row") {
	VStack(spacing: 12) {
		OnboardingMultiOptionRow(
			emoji: "🏥",
			label: "Healthcare",
			isSelected: false,
			onTap: {}
		)
		OnboardingMultiOptionRow(
			emoji: "🍽️",
			label: "Hospitality",
			isSelected: true,
			onTap: {}
		)
		OnboardingMultiOptionRow(
			emoji: "🛒",
			label: "Retail",
			isSelected: true,
			onTap: {}
		)
	}
	.padding()
	.background(Colors.swiftUIColor(.appBackground))
}

#Preview("Category Cell") {
	LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
		OnboardingCategoryCell(icon: "stethoscope", label: "Healthcare", isSelected: false, onTap: {})
		OnboardingCategoryCell(icon: "fork.knife", label: "Hospitality", isSelected: true, onTap: {})
		OnboardingCategoryCell(icon: "cart", label: "Retail", isSelected: false, onTap: {})
		OnboardingCategoryCell(icon: "building.2", label: "Office", isSelected: true, onTap: {})
		OnboardingCategoryCell(icon: "wrench.and.screwdriver", label: "Trades", isSelected: false, onTap: {})
		OnboardingCategoryCell(icon: "graduationcap", label: "Education", isSelected: false, onTap: {})
	}
	.padding()
	.background(Colors.swiftUIColor(.appBackground))
}
