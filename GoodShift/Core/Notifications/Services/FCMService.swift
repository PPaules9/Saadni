import Foundation
import FirebaseCore
import UIKit
import FirebaseMessaging
import UserNotifications
import FirebaseAuth
import FirebaseFirestore
// MARK: - FCM Service

final class FCMService: NSObject, MessagingDelegate {
	static let shared = FCMService()
	
	private var currentFCMToken: String?
	
	func setupMessaging() {
		Messaging.messaging().delegate = self
		requestPushNotificationPermission()
	}
	
	func requestPushNotificationPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
			DispatchQueue.main.async {
				if granted {
					UIApplication.shared.registerForRemoteNotifications()
					print("✅ User granted notification permission")
				} else {
					print("⚠️ User denied notification permission")
				}
			}
		}
	}
	
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		guard let token = fcmToken else { return }
		
		currentFCMToken = token
		print("✅ FCM Token received: \(token.prefix(20))...")
		
		// Save token to Firestore
		Task {
			await saveTokenToFirestore(token: token)
		}
	}
	
	/// Public entry point for saving a token — called by AppDelegate so token-saving
	/// logic lives in one place (here) rather than being duplicated across delegates.
	func registerToken(_ token: String) async {
		currentFCMToken = token
		await saveTokenToFirestore(token: token)
	}

	private func saveTokenToFirestore(token: String) async {
		guard let userId = FirebaseAuth.Auth.auth().currentUser?.uid else {
			print("⚠️ Cannot save FCM token: user not authenticated")
			return
		}
		
		let tokenData: [String: Any] = [
			"token": token,
			"platform": "ios",
			"appVersion": Bundle.main.appVersion,
			"osVersion": UIDevice.current.systemVersion,
			"deviceModel": UIDevice.current.model,
			"registeredAt": Timestamp(date: Date()),
			"isActive": true
		]
		
		do {
			try await Firestore.firestore()
				.collection(AppConstants.Firestore.users)
				.document(userId)
				.collection(AppConstants.Firestore.fcmTokens)
				.document(token)
				.setData(tokenData, merge: true)
			
			print("✅ FCM token saved to Firestore")
		} catch {
			print("❌ Error saving FCM token: \(error.localizedDescription)")
		}
	}
	
	// MARK: - Testing
	func sendTestNotification(to userId: String) async throws {
		// This would call a Cloud Function
		// For now, we'll just log
		print("📤 Sending test notification to user: \(userId)")
	}
	
	// MARK: - Getters
	func getFCMToken() -> String? {
		currentFCMToken
	}
}

// MARK: - Bundle Extension
extension Bundle {
	var appVersion: String {
		infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
	}
}
