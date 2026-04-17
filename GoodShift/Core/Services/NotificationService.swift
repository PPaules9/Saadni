//
//  NotificationService.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseMessaging

class NotificationService {
    static let shared = NotificationService()

    private let db = Firestore.firestore()
    private var currentUserId: String?

    private init() {
        setupMessagingDelegate()
    }

    // MARK: - Setup

    /// Setup Firebase Messaging delegate to handle FCM token updates
    private func setupMessagingDelegate() {
        // Delegate is set in AppDelegate
        // This method is here for future setup if needed
    }

    // MARK: - Device Token Management

    /// Register device token for a user
    func registerDeviceToken(_ token: String, for userId: String) async throws {
        currentUserId = userId

        let tokenData: [String: Any] = [
            "userId": userId,
            "token": token,
            "updatedAt": Timestamp(date: Date())
        ]

        do {
            try await db.collection(AppConstants.Firestore.deviceTokens).document(userId).setData(tokenData)
            print("✅ Device token registered for user \(userId)")
        } catch {
            print("❌ Failed to register device token: \(error.localizedDescription)")
            throw error
        }
    }

    /// Get device token for a user
    func getDeviceToken(for userId: String) async throws -> String? {
        do {
            let document = try await db.collection(AppConstants.Firestore.deviceTokens).document(userId).getDocument()

            guard let data = document.data(),
                  let token = data["token"] as? String
            else {
                return nil
            }

            return token
        } catch {
            print("❌ Failed to fetch device token: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Push Notification Sending

    /// Send push notification to a user
    /// Note: In production, this would be handled by Cloud Functions
    /// This is a reference implementation
    func sendNotification(
        to userId: String,
        title: String,
        body: String,
        data: [String: String] = [:]
    ) async throws {
        guard (try await getDeviceToken(for: userId)) != nil else {
            print("⚠️ No device token found for user \(userId)")
            return
        }

        // In production, use Cloud Functions to send notifications
        // Client-side FCM sending is not recommended
        // This is just a reference for the data structure

        print("📤 Notification prepared for \(userId): \(title)")
    }

    /// Send message notification
    func sendMessageNotification(
        to recipientId: String,
        from senderName: String,
        conversationId: String,
        messagePreview: String
    ) async throws {
        let title = "Message from \(senderName)"
        let body = messagePreview.count > 50 ? String(messagePreview.prefix(50)) + "..." : messagePreview

        let data = [
            "conversationId": conversationId,
            "senderName": senderName,
            "type": "message"
        ]

        try await sendNotification(
            to: recipientId,
            title: title,
            body: body,
            data: data
        )
    }

    // MARK: - Notification Handling

    /// Handle incoming remote notification
    func handleRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        print("🔔 Received remote notification: \(userInfo)")

        if let conversationId = userInfo["conversationId"] as? String {
            print("📱 Opening conversation: \(conversationId)")
            // Notify observers to navigate to chat
            NotificationCenter.default.post(
                name: NSNotification.Name("openChat"),
                object: conversationId
            )
        }
    }

    /// Handle notification tap
    func handleNotificationTap(_ userInfo: [AnyHashable: Any]) {
        if let conversationId = userInfo["conversationId"] as? String {
            print("👆 User tapped notification for conversation: \(conversationId)")
            NotificationCenter.default.post(
                name: NSNotification.Name("openChat"),
                object: conversationId
            )
        }
    }

    // MARK: - Notification Preferences

    /// Update notification preferences for a user
    func updateNotificationPreferences(
        userId: String,
        messagesEnabled: Bool,
        soundEnabled: Bool,
        badgeEnabled: Bool
    ) async throws {
        let preferences: [String: Any] = [
            "messagesNotifications": messagesEnabled,
            "soundEnabled": soundEnabled,
            "badgeEnabled": badgeEnabled,
            "updatedAt": Timestamp(date: Date())
        ]

        do {
            try await db.collection(AppConstants.Firestore.users).document(userId).updateData([
                "notificationPreferences": preferences
            ])
            print("✅ Notification preferences updated")
        } catch {
            print("❌ Failed to update notification preferences: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Current User

    /// Set current user ID (call when user authenticates)
    func setCurrentUser(_ userId: String) {
        currentUserId = userId
    }

    /// Get current user ID
    func getCurrentUserId() -> String? {
        return currentUserId
    }
}
