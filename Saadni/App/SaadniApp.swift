//
//  SaadniApp.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Kingfisher


@main
struct SaadniApp: App {

 @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 @State private var container: AppContainer
 @AppStorage("appLanguage") private var appLanguage = "en"

 init() {
  // Configure Firebase FIRST before any Firebase-dependent code
  FirebaseApp.configure()

  // Configure Kingfisher image cache
  let cache = ImageCache.default
  cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024  // 100 MB memory
  cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024         // 500 MB disk
  cache.diskStorage.config.expiration = .days(7)                 // 7 days expiration

  // Initialize container after Firebase is configured
  _container = State(initialValue: AppContainer())
 }

 var body: some Scene {
  WindowGroup {
   MainView()
    .environment(container)
    .environment(\.notificationsStore, container.notificationsStore)
    .environment(\.locale, Locale(identifier: appLanguage))
    .environment(\.layoutDirection, appLanguage == "ar" ? .rightToLeft : .leftToRight)
    .onAppear {
     // Request push notification permissions
     setupPushNotifications()
    }
    .onChange(of: container.authManager.currentUserId) { oldValue, newValue in
     if let userId = newValue {
      // Fetch initial services page when user authenticates
      Task { await container.servicesStore.fetchServicesPage(reset: true) }

      Task {
       do {
        // Setup applications listener (async)
        try await container.applicationsStore.setupListeners(userId: userId)
        // Setup conversations listener
        container.conversationsStore.setupListeners(userId: userId)
        // Setup notifications listener
        await container.notificationsStore.setupListeners(userId: userId)
       } catch {
        container.errorHandler.handle(error)
        print("⚠️ Failed to setup listeners on user change: \(error)")
       }
      }
      NotificationService.shared.setCurrentUser(userId)
      // FCM token registration handled by AppDelegate.messaging(_:didReceiveRegistrationToken:)
     } else {
      container.applicationsStore.removeAllListeners()
      container.conversationsStore.stopListening()
     }
    }
  }
 }

 private func setupPushNotifications() {
  // Set the notification delegate to handle notifications while app is foreground
  UNUserNotificationCenter.current().delegate = delegate

  // Firebase Cloud Messaging delegate
  Messaging.messaging().delegate = delegate

  // Request user permission for notifications
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
   if granted {
    DispatchQueue.main.async {
     UIApplication.shared.registerForRemoteNotifications()
    }
    print("✅ Push notification permission granted")
   } else if let error = error {
    print("❌ Push notification permission error: \(error.localizedDescription)")
   }
  }
 }
}
