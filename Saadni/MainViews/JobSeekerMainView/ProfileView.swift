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
   do {
    // Create updated user with switched role
    var updatedUser = currentUser
    updatedUser.isJobSeeker = !updatedUser.isJobSeeker
    updatedUser.isServiceProvider = !updatedUser.isServiceProvider

    // Save to Firestore
    try await FirestoreService.shared.saveUser(updatedUser)

    // Update local auth state
    await MainActor.run {
     authManager.authState = .authenticated(updatedUser)
     isSwitching = false
    }
   } catch {
    await MainActor.run {
     errorMessage = error.localizedDescription
     showError = true
     isSwitching = false
    }
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
  .environment(AuthenticationManager())
}
