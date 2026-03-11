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
  } else if user.isServiceProvider {
   NeedHelpView()
  } else {
   NeedJobView()
  }
 }
}

#Preview {
 MainView()
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(AppStateManager())
}
