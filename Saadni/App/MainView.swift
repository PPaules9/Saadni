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
 @State private var reviewsStore = ReviewsStore()
 @State private var walletStore = WalletStore()

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
   case .authenticated(let user):
    if appStateManager.hasSelectedRole {
     authenticatedContent(for: user)
    } else {
     RoleSelectionView()
    }
   }
  }
 }
 
 @ViewBuilder
 private func authenticatedContent(for user: User) -> some View {
  if user.isJobSeeker {
   NeedJobView()
    .environment(reviewsStore)
    .environment(walletStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     walletStore.setupListeners(userId: user.id)
    }
  } else if user.isServiceProvider {
   NeedWork()
    .environment(reviewsStore)
    .environment(walletStore)
    .onAppear {
     reviewsStore.setupListeners(userId: user.id)
     walletStore.setupListeners(userId: user.id)
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
  .environment(WalletStore())
}
