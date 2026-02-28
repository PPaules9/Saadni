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
 @Environment(ServicesStore.self) var servicesStore

 var filteredServices: [FlexibleJobService] {
  if searchText.isEmpty {
   return servicesStore.getAllFlexibleJobs()
  }
  return servicesStore.getAllFlexibleJobs().filter {
   $0.title.localizedCaseInsensitiveContains(searchText) ||
   $0.description.localizedCaseInsensitiveContains(searchText) ||
   $0.location.name.localizedCaseInsensitiveContains(searchText)
  }
 }

 var body: some View {
  NavigationStack{
   ScrollView(){
    if filteredServices.isEmpty {
     VStack(spacing: 12) {
      Image(systemName: "briefcase.circle")
       .font(.system(size: 48))
       .foregroundStyle(.gray)
      Text("No Flexible Jobs Yet")
       .font(.headline)
       .foregroundStyle(.gray)
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
     .padding()
    } else {
     VStack(spacing: 14){
      ForEach(filteredServices, id: \.id) { service in
       ServiceCard(serviceData: .flexibleJob(service))
      }
     }
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
 @Environment(ServicesStore.self) var servicesStore

 var filteredServices: [ShiftService] {
  if searchText.isEmpty {
   return servicesStore.getAllShifts()
  }
  return servicesStore.getAllShifts().filter {
   $0.title.localizedCaseInsensitiveContains(searchText) ||
   $0.description.localizedCaseInsensitiveContains(searchText) ||
   $0.location.name.localizedCaseInsensitiveContains(searchText) ||
   $0.shiftName.localizedCaseInsensitiveContains(searchText)
  }
 }

 var body: some View {
  NavigationStack{
   ScrollView(){
    if filteredServices.isEmpty {
     VStack(spacing: 12) {
      Image(systemName: "briefcase.circle")
       .font(.system(size: 48))
       .foregroundStyle(.gray)
      Text("No Shift Jobs Yet")
       .font(.headline)
       .foregroundStyle(.gray)
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
     .padding()
    } else {
     VStack(spacing: 14){
      ForEach(filteredServices, id: \.id) { service in
       ServiceCard(serviceData: .shift(service))
      }
     }
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
