//
//  CreateJobTab1.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab1: View {
	@Bindable var viewModel: CreateJobViewModel
	let selectedCategory: String
	@State private var showCalendar = false

	private static let displayDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE, d MMMM yyyy"
		return formatter
	}()

	private var selectedDatesLabel: String {
		switch viewModel.selectedDates.count {
		case 0:
			return "Select at least one shift date"
		case 1:
			// MultiDatePicker uses Set<DateComponents>
			if let comps = viewModel.selectedDates.first,
			   let date = Calendar.current.date(from: comps) {
				return Self.displayDateFormatter.string(from: date)
			} else {
				return "Select at least one shift date"
			}
		default:
			return "\(viewModel.selectedDates.count) dates selected"
		}
	}

	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 24) {
				// Category Display
				HStack {
					Text("Service Category")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					Spacer()
					Text(selectedCategory)
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundStyle(Color.accent)
				}
				.padding()
				.background(Colors.swiftUIColor(.textPrimary))
				.cornerRadius(12)
				
				// Job Title
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 4) {
						Text("Job Title")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						Text("*").foregroundStyle(.red)
					}
					BrandTextField(
						hasTitle: false,
						title: "",
						placeholder: "e.g., Barista Shift",
						text: $viewModel.jobName
					)
				}
				
				// Dates Selection
				VStack(alignment: .leading, spacing: 0) {
					Button(action: { withAnimation(.easeInOut(duration: 0.25)) { showCalendar.toggle() } }) {
						HStack {
							VStack(alignment: .leading, spacing: 2) {
								HStack(spacing: 4) {
									Text("Date")
										.font(.subheadline)
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
									Text("*").foregroundStyle(.red)
								}
								Text(selectedDatesLabel)
									.font(.subheadline)
									.fontWeight(.semibold)
									.foregroundStyle(viewModel.selectedDates.isEmpty ? Colors.swiftUIColor(.textSecondary) : Color.primary)
							}
							Spacer()
							Image(systemName: showCalendar ? "chevron.up" : "chevron.down")
								.font(.caption)
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						}
						.padding()
						.background(Colors.swiftUIColor(.textPrimary))
						.cornerRadius(showCalendar ? 0 : 12)
						.clipShape(
							.rect(
								topLeadingRadius: 12,
								bottomLeadingRadius: showCalendar ? 0 : 12,
								bottomTrailingRadius: showCalendar ? 0 : 12,
								topTrailingRadius: 12
							)
						)
					}
					.buttonStyle(.plain)

					if showCalendar {
						MultiDatePicker("Dates", selection: $viewModel.selectedDates, in: Date()...)
							.padding()
							.background(Colors.swiftUIColor(.textPrimary))
							.clipShape(
								.rect(
									topLeadingRadius: 0,
									bottomLeadingRadius: 12,
									bottomTrailingRadius: 12,
									topTrailingRadius: 0
								)
							)
					}
				}
				
				// Times
				VStack(alignment: .leading, spacing: 8) {
					Text("Shift Timing")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					
					HStack {
						DatePicker("Start", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
							.labelsHidden()
						Spacer()
						Text("to")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						Spacer()
						DatePicker("End", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
							.labelsHidden()
					}
					.padding()
					.background(Colors.swiftUIColor(.textPrimary))
					.cornerRadius(12)
				}
				
				// Break Duration
				VStack(alignment: .leading, spacing: 8) {
					Text("Break (Optional)")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					BrandTextField(
						hasTitle: false,
						title: "",
						placeholder: "e.g. 30 mins",
						text: $viewModel.breakDuration
					)
				}
				
				Spacer()
			}
			.padding()
		}
	}
}

#Preview {
	CreateJobTab1(
		viewModel: CreateJobViewModel(),
		selectedCategory: "Food & Beverage"
	)
}
