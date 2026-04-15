//
//  AuthenticationManager.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseAuth


enum AuthenticationState {
 case unauthenticated
 case authenticating
 case authenticated(User)
}


@Observable
class AuthenticationManager: AuthProvider {
 var authState: AuthenticationState = .authenticating
 var errorMessage: String?

 private var authStateHandle: AuthStateDidChangeListenerHandle?
 private let userCache: UserCache
 private let appStateManager: AppStateManager
 @ObservationIgnored private var isAuthFlowActive = false

 var isAuthenticated: Bool {
  if case .authenticated = authState {
   return true
  }
  return false
 }

 var currentUser: User? {
  return userCache.currentUser
 }

 var currentUserId: String? {
  return currentUser?.id
 }

 // MARK: - Initialization
 init(userCache: UserCache, appStateManager: AppStateManager? = nil) {
  self.userCache = userCache
  self.appStateManager = appStateManager ?? AppStateManager()
  registerAuthStateHandler()
 }
 
 deinit {
  if let handle = authStateHandle {
   Auth.auth().removeStateDidChangeListener(handle)
  }
 }
 
 // MARK: - Auth State Listener
 private func registerAuthStateHandler() {
  authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
   guard let self = self else { return }

   if let firebaseUser = firebaseUser {
    // User is signed in - use UserCache to load user data
    Task {
     // Try to load existing user from Firestore
     await self.userCache.loadUser(id: firebaseUser.uid)

     if let cachedUser = self.userCache.currentUser {
      // User exists in Firestore ✅
      await MainActor.run {
       self.authState = .authenticated(cachedUser)
      }
     } else if !self.isAuthFlowActive {
      // New user - create with default values
      let user = User(from: firebaseUser)

      // Optimistic update: cache immediately + save in background
      await self.userCache.updateUser(user)

      // Update auth state
      await MainActor.run {
       self.authState = .authenticated(user)
      }
     }
    }
   } else {
    // User is signed out
    self.userCache.clearCache()
    self.authState = .unauthenticated
   }
  }
 }
 
 // MARK: - Sign In Methods
 
 /// Sign in with email and password
 func signIn(email: String, password: String) async throws {
  isAuthFlowActive = true
  defer { isAuthFlowActive = false }
  errorMessage = nil

  do {
   let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
   
   // Load existing user from Firestore instead of creating new default values
   await userCache.loadUser(id: authResult.user.uid)

   if let existingUser = userCache.currentUser {
    await MainActor.run {
     self.authState = .authenticated(existingUser)
    }
   } else {
    // Fallback if user doesn't exist in Firestore
    let user = User(from: authResult.user)
    await userCache.updateUser(user)
    await MainActor.run {
     self.authState = .authenticated(user)
    }
    await updateUserInFirestore(user)
   }
   AnalyticsService.shared.track(.loggedIn)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }

 /// Create account with email and password
 func signUp(email: String, password: String, fullName: String, role: UserRole? = nil) async throws {
  isAuthFlowActive = true
  defer { isAuthFlowActive = false }
  errorMessage = nil

  do {
   let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

   // Update profile with display name
   let changeRequest = authResult.user.createProfileChangeRequest()
   changeRequest.displayName = fullName
   try await changeRequest.commitChanges()

   // Create user object
   var user = User(from: authResult.user)
   user.displayName = fullName

   // Apply the role chosen during onboarding
   switch role {
   case .jobSeeker:
    user.isJobSeeker = true
   case .provider:
    user.isServiceProvider = true
   case nil:
    break
   }

   // Update cache and auth state
   await userCache.updateUser(user)
   await MainActor.run {
    self.authState = .authenticated(user)
   }

   // Save to Firestore
   await updateUserInFirestore(user)
   AnalyticsService.shared.track(.signedUp)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }

 /// Sign in anonymously (useful for testing)
 func signInAnonymously() async throws {
  isAuthFlowActive = true
  defer { isAuthFlowActive = false }
  errorMessage = nil

  do {
   let authResult = try await Auth.auth().signInAnonymously()
   
   // Load existing anonymous user instead of creating new default values
   await userCache.loadUser(id: authResult.user.uid)

   if let existingUser = userCache.currentUser {
    await MainActor.run {
     self.authState = .authenticated(existingUser)
    }
   } else {
    let user = User(from: authResult.user)
    await userCache.updateUser(user)
    await MainActor.run {
     self.authState = .authenticated(user)
    }
    await updateUserInFirestore(user)
   }
   AnalyticsService.shared.track(.guestSignIn)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }

 /// Sign out
 func signOut() throws {
  AnalyticsService.shared.track(.loggedOut)
  AnalyticsService.shared.reset()
  userCache.clearCache()
  try Auth.auth().signOut()
  authState = .unauthenticated

  // Reset onboarding flag so next user sees fresh flow
  // Role selection state will come from the new User object
  Task {
   try await appStateManager.resetForNextUser()
   print("✅ User signed out and onboarding reset")
  }
 }
 
 /// Delete account — requires the user's current password for re-authentication.
 /// Firebase mandates recent auth before a destructive account operation.
 func deleteAccount(password: String) async throws {
  guard let firebaseUser = Auth.auth().currentUser,
        let email = firebaseUser.email else {
   throw NSError(domain: "AuthError", code: -1,
                 userInfo: [NSLocalizedDescriptionKey: "No current user to delete."])
  }

  // 1. Re-authenticate so Firebase accepts the deletion
  let credential = EmailAuthProvider.credential(withEmail: email, password: password)
  try await firebaseUser.reauthenticate(with: credential)

  let uid = firebaseUser.uid

  // 2. Wipe all Firestore data
  try await FirestoreService.shared.deleteUserData(userId: uid)

  // 3. Delete the Firebase Auth account
  try await firebaseUser.delete()

  // 4. Clear local cache and go back to unauthenticated
  self.userCache.clearCache()
  await MainActor.run {
   self.authState = .unauthenticated
  }

  // 5. Reset onboarding so the next user sees a fresh flow
  try await appStateManager.resetForNextUser()
  print("✅ Account completely deleted and onboarding reset")
 }
 
 // MARK: - Firestore Integration
 private func updateUserInFirestore(_ user: User) async {
  do {
   try await FirestoreService.shared.saveUser(user)
   print("✅ User \(user.id) saved to Firestore")
  } catch {
   // Log error for debugging but don't fail auth - user is cached
   let appError = AppError.from(error)
   print("⚠️ Failed to save user to Firestore (will retry later): \(appError.errorDescription ?? "")")
   // In background, attempt retry after delay
   Task {
    try? await Task.sleep(for: .seconds(5))
    try? await FirestoreService.shared.saveUser(user)
   }
  }
 }
}
