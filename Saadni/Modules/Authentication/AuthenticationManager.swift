//
//  AuthenticationManager.swift
//  Saadni
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
     } else {
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
  authState = .authenticating
  errorMessage = nil

  do {
   let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
   let user = User(from: authResult.user)

   // Update cache and auth state
   await userCache.updateUser(user)
   await MainActor.run {
    self.authState = .authenticated(user)
   }

   // Ensure user exists in Firestore
   await updateUserInFirestore(user)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }
 
 /// Create account with email and password
 func signUp(email: String, password: String, fullName: String) async throws {
  authState = .authenticating
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

   // Update cache and auth state
   await userCache.updateUser(user)
   await MainActor.run {
    self.authState = .authenticated(user)
   }

   // Save to Firestore
   await updateUserInFirestore(user)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }
 
 /// Sign in anonymously (useful for testing)
 func signInAnonymously() async throws {
  authState = .authenticating
  errorMessage = nil

  do {
   let authResult = try await Auth.auth().signInAnonymously()
   let user = User(from: authResult.user)

   // Update cache and auth state
   await userCache.updateUser(user)
   await MainActor.run {
    self.authState = .authenticated(user)
   }

   await updateUserInFirestore(user)
  } catch {
   authState = .unauthenticated
   errorMessage = error.localizedDescription
   throw error
  }
 }
 
 /// Sign out
 func signOut() throws {
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
 
 // MARK: - Firestore Integration
 private func updateUserInFirestore(_ user: User) async {
  do {
   try await FirestoreService.shared.saveUser(user)
   print("✅ User \(user.id) saved to Firestore")
  } catch {
   print("❌ Failed to save user to Firestore: \(error.localizedDescription)")
  }
 }
}

