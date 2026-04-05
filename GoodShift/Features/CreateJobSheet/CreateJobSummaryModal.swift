//
//  CreateJobSummaryModal.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct CreateJobSummaryModal: View {
	@Environment(\.dismiss) var dismiss
	var viewModel: CreateJobViewModel
	let onPublish: () -> Void
	@AppStorage("appCurrency") private var appCurrency: String = "EGP"
	private var currencySymbol: String { Currency(rawValue: appCurrency)?.symbol ?? appCurrency }

	var body: some View {
		VStack(spacing: 0) {

			// Drag Handle
			RoundedRectangle(cornerRadius: 2)
				.fill(Colors.swiftUIColor(.textSecondary).opacity(0.35))
				.frame(width: 36, height: 4)
				.padding(.top, 12)
				.padding(.bottom, 10)

			// Header
			VStack(spacing: 3) {
				Text("Review Your Shift")
					.font(.title3)
					.fontWeight(.bold)
					.fontDesign(.monospaced)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
				Text("Check all details before publishing")
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
			}
			.frame(maxWidth: .infinity)
			.padding(.bottom, 16)
			.background(Colors.swiftUIColor(.textPrimary))

			// Content
			ScrollView(showsIndicators: false) {
				VStack(spacing: 20) {

					// Cover Banner
					ZStack(alignment: .bottomLeading) {
						if let image = viewModel.selectedImage {
							Image(uiImage: image)
								.resizable()
								.scaledToFill()
								.frame(maxWidth: .infinity)
								.frame(height: 190)
								.clipped()
						} else {
							Rectangle()
								.fill(Color.accent.opacity(0.12))
								.frame(height: 100)
						}

						LinearGradient(
							colors: [.clear, .black.opacity(0.65)],
							startPoint: .center,
							endPoint: .bottom
						)

						VStack(alignment: .leading, spacing: 3) {
							Text(viewModel.jobName)
								.font(.title2)
								.fontWeight(.bold)
								.foregroundStyle(.white)
							Text("\(viewModel.selectedDates.count) shift\(viewModel.selectedDates.count == 1 ? "" : "s")")
								.font(.caption)
								.foregroundStyle(.white.opacity(0.75))
						}
						.padding(16)
					}
					.cornerRadius(16)
					.clipped()

					// Shift Details
					SummaryCard(title: "Shift Details", icon: "calendar") {
						SummaryRow(label: "Job Name", value: viewModel.jobName)
						SummaryDivider()
						SummaryRow(label: "Dates", value: "\(viewModel.selectedDates.count) shift\(viewModel.selectedDates.count == 1 ? "" : "s") selected")
						if !viewModel.breakDuration.isEmpty {
							SummaryDivider()
							SummaryRow(label: "Break Duration", value: viewModel.breakDuration)
						}
					}

					// Location
					SummaryCard(title: "Location", icon: "mappin.circle.fill") {
						SummaryRow(label: "City", value: viewModel.city)
						SummaryDivider()
						SummaryRow(label: "Address", value: viewModel.address)
						if !viewModel.branchName.isEmpty {
							SummaryDivider()
							SummaryRow(label: "Branch", value: viewModel.branchName)
						}
						if !viewModel.nearestLandmark.isEmpty {
							SummaryDivider()
							SummaryRow(label: "Nearest Landmark", value: viewModel.nearestLandmark)
						}
					}

					// Pay
					SummaryCard(title: "Pay", icon: "banknote.fill") {
						SummaryRow(label: "Rate", value: "\(viewModel.price) \(currencySymbol) / shift")
						SummaryDivider()
						SummaryRow(label: "Payment Method", value: viewModel.paymentMethod)
						SummaryDivider()
						SummaryRow(label: "Payment Timing", value: viewModel.paymentTiming)
					}

					// Requirements (only if something was set)
					let hasRequirements = !viewModel.dressCode.isEmpty
						|| !viewModel.minimumAge.isEmpty
						|| viewModel.genderPreference != "Any"
						|| !viewModel.physicalRequirements.isEmpty
						|| !viewModel.languageNeeded.isEmpty

					if hasRequirements {
						SummaryCard(title: "Requirements", icon: "checklist") {
							if !viewModel.dressCode.isEmpty {
								SummaryRow(label: "Dress Code", value: viewModel.dressCode)
							}
							if !viewModel.minimumAge.isEmpty {
								if !viewModel.dressCode.isEmpty { SummaryDivider() }
								SummaryRow(label: "Minimum Age", value: viewModel.minimumAge)
							}
							if viewModel.genderPreference != "Any" {
								if !viewModel.dressCode.isEmpty || !viewModel.minimumAge.isEmpty { SummaryDivider() }
								SummaryRow(label: "Gender Preference", value: viewModel.genderPreference)
							}
							if !viewModel.physicalRequirements.isEmpty {
								if !viewModel.dressCode.isEmpty || !viewModel.minimumAge.isEmpty || viewModel.genderPreference != "Any" { SummaryDivider() }
								SummaryRow(label: "Physical Requirements", value: viewModel.physicalRequirements)
							}
							if !viewModel.languageNeeded.isEmpty {
								if !viewModel.dressCode.isEmpty || !viewModel.minimumAge.isEmpty || viewModel.genderPreference != "Any" || !viewModel.physicalRequirements.isEmpty { SummaryDivider() }
								SummaryRow(label: "Language Needed", value: viewModel.languageNeeded)
							}
						}
					}

					// Details
					if !viewModel.otherDetails.isEmpty || !viewModel.whatToBring.isEmpty {
						SummaryCard(title: "Details", icon: "doc.text.fill") {
							if !viewModel.otherDetails.isEmpty {
								SummaryRow(label: "What will the worker do", value: viewModel.otherDetails)
							}
							if !viewModel.whatToBring.isEmpty {
								if !viewModel.otherDetails.isEmpty { SummaryDivider() }
								SummaryRow(label: "What to bring", value: viewModel.whatToBring)
							}
						}
					}

				}
				.padding()
			}

			// Upload Progress
			if viewModel.uploadState != .idle && viewModel.uploadState != .completed {
				HStack(spacing: 10) {
					ProgressView()
						.tint(.accent)
						.scaleEffect(0.85)
					Text(uploadStatusText)
						.font(.caption)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					Spacer()
					if case .uploading(let progress) = viewModel.uploadState {
						Text("\(Int(progress * 100))%")
							.font(.caption)
							.fontWeight(.semibold)
							.foregroundStyle(Color.accent)
					}
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.background(Color.accent.opacity(0.08))
			}

			// Action Buttons
			HStack(spacing: 12) {
				BrandButton(
					"Cancel",
					isDisabled: viewModel.isPublishing,
					hasIcon: false,
					icon: "",
					secondary: true
				) {
					dismiss()
				}

				BrandButton(
					viewModel.isPublishing ? "Publishing..." : "Publish",
					isDisabled: viewModel.isPublishing,
					hasIcon: true,
					icon: "paperplane.fill",
					secondary: false
				) {
					onPublish()
				}
			}
			.padding()
			.background(Colors.swiftUIColor(.textPrimary))
		}
		.background(Colors.swiftUIColor(.appBackground))
	}

	private var uploadStatusText: String {
		switch viewModel.uploadState {
		case .compressing: return "Compressing image..."
		case .uploading: return "Uploading image..."
		case .saving: return "Saving job details..."
		default: return ""
		}
	}
}

