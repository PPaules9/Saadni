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
 @State private var servicesStore = ServicesStore()
 @State private var authManager = AuthenticationManager()
 @State private var applicationsStore = ApplicationsStore()

 var body: some Scene {
  WindowGroup {
   MainView()
    .environment(servicesStore)
    .environment(authManager)
    .environment(applicationsStore)
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
 func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  FirebaseApp.configure()
  return true
 }
}
