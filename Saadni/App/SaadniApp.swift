//
//  SaadniApp.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import FirebaseCore


@main
struct SaadniApp: App {

 @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 @State private var userCache = UserCache()
 @State private var authManager: AuthenticationManager
 @State private var servicesStore = ServicesStore()
 @State private var applicationsStore = ApplicationsStore()
 @State private var appStateManager = AppStateManager()

 init() {
  // Configure Firebase FIRST before any Firebase-dependent code
  FirebaseApp.configure()

  let cache = UserCache()
  _userCache = State(initialValue: cache)
  _authManager = State(initialValue: AuthenticationManager(userCache: cache))
 }
 
 var body: some Scene {
  WindowGroup {
   MainView()
    .environment(userCache)
    .environment(authManager)
    .environment(servicesStore)
    .environment(applicationsStore)
    .environment(appStateManager)
    .onAppear {
     // Start listening to services after Firebase is initialized
     servicesStore.startListening()
    }
    .onChange(of: authManager.currentUserId) { oldValue, newValue in
     if let userId = newValue {
      applicationsStore.setupListeners(userId: userId)
     } else {
      applicationsStore.stopListening()
     }
    }
  }
 }
}


class AppDelegate: NSObject, UIApplicationDelegate {
 // Firebase is configured in SaadniApp.init() before AuthenticationManager creation
 // This empty delegate is kept for future lifecycle hooks if needed
}

