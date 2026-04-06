//
//  AppDelegate.swift
//  GoodShift
//
//  Created by Pavly Paules on 18/03/2026.
//

import UserNotifications
import FirebaseMessaging
import FirebaseFirestore
import FirebaseAuth
import UIKit


// MARK: - Notification Names for later navigates to each by tab on the notification

extension NSNotification.Name {
	static let openChat             = NSNotification.Name("openChat")
	static let openJobDetail        = NSNotification.Name("openJobDetail")
	static let openJobApplications  = NSNotification.Name("openJobApplications")
	static let openApplicationDetail = NSNotification.Name("openApplicationDetail")
	static let openReview           = NSNotification.Name("openReview")
	static let openTransaction      = NSNotification.Name("openTransaction")
	static let openWallet           = NSNotification.Name("openWallet")
	static let openProfile          = NSNotification.Name("openProfile")
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
	
	// Handle notification while app is in foreground
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound, .badge])
	}

	// Handle notification tap
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		let typeRaw = userInfo["type"] as? String ?? ""
		let type = NotificationType(rawValue: typeRaw)
		
		switch type {
			
			// MARK: - Messages
		case .newMessageFromProvider, .newMessageFromSeeker:
			if let conversationId = userInfo["conversationId"] as? String {
				NotificationCenter.default.post(name: .openChat, object: conversationId)
			}
			
			// MARK: - Applications
		case .newApplicationReceived, .applicationWithdrawnBySeeker, .applicationAcceptedBySeeker:
			if let jobId = userInfo["jobId"] as? String {
				NotificationCenter.default.post(name: .openJobApplications, object: jobId)
			}
			
		case .applicationStatus, .applicationWithdrawnAck:
			if let applicationId = userInfo["applicationId"] as? String {
				NotificationCenter.default.post(name: .openApplicationDetail, object: applicationId)
			}
			
			// MARK: - Jobs
		case .matchingJob, .jobReminder, .jobStartsSoon, .jobCancelledByProvider, .jobExpiringSoon:
			if let jobId = userInfo["jobId"] as? String {
				NotificationCenter.default.post(name: .openJobDetail, object: jobId)
			}
			
			// MARK: - Reviews
		case .reviewPostedByProvider, .reviewPostedBySeeker:
			if let reviewId = userInfo["reviewId"] as? String {
				NotificationCenter.default.post(name: .openReview, object: reviewId)
			}
			
			// MARK: - Wallet / Earnings
		case .earningReceived, .paymentReceived, .topupSuccess, .withdrawalProcessed, .withdrawalPending:
			if let transactionId = userInfo["transactionId"] as? String {
				NotificationCenter.default.post(name: .openTransaction, object: transactionId)
			} else {
				NotificationCenter.default.post(name: .openWallet, object: nil)
			}
			
			// MARK: - Ratings
		case .lowRatingAlert:
			NotificationCenter.default.post(name: .openProfile, object: nil)
			
		case .none:
			print("⚠️ Unknown notification type: \(typeRaw)")
		}
		
		completionHandler()
	}
	
	
	// Standrad function to give last chance before launch
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		return true
	}
	
	// Creates APNs Device Token and passing it to Firebase
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
		print("✅ Device token registered with FCM")
	}
	
	
	// Firebase Cloud Messaging token refresh for security
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		guard let fcmToken = fcmToken else { return }
		print("🔑 FCM Token: \(fcmToken)")
		
		guard let userId = Auth.auth().currentUser?.uid else {
			print("⚠️ Cannot save FCM token: user not authenticated")
			return
		}
		
		Task {
			let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
			
			let tokenData: [String: Any] = [
				"token": fcmToken,
				"platform": "ios",
				"deviceModel": UIDevice.current.model,
				"osVersion": UIDevice.current.systemVersion,
				"appVersion": appVersion,
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
