//
//  ProfileView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
 @State private var isAnimating = false
 @State private var showError = false
 @State private var errorMessage = ""
 @State private var isSwitching = false
 @Environment(AppStateManager.self) var appStateManager
 @Environment(AuthenticationManager.self) var authManager
 @Environment(UserCache.self) var userCache

 var body: some View {
  ZStack{
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()

   NavigationStack {
    ScrollView {
     VStack(alignment: .leading, spacing: 24) {
      // User Profile Banner
      VStack(spacing: 12) {
       HStack(spacing: 16) {
        // Profile Image
        Circle()
         .fill(Color.accent.opacity(0.2))
         .frame(width: 70, height: 70)
         .overlay(
          Image(systemName: "person.fill")
           .font(.system(size: 28))
           .foregroundStyle(.accent)
         )

        VStack(alignment: .leading, spacing: 6) {
         Text("Pavly Paules")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundStyle(.primary)

         Text("pavly@example.com")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        }

        Spacer()
       }
       .padding(16)
       .background(Color.gray.opacity(0.08))
       .cornerRadius(28)
      }
      .padding(.horizontal, 20)
      .padding(.top, 16)

      // Your Services (Empty State)
      VStack(alignment: .leading, spacing: 10) {
       HStack {
        Text("My Services")
         .font(.title2)
         .fontWeight(.semibold)
         .foregroundStyle(.accent)
        Spacer()

        Image(systemName: "chevron.right")
         .foregroundStyle(Colors.swiftUIColor(.textSecondary))
       }
       .padding(.horizontal, 20)
       // Empty State Content
       VStack(alignment: .leading, spacing: 5) {
        Text("You haven't created any service yet.")
        HStack(spacing: 0) {
         Text("Create one by clicking on the ")
         Text("Add Service")
          .foregroundStyle(.accent)
        }
         Text("button above.")
       }
       .font(.body)
       .foregroundStyle(.gray)
       .padding(.top, 5)
       .padding(.horizontal, 20)
      }
      .padding(.vertical)

      // My Account Section
      VStack(alignment: .leading, spacing: 12) {
       Text("My Account")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .padding(.horizontal, 20)

       VStack(spacing: 0) {
        ProfileMenuRow(
         icon: "person.fill",
         title: "Edit Personal Details",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "globe",
         title: "Change The Language",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "dollarsign.circle.fill",
         title: "Change The Currency",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "door.left.hand.open",
         title: "Log Out",
         action: {
          Task {
           do {
            try authManager.signOut()
            try await appStateManager.resetOnboarding()
            try await appStateManager.resetRoleSelection()
           } catch {
            print("Logout error: \(error)")
           }
          }
         }
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "trash.fill",
         title: "Delete Account",
         action: {},
         isDestructive: true
        )
       }
       .background(Color.gray.opacity(0.08))
       .cornerRadius(12)
       .padding(.horizontal, 20)
      }

      // Help and Support Section
      VStack(alignment: .leading, spacing: 12) {
       Text("Help and Support")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .padding(.horizontal, 20)

       VStack(spacing: 0) {
        ProfileMenuRow(
         icon: "questionmark.circle.fill",
         title: "Help and Support",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "info.circle.fill",
         title: "About",
         action: {}
        )
       }
       .background(Color.gray.opacity(0.08))
       .cornerRadius(12)
       .padding(.horizontal, 20)
      }

      // User Type Section
      VStack(alignment: .leading, spacing: 12) {
       Text("User Type")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .padding(.horizontal, 20)

       Button(action: switchUserType) {
        HStack(spacing: 12) {
         Image(systemName: currentUserTypeIcon)
          .font(.system(size: 20, weight: .semibold))
          .foregroundStyle(.accent)
          .frame(width: 24)
          .scaleEffect(isAnimating ? 1.2 : 1.0)
          .rotationEffect(.degrees(isAnimating ? 360 : 0))

         VStack(alignment: .leading, spacing: 4) {
          Text("Current Role")
           .font(.subheadline)
           .foregroundStyle(Colors.swiftUIColor(.textSecondary))

          Text(currentUserTypeLabel)
           .font(.headline)
           .fontWeight(.semibold)
           .foregroundStyle(Colors.swiftUIColor(.textMain))
         }

         Spacer()

         Image(systemName: "arrow.left.arrow.right")
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(.accent)
          .scaleEffect(isAnimating ? 0.8 : 1.0)
        }
        .padding(16)
        .background(
         RoundedRectangle(cornerRadius: 15)
          .fill(Colors.swiftUIColor(.appBackground))
        )
        .overlay(
         RoundedRectangle(cornerRadius: 15)
          .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.2), lineWidth: 1)
        )
       }
       .disabled(isSwitching)
       .opacity(isSwitching ? 0.6 : 1.0)
       .padding(.horizontal, 20)
      }

      Spacer()
        .frame(height: 20)
     }
    }
    .scrollIndicators(.hidden)
    .navigationTitle("Profile")
    .alert("Error", isPresented: $showError) {
     Button("OK", role: .cancel) {}
    } message: {
     Text(errorMessage)
    }
   }
  }
 }

 // MARK: - Computed Properties
 var currentUserTypeLabel: String {
  if let user = authManager.currentUser {
   if user.isJobSeeker {
    return "Job Seeker"
   } else if user.isServiceProvider {
    return "Service Provider"
   }
  }
  return "Unknown"
 }

 var currentUserTypeIcon: String {
  if let user = authManager.currentUser {
   if user.isJobSeeker {
    return "magnifyingglass.circle.fill"
   } else if user.isServiceProvider {
    return "briefcase.circle.fill"
   }
  }
  return "questionmark.circle"
 }

 // MARK: - Methods
 func switchUserType() {
  guard let currentUser = authManager.currentUser else { return }

  isSwitching = true

  // Trigger animation
  withAnimation(.easeInOut(duration: 0.6)) {
   isAnimating = true
  }

  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
   isAnimating = false
  }

  Task {
   // Create updated user with switched role
   var updatedUser = currentUser
   updatedUser.isJobSeeker = !updatedUser.isJobSeeker
   updatedUser.isServiceProvider = !updatedUser.isServiceProvider

   // Use UserCache for optimistic update + Firestore sync
   await userCache.updateUser(updatedUser)

   // Update UI state
   await MainActor.run {
    isSwitching = false
   }
  }
 }
}

