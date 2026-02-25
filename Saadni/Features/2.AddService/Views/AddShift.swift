//
//  AddShift.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct AddShift: View {
 @Binding var selectedJobPath: String
 @Binding var jobType: JobType?
 @Environment(\.dismiss) var dismiss

 @State private var shiftName: String = ""
 @State private var selectedCategory: ShiftCategory? = .barista
 @State private var customCategoryName: String = ""
 @State private var useCustomCategory: Bool = false
 @State private var startTime: Date = Date()
 @State private var endTime: Date = Date().addingTimeInterval(3600 * 8)
 @State private var startDate: Date = Date()
 @State private var isRepeated: Bool = false
 @State private var selectedDates: Set<Date> = []
 @State private var repeatEndDate: Date = Date().addingTimeInterval(86400 * 26)
 @State private var description: String = ""
 @State private var showCalendar: Bool = false

 var repeatedDatesCount: Int {
  selectedDates.count
 }

 var canAddMoreDates: Bool {
  repeatedDatesCount < 26
 }

 var body: some View {
  NavigationStack {
   VStack {
    ScrollView {
     VStack(spacing: 16) {
      // Shift Name
      VStack(alignment: .leading, spacing: 8) {
       Text("Shift Name")
        .font(.subheadline)
        .bold()
       
       BrandTextField(
        hasTitle: false,
        title: "Name",
        placeholder: "e.g., Morning Shift",
        text: $shiftName
       )
      }
      
      // Category Selection
      VStack(alignment: .leading, spacing: 8) {
       Text("Category")
        .font(.subheadline)
        .bold()
       
       Menu {
        ForEach(ShiftCategory.allCases, id: \.self) { category in
         Button(action: {
          selectedCategory = category
          useCustomCategory = false
         }) {
          HStack {
           Text(category.rawValue)
           if !useCustomCategory && selectedCategory == category {
            Image(systemName: "checkmark")
             .foregroundStyle(.accent)
           }
          }
         }
        }
        
        Divider()
        
        Button(action: {
         useCustomCategory = true
        }) {
         HStack {
          Text("Custom Category")
          if useCustomCategory {
           Image(systemName: "checkmark")
            .foregroundStyle(.accent)
          }
         }
        }
       } label: {
        HStack {
         Text(useCustomCategory ? customCategoryName.isEmpty ? "Enter custom..." : customCategoryName : selectedCategory?.rawValue ?? "Select Category")
          .foregroundStyle(.primary)
         Spacer()
         Image(systemName: "chevron.down")
          .foregroundStyle(.accent)
        }
        .padding(12)
        .background(Colors.swiftUIColor(.textPrimary))
        .cornerRadius(32)
        .overlay(
         RoundedRectangle(cornerRadius: 32)
          .fill(Color.clear)
          .stroke(.gray.opacity(0.3), lineWidth: 1)
        )
       }
       
       if useCustomCategory {
        BrandTextField(
         hasTitle: false,
         title: "Custom Category",
         placeholder: "Enter shift category",
         text: $customCategoryName
        )
       }
      }
      
      // Start Time
      VStack(alignment: .leading, spacing: 8) {
       HStack{
        Text("This Shift Will Be On")
         .font(.subheadline)
         .bold()
        
        Spacer()
        
        DatePicker(
         "",
         selection: $startDate,
         displayedComponents: .date
        )
        .labelsHidden()
        .padding(8)
        .background(Colors.swiftUIColor(.textPrimary))
        .cornerRadius(32)
        
       }
       HStack{
        VStack{
         Text("Starting From")
          .font(.subheadline)
          .bold()
         
         DatePicker(
          "",
          selection: $startTime,
          displayedComponents: .hourAndMinute
         )
         .labelsHidden()
         .padding(8)
         .background(Colors.swiftUIColor(.textPrimary))
         .cornerRadius(32)
        }
        
        Spacer()
        
        // End Time
        VStack(alignment: .leading, spacing: 8) {
         Text("End Time")
          .font(.subheadline)
          .bold()
         
         DatePicker(
          "End Time",
          selection: $endTime,
          displayedComponents: .hourAndMinute
         )
         .labelsHidden()
         .padding(8)
         .background(Colors.swiftUIColor(.textPrimary))
         .cornerRadius(32)
        }
       }
     }
      // Start Date
      VStack(alignment: .leading, spacing: 8) {
      
      }

      // Repeated Shift Toggle
      VStack(alignment: .leading, spacing: 12) {
       HStack {
        Text("Repeated Shift")
         .font(.subheadline)
         .bold()

        Spacer()

        Toggle("", isOn: $isRepeated)
         .tint(.accent)
       }

       if isRepeated {
        VStack(alignment: .leading, spacing: 12) {
         HStack {
          if canAddMoreDates {
           
          } else {
           Text("Limit reached")
            .font(.caption)
            .foregroundStyle(.accent)
          }
          
          Spacer()
          Text("Selected days: \(repeatedDatesCount)/26")
           .font(.caption)
           .foregroundStyle(.gray)
         }

         // Calendar Preview
         CalendarPickerView(
          selectedDates: $selectedDates,
          maxDates: 26,
          startDate: startDate
         )


        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(8)
       }
      }

      // Description
      VStack(alignment: .leading, spacing: 8) {
       Text("Description")
        .font(.subheadline)
        .bold()

       BrandTextEditor(
        hasTitle: false,
        title: "Description",
        placeholder: "Add any details about this shift",
        text: $description
       )
      }
     }
     .padding(20)
    }

    Spacer()

    HStack(spacing: 12) {
     Button(action: {
      jobType = nil
      dismiss()
     }) {
      Text("Cancel")
       .frame(maxWidth: .infinity)
       .padding(.vertical, 12)
       .background(Color(.systemGray6))
       .cornerRadius(100)
       .foregroundStyle(.primary)
     }

     Button(action: {
      let isValid = !shiftName.trimmingCharacters(in: .whitespaces).isEmpty &&
                    (useCustomCategory ? !customCategoryName.trimmingCharacters(in: .whitespaces).isEmpty : selectedCategory != nil)

      if isValid {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "hh:mm a"
       let startTimeStr = dateFormatter.string(from: startTime)
       let endTimeStr = dateFormatter.string(from: endTime)

       let dateOnlyFormatter = DateFormatter()
       dateOnlyFormatter.dateFormat = "d MMM yyyy"
       let startDateStr = dateOnlyFormatter.string(from: startDate)

       let categoryName = useCustomCategory ? customCategoryName : (selectedCategory?.rawValue ?? "Unknown")
       let repeatInfo = isRepeated ? " (Repeats: \(repeatedDatesCount) days)" : ""
       selectedJobPath = "Shift: \(shiftName) - \(categoryName) - \(startTimeStr) to \(endTimeStr) - \(startDateStr)\(repeatInfo)"
       jobType = nil
       dismiss()
      }
     }) {
      Text("Confirm")
       .frame(maxWidth: .infinity)
       .padding(.vertical, 12)
       .background(Color.accent)
       .cornerRadius(100)
       .foregroundStyle(.white)
     }
     .disabled(shiftName.trimmingCharacters(in: .whitespaces).isEmpty ||
               (useCustomCategory && customCategoryName.trimmingCharacters(in: .whitespaces).isEmpty))
    }
    .padding(20)
   }
   .navigationTitle("Add Shift")
   .navigationBarTitleDisplayMode(.inline)
  }
 }
}

