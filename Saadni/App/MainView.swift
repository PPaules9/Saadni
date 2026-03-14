//
//  MainView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct MainView: View {
 @Environment(AppContainer.self) var container
 @State private var reviewsStore = ReviewsStore()
 @State private var walletStore = WalletStore()
 @State private var appCoordinator: AppCoordinator?

 var body: some View {
  Group {
   switch container.authManager.authState {
   case .authenticating:
    ProgressView().tint(.accent)
   case .unauthenticated:
    if container.appStateManager.hasSeenOnboarding {
     AuthenticationView()
    } else {
     OnboardingView()
    }
   case .authenticated:
    // Read live user from currentUser (delegates to userCache)
    if let user = container.authManager.currentUser {
     if container.appStateManager.hasSelectedRole {
      // Only show content if coordinator is ready
      if let appCoordinator = appCoordinator {
       authenticatedContent(for: user)
        .environment(appCoordinator)
      } else {
       ProgressView().tint(.accent)
      }
     } else {
      RoleSelectionView(user: user)
     }
    } else {
     // Fallback: user authenticated but data not loaded yet
     ProgressView().tint(.accent)
    }
   }
  }
  .environment(container.appStateManager)
  .environment(container.userCache)
  .task {
   // Initialize app coordinator on first load
   if appCoordinator == nil, let user = container.authManager.currentUser {
    let coordinator = AppCoordinator(
     authManager: container.authManager,
     userCache: container.userCache
    )
    appCoordinator = coordinator
    coordinator.setupCoordinator(for: user)
   }
  }
  .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("openChat"))) { notification in
   // Handle notification tap - navigate to chat
   if let conversationId = notification.object as? String {
    appCoordinator?.handleChatDeepLink(conversationId: conversationId, conversationsStore: container.conversationsStore)
    print("🔔 Navigating to conversation: \(conversationId)")
   }
  }
  .onChange(of: container.authManager.currentUser) { oldUser, newUser in
   // When user changes (login or role switch), setup coordinator
   if let user = newUser {
    if appCoordinator == nil {
     // First login - create coordinator
     let coordinator = AppCoordinator(
      authManager: container.authManager,
      userCache: container.userCache
     )
     appCoordinator = coordinator
    }
    // Setup/update coordinator for current user role
    appCoordinator?.setupCoordinator(for: user)
   }
  }
 }

 @ViewBuilder
 private func authenticatedContent(for user: User) -> some View {
  if user.isJobSeeker {
   NeedJobView()
    .environment(reviewsStore)
    .environment(walletStore)
    .environment(container.authManager)
    .environment(container.applicationsStore)
    .environment(container.servicesStore)
    .environment(container.messagesStore)
    .environment(container.conversationsStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     walletStore.setupListeners(userId: user.id)
    }
  } else if user.isServiceProvider {
   NeedWork()
    .environment(reviewsStore)
    .environment(walletStore)
    .environment(container.authManager)
    .environment(container.applicationsStore)
    .environment(container.servicesStore)
    .environment(container.messagesStore)
    .environment(container.conversationsStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     walletStore.setupListeners(userId: user.id)
    }
  }
 }
}

#Preview {
 MainView()
  .environment(AppContainer())
}
