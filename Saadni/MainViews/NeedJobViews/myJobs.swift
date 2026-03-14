//
//  myJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct myJobs: View {
 @Environment(AuthenticationManager.self) var authManager
 @Environment(ServicesStore.self) var servicesStore
 @Environment(AppCoordinator.self) var appCoordinator
 
 @State private var userServices: [JobService] = []
 @State private var isLoading: Bool = true
 @State private var filterOption: ServiceFilterOption = .active
 
 var filteredServices: [JobService] {
  switch filterOption {
  case .all:
   return userServices
  case .active:
   return userServices.filter {
    $0.status == .published || $0.status == .active
   }
  case .completed:
   return userServices.filter { $0.status == .completed }
  }
 }
 
 var body: some View {
  NavigationStack {
   ScrollView {
    if isLoading {
     VStack(spacing: 12) {
      ProgressView()
       .tint(.accent)
      Text("Loading your jobs...")
       .font(.subheadline)
       .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .frame(maxWidth: .infinity)
     .padding(.top, 100)
    } else if filteredServices.isEmpty {
     ContentUnavailableView(
      emptyStateTitle,
      systemImage: "briefcase",
      description: Text(emptyStateDescription)
     )
     .padding(.top, 100)
    } else {
     LazyVStack(spacing: 16) {
      ForEach(filteredServices) { service in
       Button(action: {
        appCoordinator.serviceProviderCoordinator?.navigate(to: .serviceDetail(service))
       }) {
        ServiceCard(service: service)
       }
      }
     }
     .padding()
    }
   }
   .navigationTitle("My Jobs")
   .background(Colors.swiftUIColor(.appBackground))
   .toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
     Menu {
      Picker("Filter", selection: $filterOption) {
       ForEach(ServiceFilterOption.allCases, id: \.self) { option in
        Text(option.title).tag(option)
       }
      }
     } label: {
      Image(systemName: "line.3.horizontal.decrease.circle")
       .foregroundStyle(.accent)
     }
    }
   }
   .task {
    await loadServices()
   }
   .refreshable {
    await loadServices()
   }
  }
 }
 
 private func loadServices() async {
  isLoading = true
  guard let userId = authManager.currentUserId else {
   isLoading = false
   return
  }
  userServices = await servicesStore.fetchUserServices(userId: userId)
  isLoading = false
 }
 
 private var emptyStateTitle: String {
  switch filterOption {
  case .all: return "No Jobs Posted"
  case .active: return "No Active Jobs"
  case .completed: return "No Completed Jobs"
  }
 }
 
 private var emptyStateDescription: String {
  switch filterOption {
  case .all: return "Start by creating your first job posting"
  case .active: return "You don't have any active job postings"
  case .completed: return "No jobs have been completed yet"
  }
 }
}

enum ServiceFilterOption: String, CaseIterable {
 case all = "All"
 case active = "Active"
 case completed = "Completed"
 
 var title: String { rawValue }
}

#Preview {
 let userCache = UserCache()
 let authManager = AuthenticationManager(userCache: userCache)
 return myJobs()
  .environment(authManager)
  .environment(ServicesStore())
  .environment(AppCoordinator(authManager: authManager, userCache: userCache))
}
