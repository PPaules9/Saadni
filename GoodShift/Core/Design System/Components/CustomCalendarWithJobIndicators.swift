//
//  CustomCalendarWithJobIndicators.swift
//  GoodShift
//
//  Created by Pavly Paules on 31/03/2026.
//

import SwiftUI

struct CustomCalendarWithJobIndicators: View {
	@Binding var selectedDate: Date
	let jobDates: Set<DateComponents> // Set of dates that have jobs
	let onDateSelected: (Date) -> Void
	
	@State private var currentMonth: Date = Date()
	
	var body: some View {
		VStack(spacing: 16) {
			// Month/Year Header
			HStack {
				Button(action: { previousMonth() }) {
					Image(systemName: "chevron.left")
						.font(.system(size: 16, weight: .semibold))
						.foregroundStyle(.primary)
				}
				
				Spacer()
				
				Text(monthYearString(currentMonth))
					.font(.headline)
					.foregroundStyle(.primary)
				
				Spacer()
				
				Button(action: { nextMonth() }) {
					Image(systemName: "chevron.right")
						.font(.system(size: 16, weight: .semibold))
						.foregroundStyle(.primary)
				}
			}
			.padding(.horizontal, 20)
			
			// Day Headers (Sun, Mon, Tue, etc.)
			HStack(spacing: 0) {
				ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
					Text(day)
						.font(.caption)
						.fontWeight(.semibold)
						.foregroundStyle(.secondary)
						.frame(maxWidth: .infinity)
				}
			}
			.padding(.horizontal, 20)
			
			// Calendar Grid
			VStack(spacing: 8) {
				ForEach(Array(calendarWeeks().enumerated()), id: \.offset) { weekIndex, week in
					HStack(spacing: 0) {
						ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, date in
							if let date = date {
								VStack(spacing: 4) {
									// Blue dot indicator if date has jobs
									if hasJobsOnDate(date) {
										Circle()
											.fill(Color.accent)
											.frame(width: 4, height: 4)
									} else {
										Color.clear
											.frame(width: 4, height: 4)
									}
									
									// Day number
									Text("\(Calendar.current.component(.day, from: date))")
										.font(.subheadline)
										.fontWeight(.medium)
										.foregroundStyle(isToday(date) ? .white : .primary)
								}
								.frame(maxWidth: .infinity)
								.frame(height: 50)
								.background(
									isSelected(date) ?
									Color.accent :
										isToday(date) ?
									Color.accent.opacity(0.2) :
										Color.clear
								)
								.cornerRadius(8)
								.onTapGesture {
									selectedDate = date
									onDateSelected(date)
								}
							} else {
								Color.clear
									.frame(maxWidth: .infinity)
									.frame(height: 50)
							}
						}
					}
				}
			}
			.padding(.horizontal, 20)
		}
		.padding(.vertical, 12)
		.background(Colors.swiftUIColor(.textPrimary))
		.cornerRadius(24)
	}
	
	// MARK: - Helper Methods
	
	private func previousMonth() {
		withAnimation {
			currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
		}
	}
	
	private func nextMonth() {
		withAnimation {
			currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
		}
	}
	
	private func monthYearString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM yyyy"
		return formatter.string(from: date)
	}
	
	private func calendarWeeks() -> [[Date?]] {
		let calendar = Calendar.current
		let range = calendar.range(of: .day, in: .month, for: currentMonth)!
		let numDays = range.count
		let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
		
		var weeks: [[Date?]] = []
		var currentWeek: [Date?] = Array(repeating: nil, count: firstWeekday)
		
		for day in 1...numDays {
			let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
			currentWeek.append(date)
			
			if currentWeek.count == 7 {
				weeks.append(currentWeek)
				currentWeek = []
			}
		}
		
		if !currentWeek.isEmpty {
			while currentWeek.count < 7 {
				currentWeek.append(nil)
			}
			weeks.append(currentWeek)
		}
		
		return weeks
	}
	
	private func isToday(_ date: Date) -> Bool {
		Calendar.current.isDateInToday(date)
	}
	
	private func isSelected(_ date: Date) -> Bool {
		Calendar.current.isDate(date, inSameDayAs: selectedDate)
	}
	
	private func hasJobsOnDate(_ date: Date) -> Bool {
		let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
		return jobDates.contains(dateComponents)
	}
}

#Preview {
	@State var selectedDate = Date()
	
	return CustomCalendarWithJobIndicators(
		selectedDate: $selectedDate,
		jobDates: [
			DateComponents(year: 2026, month: 3, day: 28),
			DateComponents(year: 2026, month: 3, day: 30),
			DateComponents(year: 2026, month: 4, day: 5)
		]
	) { date in
		print("Selected: \(date)")
	}
}