// Calendar Picker Component
struct CalendarPickerView: View {
 @Binding var selectedDates: Set<Date>
 let maxDates: Int
 let startDate: Date

 var body: some View {
  VStack(spacing: 12) {
   let calendar = Calendar.current
   let monthsToShow = 2
   let today = Date()

   ForEach(0..<monthsToShow, id: \.self) { monthOffset in
    let month = calendar.date(byAdding: .month, value: monthOffset, to: startDate) ?? startDate
    let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) ?? month

    VStack(spacing: 8) {
     // Month Header
     HStack {
      Text(monthStart, style: .date)
       .font(.subheadline)
       .bold()
      Spacer()
     }
     .padding(.horizontal, 4)

     // Calendar Grid
     let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 0
     let firstWeekday = calendar.component(.weekday, from: monthStart)
     let columns = Array(repeating: GridItem(.flexible()), count: 7)

     LazyVGrid(columns: columns, spacing: 4) {
      // Empty cells for days before month starts
      ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
       Color.clear.frame(height: 32)
      }

      // Days of month
      ForEach(1...daysInMonth, id: \.self) { day in
       let dateComponents = DateComponents(
        year: calendar.component(.year, from: monthStart),
        month: calendar.component(.month, from: monthStart),
        day: day
       )
       let date = calendar.date(from: dateComponents) ?? Date()
       let isSelected = selectedDates.contains { calendar.isDate($0, inSameDayAs: date) }
       let isBeforeToday = date < calendar.startOfDay(for: today)

       Button(action: {
        if isBeforeToday { return }

        if isSelected {
         selectedDates = selectedDates.filter { !calendar.isDate($0, inSameDayAs: date) }
        } else if selectedDates.count < maxDates {
         selectedDates.insert(date)
        }
       }) {
        Text("\(day)")
         .font(.caption)
         .frame(maxWidth: .infinity)
         .frame(height: 32)
         .background(isSelected ? Color.accent : Color.clear)
         .foregroundStyle(isSelected ? .white : (isBeforeToday ? .gray : .primary))
         .cornerRadius(4)
       }
       .disabled(isBeforeToday)
      }
     }
    }
    .padding(8)
    .background(Color(.systemGray6).opacity(0.3))
    .cornerRadius(8)
   }
  }
 }
}

#Preview {
 AddShift(
  selectedJobPath: .constant(""),
  jobType: .constant(.shift)
 )
}
 
