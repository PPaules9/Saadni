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
     .onAppear {
      print("🔄 [MainView] authState = .authenticating")
     }

   case .unauthenticated:
    if container.appStateManager.hasSeenOnboarding {
     AuthenticationView()
    } else {
     OnboardingView()
    }

   case .authenticated:
    if let user = container.authManager.currentUser {
     // Source of truth: User object (not flags)
     // Check if user has selected a role
     let hasSelectedRole = user.isJobSeeker || user.isServiceProvider

     if hasSelectedRole {
      if let appCoordinator = appCoordinator {
       authenticatedContent(for: user)
        .environment(appCoordinator)
      } else {
       ProgressView().tint(.accent)
      }
     } else {
      // User is authenticated but hasn't selected a role yet
      RoleSelectionView(user: user)
     }
    } else {
     // Authenticated but user data not loaded yet
     ProgressView().tint(.accent)
    }
   }
  }
  .environment(container.appStateManager)
  .environment(container.userCache)
  .environment(container.authManager)
  .environment(container.errorHandler)
  .alert("Error", isPresented: $container.errorHandler.isPresented) {
   Button("Dismiss") {
    container.errorHandler.dismiss()
   }
   if container.errorHandler.retryAction != nil {
    Button("Retry") {
     container.errorHandler.retry()
    }
   }
  } message: {
   if let error = container.errorHandler.currentError {
    VStack(alignment: .leading, spacing: 8) {
     Text(error.errorDescription ?? "Unknown error")
      .font(.body)
     if let suggestion = error.recoverySuggestion {
      Text(suggestion)
       .font(.caption)
       .foregroundStyle(.secondary)
     }
    }
   }
  }
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
    .task {
     await setupDataListeners(userId: user.id)
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
    .task {
     await setupDataListeners(userId: user.id)
    }
  }
 }

 /// Sets up all real-time data listeners concurrently using TaskGroup
 /// - Parameter userId: The user ID to set up listeners for
 /// - Note: Uses modern Swift Concurrency with TaskGroup for efficient concurrent setup
 ///         All listeners start at approximately the same time, reducing perceived load time
 private func setupDataListeners(userId: String) async {
  let startTime = Date()
  print("🚀 [MainView] Starting concurrent listener setup for user: \(userId)")

  await withTaskGroup(of: (String, Error?).self) { group in
   // Task 1: Reviews listener
   group.addTask {
    do {
     try await self.reviewsStore.setupListeners(userId: userId)
     return ("ReviewsStore", nil)
    } catch {
     return ("ReviewsStore", error)
    }
   }

   // Task 2: Wallet listener
   group.addTask {
    do {
     try await self.walletStore.setupListeners(userId: userId)
     return ("WalletStore", nil)
    } catch {
     return ("WalletStore", error)
    }
   }

   // Task 3: Applications listeners
   group.addTask {
    do {
     try await self.container.applicationsStore.setupListeners(userId: userId)
     return ("ApplicationsStore", nil)
    } catch {
     return ("ApplicationsStore", error)
    }
   }

   // Collect all results
   var allSucceeded = true
   for await (storeName, error) in group {
    if let error = error {
     print("❌ \(storeName) listener setup failed: \(error)")
     allSucceeded = false
    } else {
     print("✅ \(storeName) listener setup succeeded")
    }
   }

   let duration = Date().timeIntervalSince(startTime)
   if allSucceeded {
    print("✨ All listeners ready in \(String(format: "%.2f", duration))s")
   } else {
    print("⚠️ Some listeners failed to setup (check errors above)")
   }
  }
 }
}

#Preview {
 MainView()
  .environment(AppContainer())
}
