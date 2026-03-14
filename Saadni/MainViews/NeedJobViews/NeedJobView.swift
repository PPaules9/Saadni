//
//  NeedJobView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedJobView: View {
 @Environment(AppCoordinator.self) var appCoordinator
 @Environment(ConversationsStore.self) var conversationsStore

 var body: some View {
  if let coordinator = appCoordinator.jobSeekerCoordinator {
   TabView(
    selection: Binding(
     get: { coordinator.selectedTab },
     set: { coordinator.selectTab($0) }
    )
   ) {
    ForEach(JobSeekerTab.allCases, id: \.self) { tab in
     tabContent(for: tab, coordinator: coordinator)
      .tag(tab)
      .tabItem {
       Label(tab.title, systemImage: tab.icon)
      }
    }
   }
   .sheet(item: Binding(
    get: { coordinator.topSheet },
    set: { _ in coordinator.dismissSheet() }
   )) { sheet in
    sheetContent(for: sheet)
     .environment(coordinator) // Allow sheet to present another sheet
   }
   .tint(.accent)
   .background(Colors.swiftUIColor(.appBackground))
   .environment(coordinator)
  } else {
   ProgressView().tint(.accent)
  }
 }

 @ViewBuilder
 private func tabContent(for tab: JobSeekerTab, coordinator: JobSeekerCoordinator) -> some View {
  let binding = coordinator.pathBinding(for: tab)
  NavigationStack(path: binding) {
   rootView(for: tab)
    .navigationDestination(for: JobSeekerDestination.self) { destination in
     destinationView(for: destination)
    }
  }
 }

 @ViewBuilder
 private func rootView(for tab: JobSeekerTab) -> some View {
  switch tab {
  case .dashboard:
   HomeView()
  case .chat:
   ChatView()
  case .addJob:
   CreateJobSheet(selectedCategory: "homeCleaning", initialJobName: nil)
  case .myJobs:
   myJobs()
  case .profile:
   ProfileView()
  }
 }

 @ViewBuilder
 private func destinationView(for destination: JobSeekerDestination) -> some View {
  switch destination {
  case .serviceDetail(let service):
   ServiceDetailView(service: service)
  case .categoryDetail(let category):
   Text("Category: \(category.rawValue)") // Placeholder
  case .chatDetail(let conversationId):
   if let conversation = conversationsStore.getConversationById(conversationId) {
    ChatDetailView(conversation: conversation)
     .environment(conversationsStore)
     .environment(MessagesStore())
   } else {
    // Fallback: conversation not loaded yet
    ProgressView()
     .onAppear {
      // Conversation will load via real-time listener
     }
   }
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
  case .applicationDetail:
   Text("Application Detail Sheet")
  case .applicationsList:
   Text("Applications List Sheet")
  case .imagePicker:
   ImagePickerSheet(selectedImage: .constant(nil))
  }
 }
}

#Preview {
 NeedJobView()
  .environment(AppCoordinator(
   authManager: AuthenticationManager(userCache: UserCache()),
   userCache: UserCache()
  ))
}
