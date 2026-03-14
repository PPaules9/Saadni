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
    .onAppear {
     // Start listening to services after Firebase is initialized
     container.servicesStore.startListening()

     // Request push notification permissions
     setupPushNotifications()
    }
    .onChange(of: container.authManager.currentUserId) { oldValue, newValue in
     if let userId = newValue {
      Task {
       do {
        // Setup applications listener (async)
        try await container.applicationsStore.setupListeners(userId: userId)
        // Setup conversations listener
        container.conversationsStore.setupListeners(userId: userId)
       } catch {
        container.errorHandler.handle(error)
        print("⚠️ Failed to setup listeners on user change: \(error)")
       }
      }
      NotificationService.shared.setCurrentUser(userId)
      // FCM token registration handled by AppDelegate.messaging(_:didReceiveRegistrationToken:)
     } else {
      container.applicationsStore.stopListening()
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


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

 // Handle notification while app is in foreground
 func userNotificationCenter(
  _ center: UNUserNotificationCenter,
  willPresent notification: UNNotification,
  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
 ) {
  let userInfo = notification.request.content.userInfo

  // Extract message data if available
  if let senderName = userInfo["senderName"] as? String {
   print("📨 Received notification from: \(senderName)")
  }

  // Show notification even while app is open
  completionHandler([.banner, .sound, .badge])
 }

 // Handle notification tap
 func userNotificationCenter(
  _ center: UNUserNotificationCenter,
  didReceive response: UNNotificationResponse,
  withCompletionHandler completionHandler: @escaping () -> Void
 ) {
  let userInfo = response.notification.request.content.userInfo

  if let conversationId = userInfo["conversationId"] as? String {
   print("👆 User tapped notification for conversation: \(conversationId)")
   // TODO: Navigate to the chat (will implement in ChatDetailView)
   NotificationCenter.default.post(name: NSNotification.Name("openChat"), object: conversationId)
  }

  completionHandler()
 }

 // Handle device token registration
 func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
 ) -> Bool {
  return true
 }

 func application(
  _ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
 ) {
  Messaging.messaging().apnsToken = deviceToken
  print("✅ Device token registered with FCM")
 }

 func application(
  _ application: UIApplication,
  didFailToRegisterForRemoteNotificationsWithError error: Error
 ) {
  print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
 }

 // Firebase Cloud Messaging token refresh
 func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
  guard let fcmToken = fcmToken else { return }
  print("🔑 FCM Token: \(fcmToken)")

  // Save token to Firestore if user is authenticated
  if let userId = NotificationService.shared.getCurrentUserId() {
   Task {
    do {
     try await NotificationService.shared.registerDeviceToken(fcmToken, for: userId)
     print("✅ FCM token registered successfully")
    } catch {
     print("❌ Failed to register FCM token: \(error)")
     // Note: This is in AppDelegate, not in a view, so we can't use errorHandler
     // Error is logged for developer debugging
    }
   }
  }
 }
}

