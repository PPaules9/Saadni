//
//  BrowseJobs.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct BrowseJobs: View {
 @State private var searchText = ""
 @State private var sortOption: SortOption = .none
 @State private var selectedCategory: ServiceCategoryType? = nil
 @State var selectedDate: Date?
 @State private var viewMode: ViewMode = .grid
 @Environment(ServicesStore.self) var servicesStore
 @Environment(StudentCoordinator.self) var coordinator

 init(selectedDate: Date? = nil) {
  _selectedDate = State(initialValue: selectedDate)
 }

 enum SortOption {
  case none
  case price
  case alphabetical
 }

 enum ViewMode {
  case grid
  case list
 }

 private let mockServices: [JobService] = [
  JobService(
   title: "Help Cleaning",
   price: 250,
   location: ServiceLocation(name: "Cairo, Egypt", latitude: nil, longitude: nil),
   description: "Need help cleaning my apartment",
   image: ServiceImage(),
   category: .cleaningAndMaintenance,
   providerId: "provider_1"
  ),
  JobService(
   title: "Babysitting Services",
   price: 150,
   location: ServiceLocation(name: "Giza, Egypt", latitude: nil, longitude: nil),
   description: "Looking for experienced babysitter",
   image: ServiceImage(),
   category: .communityAndOutdoor,
   providerId: "provider_2"
  ),
  JobService(
   title: "Moving Help",
   price: 500,
   location: ServiceLocation(name: "Alexandria, Egypt", latitude: nil, longitude: nil),
   description: "Need assistance moving to new apartment",
   image: ServiceImage(),
   category: .movingAndLabour,
   providerId: "provider_3"
  )
 ]

 var filteredServices: [JobService] {
  var services = servicesStore.getAllServices()

  if !searchText.isEmpty {
   services = services.filter {
    $0.title.localizedCaseInsensitiveContains(searchText) ||
    $0.description.localizedCaseInsensitiveContains(searchText) ||
    $0.location.name.localizedCaseInsensitiveContains(searchText)
   }
  }

  if let date = selectedDate {
   services = services.filter { service in
    guard let sDate = service.serviceDate else { return false }
    return Calendar.current.isDate(sDate, inSameDayAs: date)
   }
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

   VStack(spacing: 0) {
    
    // Active Filters Bar
    if selectedDate != nil {
     HStack {
      Text("Filtered by Date: \(selectedDate!.formatted(date: .abbreviated, time: .omitted))")
       .font(.caption)
       .fontWeight(.semibold)
       .foregroundStyle(Color.accentColor)
      
      Spacer()
      
      Button(action: { selectedDate = nil }) {
       Image(systemName: "xmark.circle.fill")
        .foregroundStyle(.gray)
      }
     }
     .padding(.horizontal)
     .padding(.vertical, 8)
     .background(Color.accentColor.opacity(0.1))
    }
    
    // Category Scroll
    ScrollView(.horizontal, showsIndicators: false) {
     HStack(spacing: 8) {
      Button(action: {
       selectedCategory = nil
       Task { await servicesStore.fetchServicesPage(category: nil, reset: true) }
      }) {
       Text("All")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(selectedCategory == nil ? .white : .gray)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(selectedCategory == nil ? Color.accentColor : Color.gray.opacity(0.1))
        .cornerRadius(20)
      }

      ForEach(ServiceCategoryType.allCases, id: \.self) { category in
       Button(action: {
        selectedCategory = category
        Task { await servicesStore.fetchServicesPage(category: category, reset: true) }
       }) {
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
     VStack(spacing: 14) {
      if filteredServices.isEmpty && !servicesStore.isLoadingServices {
       VStack(spacing: 16) {
        Image(systemName: "briefcase")
         .font(.system(size: 48))
         .foregroundStyle(.gray)
        Text("No Jobs Found")
         .font(.headline)
         .foregroundStyle(.gray)
        Text("Try adjusting your filters")
         .font(.caption)
         .foregroundStyle(.gray)
       }
       .frame(maxWidth: .infinity, maxHeight: .infinity)
       .padding()
      } else {
       ForEach(filteredServices, id: \.id) { service in
        switch viewMode {
        case .grid:
         ServiceCard(service: service)
        case .list:
         ServiceListCard(service: service)
        }
       }

       // Load-more trigger: fires when this row becomes visible
       if servicesStore.hasMoreServices {
        ProgressView()
         .padding()
         .onAppear {
          Task { await servicesStore.fetchServicesPage(category: selectedCategory) }
         }
       }
      }
     }
     .padding()
    }
    .scrollIndicators(.hidden)
    .refreshable {
     await servicesStore.fetchServicesPage(category: selectedCategory, reset: true)
    }
   }
   .searchable(text: $searchText, prompt: "Browse Jobs....")
   .toolbar {
    ToolbarItem(placement: .topBarLeading) {
     Button {
      withAnimation(.easeInOut(duration: 0.2)) {
       viewMode = viewMode == .grid ? .list : .grid
      }
     } label: {
      Image(systemName: viewMode == .grid ? "list.bullet" : "square.grid.2x2.fill")
       .font(.system(size: 16))
     }
    }

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
  .onAppear {
   if let date = coordinator.filterDate {
    selectedDate = date
    coordinator.filterDate = nil
   }
  }
 }
}

#Preview {
 let userCache = UserCache()
 return BrowseJobs()
  .environment(ServicesStore())
  .environment(AuthenticationManager(userCache: userCache))
  .environment(userCache)
  .environment(StudentCoordinator())
}
