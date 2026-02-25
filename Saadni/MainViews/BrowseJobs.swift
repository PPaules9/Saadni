//
//  BrowseJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI



struct BrowseJobs: View {
 @State private var selectedTab: JobType = .flexibleJobs
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    VStack(spacing: 0) {
     // Tab Selection Header
     VStack(spacing: 0) {
      HStack(spacing: 0) {
       BrowseJobTabButton(
        title: "Flexible Jobs",
        tab: .flexibleJobs,
        selectedTab: $selectedTab
       )
       
       BrowseJobTabButton(
        title: "Shift Jobs",
        tab: .shift,
        selectedTab: $selectedTab
       )
      }
      
      // Underline indicator
      HStack(spacing: 0) {
       tabUnderlineIndicator(isSelected: selectedTab == .flexibleJobs)
       tabUnderlineIndicator(isSelected: selectedTab == .shift)
      }
      .frame(height: 2)
     }
     
     // Tab Content
     VStack {
      switch selectedTab {
      case .flexibleJobs:
       FlexibleJobs()
      case .shift:
       ShiftJobs()
      }
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    .navigationTitle("Jobs Feed")
   }
  }
 }
}


struct BrowseJobTabButton: View {
 let title: String
 let tab: JobType
 @Binding var selectedTab: JobType
 
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

struct FlexibleJobs: View {
 @State private var searchText = ""
 
 var body: some View {
  NavigationStack{
   ScrollView(){
    VStack(spacing: 14){
     ServiceCard(title: "Washing", hasPhoto: false, imageName: "washer", price: "250 EGP", locationName: "Cairo, Egypt")
     ServiceCard(title: "Help Cleaning House Before Ramdan", hasPhoto: false, imageName: "hands.sparkles", price: "600 EGP", locationName: "ElRehab, Cairo")
    }
   }
   .padding()
   .searchable(text: $searchText, prompt: "Browse Flexible Jobs....")
   .scrollIndicators(.hidden)
  }
 }
}

struct ShiftJobs: View {
 @State private var searchText = ""
 var body: some View {
  NavigationStack{
   ScrollView(){
    VStack(spacing: 14){
     ServiceCard(title: "Barista Shift at Starbucks", hasPhoto: false, imageName: "mug.fill", price: "400 EGP/Hour", locationName: "Helioples, Egypt")
     ServiceCard(title: "Cashier Shift at Al Ahram Mall", hasPhoto: false, imageName: "creditcard", price: "3000 EGP", locationName: "Cairo")
     ServiceCard(title: "ChillOut El Rehab Benzene Shift", hasPhoto: false, imageName: "hexagon.fill", price: "1000 EGP", locationName: "Rehab, Cairo")
    }
   }
   .padding()
   .searchable(text: $searchText, prompt: "Browse Shifts....")
   .scrollIndicators(.hidden)
  }
 }
}

#Preview {
 BrowseJobs()
}
