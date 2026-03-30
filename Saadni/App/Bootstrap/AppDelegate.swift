//
//  AppDelegate.swift
//  Saadni
//
//  Created by Pavly Paules on 18/03/2026.
//

import UserNotifications
import FirebaseMessaging
import FirebaseFirestore
import FirebaseAuth
import UIKit



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

  guard let userId = Auth.auth().currentUser?.uid else {
   print("⚠️ Cannot save FCM token: user not authenticated")
   return
  }

  Task {
   let tokenData: [String: Any] = [
    "token": fcmToken,
    "platform": "ios",
    "deviceModel": UIDevice.current.model,
    "osVersion": UIDevice.current.systemVersion,
    "registeredAt": Timestamp(date: Date()),
    "isActive": true
   ]
   do {
    try await Firestore.firestore()
     .collection("users")
     .document(userId)
     .collection("fcmTokens")
     .document(fcmToken)
     .setData(tokenData, merge: true)
    print("✅ FCM token saved to users/\(userId)/fcmTokens/")
   } catch {
    print("❌ Failed to save FCM token: \(error)")
   }
  }
 }
}

