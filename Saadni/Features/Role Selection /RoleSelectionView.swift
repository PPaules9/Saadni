//
//  RoleSelectionView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct RoleSelectionView: View {
 let user: User
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
  isUpdating = true

  Task {
   do {
    // Create updated user with role selection
    var updatedUser = user
    updatedUser.isJobSeeker = isJobSeeker
    updatedUser.isServiceProvider = !isJobSeeker

    // Save user with selected role
    // Source of truth is now the User object, not AppState flags
    await userCache.updateUser(updatedUser)

    print("✅ Role selected: \(isJobSeeker ? "Job Seeker" : "Service Provider")")
    print("   MainView will automatically show app content because user.isJobSeeker is now set")

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
