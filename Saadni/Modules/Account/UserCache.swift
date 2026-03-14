//
//  UserCache.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation

@Observable
final class UserCache {
 var currentUser: User?
 private var isLoadingUser = false
 private var currentlyLoadingUserId: String?
 private var loadingContinuations: [String: [CheckedContinuation<Void, Never>]] = [:]

 // Real-time listener
 private var userListenerHandle: NSObjectProtocol?

 // MARK: - Cache Lifecycle

 /// Load user from cache or Firestore
 /// Smart deduplication: Multiple concurrent calls return single fetch
 func loadUser(id: String) async {
  // If user already cached, return immediately
  if let cached = currentUser, cached.id == id {
   return
  }

  // If already loading this user, wait for result via continuation
  if isLoadingUser && currentlyLoadingUserId == id {
   await withCheckedContinuation { continuation in
    if loadingContinuations[id] == nil {
     loadingContinuations[id] = []
    }
    loadingContinuations[id]?.append(continuation)
   }
   return
  }

  // Fetch user from Firestore
  isLoadingUser = true
  currentlyLoadingUserId = id

  do {
   if let user = try await FirestoreService.shared.fetchUser(id: id) {
    await MainActor.run {
     self.currentUser = user
    }
    print("✅ User \(id) loaded from Firestore")
   } else {
    print("ℹ️ User \(id) doesn't exist in Firestore yet (new user)")
    // Don't set currentUser - let caller decide how to handle new user
   }
  } catch {
   print("⚠️ Failed to load user from Firestore: \(error.localizedDescription)")
   // Don't throw - let caller decide how to handle errors
  }

  isLoadingUser = false
  currentlyLoadingUserId = nil

  // Resume all waiting continuations
  if let continuations = loadingContinuations.removeValue(forKey: id) {
   continuations.forEach { $0.resume() }
  }
 }
 
 /// Optimistic update: Update cache immediately, sync to Firestore in background
 /// Ensures instant UI feedback while maintaining data consistency
 func updateUser(_ user: User) async {
  // 1. Optimistic update - instant UI response
  await MainActor.run {
   self.currentUser = user
  }
  
  // 2. Sync to Firestore in background (fire and forget)
  Task {
   do {
    try await FirestoreService.shared.saveUser(user)
    print("✅ User \(user.id) synced to Firestore")
   } catch {
    print("❌ Failed to sync user: \(error.localizedDescription)")
    // Could add retry logic here in production
   }
  }
 }
 
 /// Force refresh user data from Firestore (bypass cache)
 /// Useful for explicit refresh after network issues or multi-device changes
 func refreshUser() async {
  guard let userId = currentUser?.id else { return }
  
  do {
   if let freshUser = try await FirestoreService.shared.fetchUser(id: userId) {
    await MainActor.run {
     self.currentUser = freshUser
    }
    print("✅ User \(userId) refreshed from Firestore")
   }
  } catch {
   print("❌ Failed to refresh user: \(error.localizedDescription)")
  }
 }
 
 /// Clear cache completely (e.g., on sign out)
 func clearCache() {
  currentUser = nil
  isLoadingUser = false
  currentlyLoadingUserId = nil
  stopListening()
  print("🧹 User cache cleared")
 }
 
 // MARK: - Real-time Listening (Optional - for multi-device sync)
 
 /// Start listening for real-time user profile changes
 /// Useful if user can edit profile on web while using mobile app
 /// Keep this disabled by default (fire-and-forget is cheaper)
 func startListening(userId: String) {
  // Real-time listening placeholder for future enhancement
  // Currently disabled to keep MVP simple and reduce Firebase listener costs
  print("ℹ️ Real-time user sync available in future releases. Use refreshUser() for manual updates.")
 }
 
 /// Stop listening for real-time changes
 func stopListening() {
  if userListenerHandle != nil {
   userListenerHandle = nil
   print("🔇 Stopped real-time user listener")
  }
 }
 
 // MARK: - User Lookup

 /// Fetch a user by ID (for displaying other participants in chat, etc)
 /// Returns cached user if available, otherwise returns nil
 func getUserById(_ userId: String) -> User? {
  // If it's the current user, return it
  if currentUser?.id == userId {
   return currentUser
  }

  // For other users, would need a separate cache
  // For now, return nil and let caller fall back to default name
  return nil
 }

 deinit {
  stopListening()
 }
}


