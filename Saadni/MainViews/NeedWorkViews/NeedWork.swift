//
//  NeedWork.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedWork: View {
 @Environment(AppCoordinator.self) var appCoordinator

 var body: some View {
  if let coordinator = appCoordinator.serviceProviderCoordinator {
   TabView(
    selection: Binding(
     get: { coordinator.selectedTab },
     set: { coordinator.selectTab($0) }
    )
   ) {
    ForEach(ServiceProviderTab.allCases, id: \.self) { tab in
     tabContent(for: tab, coordinator: coordinator)
      .tag(tab)
      .tabItem {
       Label(tab.title, systemImage: tab.icon)
      }
    }
   }
   .sheet(item: Binding(
    get: { coordinator.activeSheet },
    set: { _ in coordinator.dismissSheet() }
   )) { sheet in
    sheetContent(for: sheet)
   }
   .tint(.accent)
   .background(Colors.swiftUIColor(.appBackground))
   .environment(coordinator)
  } else {
   ProgressView().tint(.accent)
  }
 }

 @ViewBuilder
 private func tabContent(for tab: ServiceProviderTab, coordinator: ServiceProviderCoordinator) -> some View {
  let binding = coordinator.pathBinding(for: tab)
  NavigationStack(path: binding) {
   rootView(for: tab)
    .navigationDestination(for: ServiceProviderDestination.self) { destination in
     destinationView(for: destination)
    }
  }
 }

 @ViewBuilder
 private func rootView(for tab: ServiceProviderTab) -> some View {
  switch tab {
  case .home:
   DashboardView()
  case .chat:
   ChatView()
  case .myJobs:
   AppliedJobsView()
  case .profile:
   ProfileView()
  case .search:
   BrowseJobs()
  }
 }

 @ViewBuilder
 private func destinationView(for destination: ServiceProviderDestination) -> some View {
  switch destination {
  case .serviceDetail(let service):
   ServiceDetailView(service: service)
  case .applicationsList(let serviceId, let title):
   Text("Applications List for \(title)")
  case .categoryDetail(let category):
   Text("Category: \(category.rawValue)") // Placeholder
  }
 }

 @ViewBuilder
 private func sheetContent(for sheet: SheetDestination) -> some View {
  switch sheet {
  case .createJob(let category, let initialName):
   CreateJobSheet(selectedCategory: category, initialJobName: initialName)
  case .addService:
   Text("Add Service View")
  case .applyToService(let title, let id):
   Text("Apply Sheet for \(title)")
  case .applicationDetail(let app):
   Text("Application Detail Sheet")
  case .applicationsList(let serviceId, let title):
   Text("Applications List for \(title)")
  case .imagePicker:
   ImagePickerSheet(selectedImage: .constant(nil))
  }
 }
}

#Preview {
 NeedWork()
  .environment(AppCoordinator(
   authManager: AuthenticationManager(userCache: UserCache()),
   userCache: UserCache()
  ))
}
