import Foundation
import FirebaseFirestore

// MARK: - Notifications Store

@Observable
final class NotificationsStore {
    // MARK: - Properties
    @ObservationIgnored
    private var db = Firestore.firestore()

    @ObservationIgnored
    private var notificationListener: ListenerRegistration?

    @ObservationIgnored
    private var preferencesListener: ListenerRegistration?

    // MARK: - Data
    var notifications: [Notification] = []
    var unreadCount: Int = 0
    var preferences: NotificationPreferences = NotificationPreferences()
    var isLoading: Bool = false
    var error: String?

    // MARK: - Setup & Cleanup
    func setupListeners(userId: String) async {
        // Safety check: Don't set up listeners if userId is empty
        guard !userId.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "User ID is empty - cannot setup listeners"
            print("⚠️ NotificationsStore: userId is empty, skipping listener setup")
            return
        }

        isLoading = true
        error = nil

        await setupNotificationListener(userId: userId)
        setupPreferencesListener(userId: userId)

        isLoading = false
    }

    // MARK: - Private Methods
    private func setupNotificationListener(userId: String) async {
        print("📍 Setting up notifications listener for user: \(userId)")

        notificationListener = db
            .collection("notifications")
            .document(userId)
            .collection("messages")
            .order(by: "timestamp", descending: true)
            .limit(to: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                // Handle errors safely without crashing
                if let error = error {
                    let errorMsg = error.localizedDescription
                    self.error = errorMsg
                    print("❌ Notifications listener error: \(errorMsg)")

                    // Log Firebase error codes for debugging
                    if let nsError = error as NSError? {
                        print("   Error code: \(nsError.code)")
                        print("   Error domain: \(nsError.domain)")

                        // Check if it's a permission error
                        if nsError.domain == "FIRFirestoreErrorDomain" && nsError.code == 7 {
                            print("   🔑 PERMISSION DENIED: Check Firestore rules for notifications collection")
                        }
                    }
                    return
                }

                guard let snapshot = snapshot else {
                    print("⚠️ Notification snapshot is nil")
                    return
                }

                // Safely decode notifications
                self.notifications = snapshot.documents.compactMap { doc in
                    do {
                        var notification = try doc.data(as: Notification.self)
                        // Set ID from document if not already set
                        if notification.id == nil {
                            notification.id = doc.documentID
                        }
                        // Filter out deleted and expired notifications
                        if !notification.deleted && !notification.isExpired {
                            return notification
                        }
                        return nil
                    } catch {
                        print("⚠️ Could not decode notification \(doc.documentID): \(error)")
                        return nil
                    }
                }

                self.updateUnreadCount()
                print("✅ Loaded \(self.notifications.count) notifications")
            }
    }

    private func setupPreferencesListener(userId: String) {
        preferencesListener = db
            .collection("users")
            .document(userId)
            .collection("notificationPreferences")
            .document("settings")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error loading preferences: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot, snapshot.exists else {
                    print("⚠️ No notification preferences found, using defaults")
                    self.preferences = NotificationPreferences()
                    return
                }

                do {
                    self.preferences = try snapshot.data(as: NotificationPreferences.self)
                    print("✅ Loaded notification preferences")
                } catch {
                    print("❌ Error decoding preferences: \(error)")
                    self.preferences = NotificationPreferences()
                }
            }
    }

    private func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.read }.count
    }

    // MARK: - Actions
    func markAsRead(_ notification: Notification) async {
        guard let notificationId = notification.id else { return }

        let path = "notifications/\(notification.userId)/messages/\(notificationId)"

        do {
            try await db.document(path).updateData([
                "read": true,
                "readAt": Timestamp(date: Date())
            ])

            if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
                notifications[index].read = true
                notifications[index].readAt = Date()
                updateUnreadCount()
            }
        } catch {
            self.error = error.localizedDescription
            print("❌ Error marking notification as read: \(error)")
        }
    }

    func markAllAsRead() async {
        for notification in notifications where !notification.read {
            await markAsRead(notification)
        }
    }

    func deleteNotification(_ notification: Notification) async {
        guard let notificationId = notification.id else { return }

        let path = "notifications/\(notification.userId)/messages/\(notificationId)"

        do {
            try await db.document(path).updateData([
                "deleted": true,
                "deletedAt": Timestamp(date: Date())
            ])

            notifications.removeAll { $0.id == notificationId }
            updateUnreadCount()
        } catch {
            self.error = error.localizedDescription
            print("❌ Error deleting notification: \(error)")
        }
    }

    func deleteAllNotifications() async {
        for notification in notifications {
            await deleteNotification(notification)
        }
    }

    func updatePreferences(_ newPreferences: NotificationPreferences) async {
        // This will be handled by NotificationPreferencesView
        // Update local copy for immediate UI feedback
        self.preferences = newPreferences

        print("✅ Preferences updated (will be synced to Firestore)")
    }

    // MARK: - Filtering & Search
    func notificationsByCategory(_ category: NotificationCategory) -> [Notification] {
        notifications.filter { $0.category == category }
    }

    func notificationsByPriority(_ priority: NotificationPriority) -> [Notification] {
        notifications.filter { $0.priority == priority }
    }

    func unreadNotifications() -> [Notification] {
        notifications.filter { !$0.read }
    }

    func searchNotifications(query: String) -> [Notification] {
        guard !query.isEmpty else { return notifications }
        let lowercased = query.lowercased()
        return notifications.filter { notification in
            notification.title.lowercased().contains(lowercased) ||
            notification.body.lowercased().contains(lowercased)
        }
    }

    // MARK: - Cleanup
    deinit {
        notificationListener?.remove()
        preferencesListener?.remove()
    }
}