// MARK: - Helper Components

struct SummaryCard<Content: View>: View {
	let title: LocalizedStringResource
	let icon: String
	@ViewBuilder let content: Content

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack(spacing: 5) {
				Image(systemName: icon)
					.font(.caption2)
					.foregroundStyle(Color.accent)
				Text(title)
					.font(.caption2)
					.fontWeight(.semibold)
					.textCase(.uppercase)
					.tracking(0.6)
					.foregroundStyle(Color.accent)
			}

			VStack(alignment: .leading, spacing: 0) {
				content
			}
			.background(Colors.swiftUIColor(.textPrimary))
			.cornerRadius(12)
		}
	}
}

struct SummaryRow: View {
	let label: LocalizedStringResource
	let value: String

	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			Text(label)
				.font(.subheadline)
				.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				.frame(minWidth: 110, alignment: .leading)
			Spacer()
			Text(value)
				.font(.subheadline)
				.fontWeight(.semibold)
				.multilineTextAlignment(.trailing)
				.lineLimit(4)
				.foregroundStyle(Colors.swiftUIColor(.textMain))
		}
		.padding(.vertical, 12)
		.padding(.horizontal, 14)
	}
}

struct SummaryDivider: View {
	var body: some View {
		Divider()
			.padding(.leading, 14)
	}
}

#Preview {
	CreateJobSummaryModal(viewModel: CreateJobViewModel(), onPublish: {})
}
