//
//  CreateJobSummaryModal.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct CreateJobSummaryModal: View {
	@Environment(\.dismiss) var dismiss
	var viewModel: CreateJobViewModel
	let onPublish: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			// Header
			VStack(spacing: 8) {
				Text("Review Your Job(s)")
					.font(.headline)
					.fontWeight(.semibold)
				
				Text("Preview and publish \(viewModel.selectedDates.count) shift(s)")
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding()
			.background(Colors.swiftUIColor(.textPrimary))
			
			// Summary Content
			ScrollView {
				VStack(spacing: 16) {
					if let image = viewModel.selectedImage {
						Image(uiImage: image)
							.resizable()
							.scaledToFill()
							.frame(height: 180)
							.cornerRadius(12)
							.clipped()
					}
					
					SummarySection(title: "Shift Details") {
						SummaryRow(label: "Job Name", value: viewModel.jobName)
						SummaryRow(label: "Dates", value: "\(viewModel.selectedDates.count) shift(s) selected")
						if !viewModel.breakDuration.isEmpty {
							SummaryRow(label: "Break", value: viewModel.breakDuration)
						}
					}
					
					SummarySection(title: "Location") {
						SummaryRow(label: "City", value: viewModel.city)
						SummaryRow(label: "Address", value: viewModel.address)
						if !viewModel.branchName.isEmpty {
							SummaryRow(label: "Branch", value: viewModel.branchName)
						}
					}
					
					SummarySection(title: "Pay") {
						SummaryRow(label: "Rate", value: "\(viewModel.price) EGP")
						SummaryRow(label: "Method", value: viewModel.paymentMethod)
						SummaryRow(label: "Timing", value: viewModel.paymentTiming)
					}
					
					SummarySection(title: "Requirements") {
						if !viewModel.dressCode.isEmpty {
							SummaryRow(label: "Dress Code", value: viewModel.dressCode)
						}
						if !viewModel.minimumAge.isEmpty {
							SummaryRow(label: "Minimum Age", value: viewModel.minimumAge)
						}
						SummaryRow(label: "Gender Preference", value: viewModel.genderPreference)
					}
					
					SummarySection(title: "Company Info") {
						SummaryRow(label: "Company", value: viewModel.companyName)
						SummaryRow(label: "Contact", value: "\(viewModel.contactPersonName) (\(viewModel.contactPersonPhone))")
					}
				}
				.padding()
			}
			
			// Progress UI during upload
			if case .compressing = viewModel.uploadState {
				VStack(spacing: 8) {
					ProgressView().tint(.accent)
					Text("Compressing image...").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.frame(maxWidth: .infinity).padding().background(Color.accent.opacity(0.1)).cornerRadius(8).padding()
			} else if case .uploading(let progress) = viewModel.uploadState {
				VStack(spacing: 8) {
					ProgressView(value: progress).tint(.accent)
					Text("Uploading image... \(Int(progress * 100))%").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.frame(maxWidth: .infinity).padding().background(Color.accent.opacity(0.1)).cornerRadius(8).padding()
			} else if case .saving = viewModel.uploadState {
				VStack(spacing: 8) {
					ProgressView().tint(.accent)
					Text("Saving job details...").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.frame(maxWidth: .infinity).padding().background(Color.accent.opacity(0.1)).cornerRadius(8).padding()
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
}

// MARK: - Helper Components

struct SummarySection<Content: View>: View {
	let title: LocalizedStringResource
	@ViewBuilder let content: Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(title)
				.font(.subheadline)
				.fontWeight(.semibold)
				.foregroundStyle(Color.accent)
			
			VStack(alignment: .leading, spacing: 0) {
				content
			}
		}
	}
}

struct SummaryRow: View {
	let label: LocalizedStringResource
	let value: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(label)
				.font(.caption2)
				.foregroundStyle(Colors.swiftUIColor(.textSecondary))
			
			Text(value)
				.font(.subheadline)
				.fontWeight(.semibold)
				.lineLimit(3)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical, 8)
		.padding(.horizontal, 12)
		.background(Colors.swiftUIColor(.appBackground))
		.cornerRadius(8)
	}
}

#Preview {
	CreateJobSummaryModal(viewModel: CreateJobViewModel(), onPublish: {})
}