// MARK: - Profile Menu Row
struct ProfileMenuRow: View {
 let icon: String
 let title: String
 let action: () -> Void
 var isDestructive: Bool = false

 var body: some View {
  Button(action: action) {
   HStack(spacing: 12) {
    Image(systemName: icon)
     .font(.system(size: 16, weight: .semibold))
     .foregroundStyle(isDestructive ? .red : .accent)
     .frame(width: 24)

    Text(title)
     .font(.subheadline)
     .fontWeight(.medium)
     .foregroundStyle(isDestructive ? .red : .primary)

    Spacer()

    Image(systemName: "chevron.right")
     .font(.system(size: 14, weight: .semibold))
     .foregroundStyle(.gray)
   }
   .padding(.horizontal, 16)
   .padding(.vertical, 12)
  }
 }
}

#Preview {
 ProfileView()
  .environment(AppStateManager())
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
}

/* Developer Note
-- Purpose: ProfileView displays the current user's profile and allows them to switch between
            Job Seeker and Service Provider roles. Modified to use UserCache for role switching.

-- Changes: Updated to integrate UserCache
            1. Added @Environment(UserCache.self) var userCache
            2. Updated switchUserType() to use userCache.updateUser() instead of manual Firestore save + authState update
            3. Optimistic UI: User sees role change instantly (cache updates immediately)
            4. Background sync: Firestore save happens asynchronously in updateUser()
            5. Updated #Preview to include UserCache environment

-- Dependencies:
   - UserCache: For optimistic role updates
   - AuthenticationManager: For current user data
   - AppStateManager: For app flow state
   - FirestoreService: Indirectly (via UserCache)

-- Impact:
   1. Role switching is now instantaneous from user perspective (optimistic UI)
   2. Firestore sync happens in background, reducing perceived latency
   3. Single cache update point ensures all views get new role immediately
   4. Better error handling potential (could add retry logic in UserCache)

-- Before UserCache:
   switchUserType() → Save to Firestore → Update authManager.authState → UI updates
   (Sequential: Firestore latency blocks UI update)

-- After UserCache:
   switchUserType() → Update cache (instant) → UI updates → Firestore sync (background)
   (Parallel: UI responds immediately, sync happens in background)

-- User Flow:
   1. User taps "Switch Role" button
   2. Animation starts, switchUserType() called
   3. Updated user created with flipped roles
   4. userCache.updateUser() called:
      - Cache updated immediately (currentUser changes, triggers view refresh)
      - Firestore save queued in background Task
   5. User sees role change instantly
   6. Firestore silently syncs in background
*/

