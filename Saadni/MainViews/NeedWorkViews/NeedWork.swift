//
//  NeedWork.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedWork: View {
 @Environment(AppCoordinator.self) var appCoordinator
 @Environment(ConversationsStore.self) var conversationsStore

	var body: some View {
		if #available(iOS 26, *) {
			TabView {
				Tab("Dashboard", systemImage: "house") {
					NavigationStack{
						DashboardView()
					}
				}
				
				Tab("Chat", systemImage: "text.bubble.fill") {
					NavigationStack{
						ChatView()
					}
				}
				
				Tab("Add", systemImage: "plus") {
					NavigationStack{
						AppliedJobsView()
					}
				}
				
				
				Tab("Profile", systemImage: "person.fill") {
					NavigationStack{
						ProfileView()
					}
				}
				
				Tab(role: .search){
					NavigationStack{
						BrowseJobs()
					}
				}
				
			}
			.tint(.accent)
		
	
		} else {
			NeedWorkView()
		}
	}

	@ViewBuilder
	private func NeedWorkView() -> some View {
		
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
	case .search:
		BrowseJobs()
  case .profile:
   ProfileView()
 
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
	let userCache = UserCache()
	let authManager = AuthenticationManager(userCache: userCache)

 NeedWork()
  .environment(AppCoordinator(
   authManager: AuthenticationManager(userCache: UserCache()),
   userCache: UserCache()
  ))
	.environment(ConversationsStore())
	.environment(authManager)

}
