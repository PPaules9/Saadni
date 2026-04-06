//
//  NeedWork.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedWork: View {
 @Environment(AppCoordinator.self) var appCoordinator
 @Environment(ConversationsStore.self) var conversationsStore
 @Environment(ServicesStore.self) var servicesStore

	var body: some View {
		if #available(iOS 26, *) {
			if let coordinator = appCoordinator.studentCoordinator {
				TabView(selection: Binding(
					get: { coordinator.selectedTab },
					set: { coordinator.selectedTab = $0 }
				)) {
					Tab("Dashboard", systemImage: "house", value: ServiceProviderTab.home) {
						tabContent(for: .home, coordinator: coordinator)
					}
					Tab("Chat", systemImage: "text.bubble.fill", value: ServiceProviderTab.chat) {
						tabContent(for: .chat, coordinator: coordinator)
					}
					Tab("Jobs", systemImage: "calendar.day.timeline.left", value: ServiceProviderTab.myJobs) {
						tabContent(for: .myJobs, coordinator: coordinator)
					}
					Tab("Profile", systemImage: "person.fill", value: ServiceProviderTab.profile) {
						tabContent(for: .profile, coordinator: coordinator)
					}
					Tab(value: ServiceProviderTab.search, role: .search) {
						tabContent(for: .search, coordinator: coordinator)
					}
				}
				.sheet(item: Binding(
					get: { coordinator.topSheet },
					set: { _ in coordinator.dismissSheet() }
				)) { sheet in
					sheetContent(for: sheet)
						.environment(coordinator)
				}
				.tint(.accent)
				.background(Colors.swiftUIColor(.appBackground))
				.environment(coordinator)
			}
		} else {
			NeedWorkView()
		}
	}

	@ViewBuilder
	private func NeedWorkView() -> some View {
		
			if let coordinator = appCoordinator.studentCoordinator {
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
				LaunchScreen()
			}
		
	}
	
 @ViewBuilder
 private func tabContent(for tab: ServiceProviderTab, coordinator: StudentCoordinator) -> some View {
  let binding = coordinator.pathBinding(for: tab)
  NavigationStack(path: binding) {
   rootView(for: tab)
    .navigationDestination(for: ServiceProviderDestination.self) { destination in
     destinationView(for: destination)
    }
  }
 }

 @ViewBuilder
 private func tabContent(for tab: JobSeekerTab, coordinator: ProviderCoordinator) -> some View {
  let binding = coordinator.pathBinding(for: tab)
  NavigationStack(path: binding) {
   rootView(for: tab)
    .navigationDestination(for: JobSeekerDestination.self) { destination in
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
 private func rootView(for tab: JobSeekerTab) -> some View {
  switch tab {
  case .dashboard:
   DashboardView()
  case .chat:
   ChatView()
//  case .addJob:
   CreateJobSheet(selectedCategory: ServiceCategoryType.communityAndOutdoor.rawValue, initialJobName: nil, initialServiceImageName: nil)
  case .myJobs:
   AppliedJobsView()
  case .profile:
   ProfileView()
  }
 }

 @ViewBuilder
 private func destinationView(for destination: ServiceProviderDestination) -> some View {
  switch destination {
  case .serviceDetail(let service):
   ServiceDetailView(service: service)
  case .applicationsList(let serviceId, _):
   if let service = servicesStore.services.first(where: { $0.id == serviceId }) {
    ServiceApplicationsSheet(service: service)
   } else {
    ProgressView()
   }
  case .categoryDetail(let category):
   Text("Category: \(category.rawValue)")
  case .chatDetail(let conversationId):
   if let conversation = conversationsStore.getConversationById(conversationId) {
    ChatDetailView(conversation: conversation)
     .environment(conversationsStore)
     .environment(MessagesStore())
   } else {
    ProgressView()
   }
  case .createJob:
   EmptyView()
  case .performance:
   UserPerformanceView()
  case .completedServices:
   CompletedServicesView()
  case .userReviews(let userId):
   UserReviewsView(userId: userId)
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
    ProgressView()
   }
  } 
 }

 @ViewBuilder
 private func sheetContent(for sheet: SheetDestination) -> some View {
  switch sheet {
  case .createJob(let category, let initialName, let imageName):
   CreateJobSheet(selectedCategory: category, initialJobName: initialName, initialServiceImageName: imageName)
  case .addService:
   Text("Add Service View")
  case .applyToService(_, let serviceId):
   if let service = servicesStore.services.first(where: { $0.id == serviceId }) {
    ApplyJobSheet(service: service)
   } else {
    ProgressView()
   }
  case .applicationDetail(let app):
   if let service = servicesStore.services.first(where: { $0.id == app.serviceId }) {
    ServiceDetailView(service: service)
   } else {
    ProgressView()
   }
  case .applicationsList(let serviceId, _):
   if let service = servicesStore.services.first(where: { $0.id == serviceId }) {
    ServiceApplicationsSheet(service: service)
   } else {
    ProgressView()
   }
  case .imagePicker:
   ImagePickerSheet(selectedImage: .constant(nil))
  case .myAddresses:
   MyAddressesView()
  case .walletSheet:
   WalletSheet()
  case .notificationDrawer(let role):
   NotificationDrawerView(userRole: role)
  case .allActivities:
   AllActivitiesView()
  case .userProfile(let userId):
   UserProfileSheet(userId: userId)
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
