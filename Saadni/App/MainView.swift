//
//  MainView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct MainView: View {
 @Environment(AuthenticationManager.self) var authManager
 @Environment(AppStateManager.self) var appStateManager
 @Environment(UserCache.self) var userCache
 @Environment(MessagesStore.self) var messagesStore
 @Environment(ConversationsStore.self) var conversationsStore
 @State private var reviewsStore = ReviewsStore()
 // @State private var walletStore = WalletStore() // TODO: Fix WalletStore not in pbxproj
 @State private var appCoordinator: AppCoordinator?

 var body: some View {
  Group {
   switch authManager.authState {
   case .authenticating:
    ProgressView().tint(.accent)
   case .unauthenticated:
    if appStateManager.hasSeenOnboarding {
     AuthenticationView()
    } else {
     OnboardingView()
    }
   case .authenticated:
    // Read live user from currentUser (delegates to userCache)
    if let user = authManager.currentUser {
     if appStateManager.hasSelectedRole {
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
  .task {
   // Initialize coordinator on first load
   if appCoordinator == nil, let user = authManager.currentUser {
    let coordinator = AppCoordinator(
     authManager: authManager,
     userCache: userCache
    )
    appCoordinator = coordinator
    coordinator.setupCoordinator(for: user)
   }
  }
  .onChange(of: authManager.currentUser) { oldUser, newUser in
   // When user changes (login or role switch), setup coordinator
   if let user = newUser {
    if appCoordinator == nil {
     // First login - create coordinator
     let coordinator = AppCoordinator(
      authManager: authManager,
      userCache: userCache
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
    // .environment(walletStore) // TODO: Fix WalletStore
    .environment(messagesStore)
    .environment(conversationsStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     // walletStore.setupListeners(userId: user.id) // TODO: Fix WalletStore
    }
  } else if user.isServiceProvider {
   NeedWork()
    .environment(reviewsStore)
    // .environment(walletStore) // TODO: Fix WalletStore
    .environment(messagesStore)
    .environment(conversationsStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     // walletStore.setupListeners(userId: user.id) // TODO: Fix WalletStore
    }
  }
 }
}

#Preview {
 MainView()
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(AppStateManager())
  .environment(ReviewsStore())
  // .environment(WalletStore()) // TODO: Fix WalletStore
}
