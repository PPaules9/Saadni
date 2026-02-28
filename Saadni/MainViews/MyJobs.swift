//
//  MyJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//
import SwiftUI

enum JobTab {
 case applied
 case booked
 case completed
}


struct MyJobs: View {
 @State private var selectedTab: JobTab = .applied

 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()

   NavigationStack {
    VStack(spacing: 0) {

     // Tab Selection Header
     VStack(spacing: 0) {
      HStack(spacing: 0) {
       tabButton(
        title: "Applied",
        tab: .applied,
        selectedTab: $selectedTab
       )

       tabButton(
        title: "Booked",
        tab: .booked,
        selectedTab: $selectedTab
       )

       tabButton(
        title: "Completed",
        tab: .completed,
        selectedTab: $selectedTab
       )
      }

      // Underline indicator
      HStack(spacing: 0) {
       tabUnderlineIndicator(isSelected: selectedTab == .applied)
       tabUnderlineIndicator(isSelected: selectedTab == .booked)
       tabUnderlineIndicator(isSelected: selectedTab == .completed)
      }
      .frame(height: 2)
     }

     // Tab Content
     VStack {
      switch selectedTab {
      case .applied:
       AppliedTabView()
      case .booked:
       BookedTabView()
      case .completed:
       CompletedTabView()
      }
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    .navigationTitle("My Jobs")
   }
  }
 }
}

struct tabButton: View {
 let title: String
 let tab: JobTab
 @Binding var selectedTab: JobTab

 var isSelected: Bool {
  selectedTab == tab
 }

 var body: some View {
  Button(action: { selectedTab = tab }) {
   Text(title)
    .font(.headline)
    .foregroundStyle(isSelected ? Color.accent : Color(Colors.swiftUIColor(.textSecondary)))
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
  }
 }
}

struct tabUnderlineIndicator: View {
 let isSelected: Bool

 var body: some View {
  Color(isSelected ? Color.accent : Color(.clear))
   .frame(maxWidth: .infinity)
 }
}



struct AppliedTabView: View {
 var body: some View {
  VStack(spacing: 24) {
   Spacer()

   Image(systemName: "magnifyingglass")
    .font(.system(size: 60))
    .foregroundStyle(.accent.opacity(0.3))

   VStack(spacing: 8) {
    Text("Find your next job!")
     .font(.headline)
    Text("You currently have no open applications")
     .font(.subheadline)
     .foregroundStyle(.gray)
   }

   BrandButton("Browse jobs", hasIcon: false, icon: "", secondary: false) {

   }
   Spacer()
   Spacer()
  }
  .padding(20)

 }
}

struct BookedTabView: View {
 var body: some View {
  VStack(spacing: 24) {
   Spacer()

   Image(systemName: "calendar")
    .font(.system(size: 60))
    .foregroundStyle(.accent.opacity(0.3))

   VStack(alignment: .center, spacing: 8) {
    Text("No booked jobs")
     .font(.headline)
    Text("Your booked jobs will appear here")
     .font(.subheadline)
     .foregroundStyle(.gray)
   }

   .padding()
   Spacer()
   Spacer()
  }
 }
}

struct CompletedTabView: View {
 var body: some View {
  VStack(spacing: 24) {
   Spacer()

   Image(systemName: "checkmark.circle")
    .font(.system(size: 60))
    .foregroundStyle(.accent.opacity(0.3))

   VStack(spacing: 8) {
    Text("No completed jobs")
     .font(.headline)
    Text("Your completed jobs will appear here")
     .font(.subheadline)
     .foregroundStyle(.gray)
   }
   Spacer()
   Spacer()
  }
  .padding(20)
 }
}

#Preview {
 MyJobs()
}
