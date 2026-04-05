//
//  JobPublishedSuccessModal.swift
//  GoodShift
//
//  Created by Claude on 14/03/2026.
//

import SwiftUI

struct JobPublishedSuccessModal: View {
	@Bindable var viewModel: CreateJobViewModel
	let onComplete: () -> Void
	@AppStorage("appCurrency") private var appCurrency: String = "EGP"
	private var currencySymbol: String { Currency(rawValue: appCurrency)?.symbol ?? appCurrency }
	
	var body: some View {
		ZStack {
			// Semi-transparent background overlay
			Color.black.opacity(0.95)
				.ignoresSafeArea()
			
			// Content card
			VStack(spacing: 0) {
				// Header
				VStack(spacing: 8) {
					Image(systemName: "checkmark.circle.fill")
						.resizable()
						.frame(width: 60, height: 60)
						.foregroundStyle(.green)
					
					Text("Success!")
						.font(.title2)
						.fontWeight(.bold)
						.foregroundStyle(Color.accent)
					
					Text("\(viewModel.selectedDates.count) shift(s) successfully published.")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.padding()
				.frame(maxWidth: .infinity)
				.background(Colors.swiftUIColor(.appBackground))
				
				// Scrollable Summary
				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading, spacing: 16) {
						
						// Pic and Title
						HStack(spacing: 16) {
							if let image = viewModel.selectedImage {
								Image(uiImage: image)
									.resizable()
									.scaledToFill()
									.frame(width: 60, height: 60)
									.clipShape(RoundedRectangle(cornerRadius: 8))
							} else {
								RoundedRectangle(cornerRadius: 8)
									.fill(Color.gray.opacity(0.2))
									.frame(width: 60, height: 60)
									.overlay(Image(systemName: "briefcase.fill").foregroundStyle(.gray))
							}
							
							VStack(alignment: .leading, spacing: 4) {
								Text(viewModel.jobName)
									.font(.headline)
									.lineLimit(2)
								Text("\(currencySymbol) \(viewModel.price)")
									.font(.subheadline)
									.fontWeight(.semibold)
									.foregroundStyle(.green)
							}
						}
						
						Divider()
						
						// Details Breakdown
						DetailRow(icon: "calendar.badge.clock", title: "Shifts Created", value: "\(viewModel.selectedDates.count) Shifts")
						DetailRow(icon: "mappin.and.ellipse", title: "Location", value: viewModel.city)
						DetailRow(icon: "creditcard.fill", title: "Payment", value: "\(viewModel.paymentMethod) - \(viewModel.paymentTiming)")
						
						if !viewModel.dressCode.isEmpty {
							DetailRow(icon: "tshirt.fill", title: "Dress Code", value: viewModel.dressCode)
						}
					}
					.padding()
				}
				.frame(maxHeight: 300)
				
				
				VStack {
					BrandButton("Return to Dashboard", hasIcon: false, icon: "", secondary: false) {
						onComplete()
					}
				}
				.padding()
				.background(Colors.swiftUIColor(.appBackground))
			}
			.background(Colors.swiftUIColor(.textPrimary))
			.cornerRadius(32)
			.padding(24)
		}
	}
}

fileprivate struct DetailRow: View {
	let icon: String
	let title: LocalizedStringResource
	let value: String
	
	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			Image(systemName: icon)
				.foregroundStyle(Color.accent)
				.frame(width: 24)
			
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				Text(value)
					.font(.subheadline)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.fontWeight(.medium)
			}
		}
	}
}

#Preview {
	JobPublishedSuccessModal(
		viewModel: CreateJobViewModel(),
		onComplete: {}
	)
}
