//
//  BrowseJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct BrowseJobs: View {
 @State private var searchText = ""
 @State private var sortOption: SortOption = .none
 @State private var selectedCategory: ServiceCategoryType? = nil
 @Environment(ServicesStore.self) var servicesStore

 enum SortOption {
  case none
  case price
  case alphabetical
 }

 var filteredServices: [JobService] {
  var services = servicesStore.getFlexibleJobs()

  if !searchText.isEmpty {
   services = services.filter {
    $0.title.localizedCaseInsensitiveContains(searchText) ||
    $0.description.localizedCaseInsensitiveContains(searchText) ||
    $0.location.name.localizedCaseInsensitiveContains(searchText)
   }
  }

  if let selectedCategory = selectedCategory {
   services = services.filter { $0.category == selectedCategory }
  }

  switch sortOption {
  case .none:
   return services
  case .price:
   return services.sorted { $0.price < $1.price }
  case .alphabetical:
   return services.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
  }
 }

 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()

   NavigationStack {
    VStack(spacing: 0) {
     ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
       Button(action: { selectedCategory = nil }) {
        Text("All")
         .font(.system(size: 14, weight: .semibold))
         .foregroundStyle(selectedCategory == nil ? .white : .gray)
         .padding(.horizontal, 16)
         .padding(.vertical, 8)
         .background(selectedCategory == nil ? Color.accentColor : Color.gray.opacity(0.1))
         .cornerRadius(20)
       }

       ForEach(ServiceCategoryType.allCases, id: \.self) { category in
        Button(action: { selectedCategory = category }) {
         Text(category.rawValue)
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(selectedCategory == category ? .white : .gray)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(selectedCategory == category ? Color.accentColor : Color.gray.opacity(0.1))
          .cornerRadius(20)
        }
       }
      }
      .padding(.horizontal)
      .padding(.vertical, 8)
     }

     ScrollView {
      if filteredServices.isEmpty {
       VStack(spacing: 12) {
        Image(systemName: "briefcase.circle")
         .font(.system(size: 48))
         .foregroundStyle(.gray)
        Text("No Jobs Yet")
         .font(.headline)
         .foregroundStyle(.gray)
       }
       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
       .padding()
      } else {
       VStack(spacing: 14) {
        ForEach(filteredServices, id: \.id) { service in
         ServiceCard(service: service)
        }
       }
       .padding()
      }
     }
     .scrollIndicators(.hidden)
    }
    .searchable(text: $searchText, prompt: "Browse Jobs....")
    .toolbar {
     ToolbarItem(placement: .topBarTrailing) {
      Menu {
       Button(action: { sortOption = .none }) {
        Label("No Sort", systemImage: "line.3.horizontal.decrease.circle")
       }
       Button(action: { sortOption = .price }) {
        Label("Sort by Price", systemImage: "dollarsign.circle")
       }
       Button(action: { sortOption = .alphabetical }) {
        Label("Sort A-Z", systemImage: "abc")
       }
      } label: {
       Image(systemName: "line.3.horizontal.decrease.circle.fill")
        .font(.system(size: 16))
      }
     }
    }
   }
  }
 }
}

#Preview {
 BrowseJobs()
}
