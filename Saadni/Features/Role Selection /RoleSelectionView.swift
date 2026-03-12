//
//  RoleSelectionView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct RoleSelectionView: View {
 @Environment(AuthenticationManager.self) var authManager
 @Environment(AppStateManager.self) var appStateManager
 @Environment(UserCache.self) var userCache
 @State private var isUpdating = false
 @State private var showError = false
 @State private var errorMessage = ""
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   VStack(spacing: 24) {
    // Header section
    VStack(spacing: 12) {
     Image(systemName: "person.crop.circle.badge.questionmark")
      .font(.system(size: 60))
      .foregroundStyle(.accent)
     
     Text("What brings you here?")
      .font(.title)
      .fontWeight(.bold)
      .foregroundStyle(Colors.swiftUIColor(.textMain))
     
     Text("Choose how you want to use Saadni")
      .font(.subheadline)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .multilineTextAlignment(.center)
    }
    .padding(.top, 60)
    
    Spacer()
    
    // Role options
    VStack(spacing: 16) {
     RoleOptionCard(
      icon: "magnifyingglass.circle.fill",
      title: "Need help with something",
      iconColor: .accent
     ) {
      selectRole(isJobSeeker: true)
     }
     
     RoleOptionCard(
      icon: "briefcase.circle.fill",
      title: "Need work and earn some cash",
      iconColor: .accent
     ) {
      selectRole(isJobSeeker: false)
     }
    }
    
    Spacer()
   }
   .padding(24)
   .disabled(isUpdating)
   
   if isUpdating {
    ProgressView()
     .scaleEffect(1.5)
     .tint(.accent)
   }
  }
  .alert("Error", isPresented: $showError) {
   Button("OK", role: .cancel) {}
  } message: {
   Text(errorMessage)
  }
 }
 
 private func selectRole(isJobSeeker: Bool) {
  guard let currentUser = authManager.currentUser else {
   errorMessage = "No user found. Please log in again."
   showError = true
   return
  }

  isUpdating = true

  Task {
   do {
    // Create updated user with role selection
    var updatedUser = currentUser
    updatedUser.isJobSeeker = isJobSeeker
    updatedUser.isServiceProvider = !isJobSeeker

    // Use UserCache for optimistic update + Firestore sync
    await userCache.updateUser(updatedUser)

    // Complete role selection (persists UI state)
    try await appStateManager.completeRoleSelection()

    // Update UI state on main thread
    await MainActor.run {
     isUpdating = false
    }
   } catch {
    await MainActor.run {
     errorMessage = error.localizedDescription
     showError = true
     isUpdating = false
    }
   }
  }
 }
}


#Preview {
 RoleSelectionView()
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(AppStateManager())
}

/* Developer Note
-- Purpose: RoleSelectionView presents the initial role selection choice to new users
            (Job Seeker vs Service Provider). Modified to use UserCache for role updates.

-- Changes: Updated to integrate UserCache
            1. Added @Environment(UserCache.self) var userCache
            2. Updated selectRole() to use userCache.updateUser() instead of manual save + authState update
            3. Optimistic UI: Selected role is cached immediately, UI appears to respond instantly
            4. Background sync: Firestore save and appStateManager update happen asynchronously
            5. Updated #Preview to include UserCache environment

-- Dependencies:
   - UserCache: For optimistic role updates
   - AuthenticationManager: For current user data
   - AppStateManager: For marking role selection as complete
   - FirestoreService: Indirectly (via UserCache)

-- Impact:
   1. Role selection appears instantaneous (optimistic UI via cache)
   2. Firestore and AppStateManager updates happen in background
   3. All views immediately reflect selected role (cache reactivity)
   4. Error handling: If appStateManager.completeRoleSelection() fails, cache still updated
      (could add rollback logic if needed)

-- User Flow:
   1. New user sees role selection screen
   2. Taps "Need help" → selectRole(isJobSeeker: true) called
   3. Updated user created with isJobSeeker=true
   4. userCache.updateUser() called:
      - Cache updated immediately (currentUser changes)
      - Firestore save queued in background
   5. appStateManager.completeRoleSelection() called (persists "role selected" flag)
   6. User navigated to main content (MainView routes based on role)
   7. Firestore silently syncs in background

-- Why This Approach:
   - Optimistic UI makes app feel fast even with network latency
   - UserCache update triggers instant UI refresh (all views see new role)
   - Background tasks don't block user interaction
   - Separation of cache update (instant) from persistence (async)

-- Note: appStateManager.completeRoleSelection() is still awaited because
         it controls navigation routing. UserCache update is independent
         and triggers view updates via @Observable reactivity.
*/

