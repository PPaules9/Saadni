//
//  MessagesStore.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
class MessagesStore {
    // MARK: - State

    /// Messages grouped by conversation ID
    var messages: [String: [Message]] = [:]

    /// Typing users in each conversation (conversationId -> Set of userIds)
    var typingUsers: [String: Set<String>] = [:]

    /// Error state
    var error: String?

    /// Loading state
    var isLoading: Bool = false

    // MARK: - Private Properties

    private var messageListeners: [String: ListenerRegistration] = [:]
    private var typingListeners: [String: ListenerRegistration] = [:]
    private let db: Firestore

    init() {
        self.db = Firestore.firestore()
    }

    deinit {
        stopAllListeners()
    }

    // MARK: - Setup & Teardown

    /// Setup real-time listener for a conversation
    func setupListener(conversationId: String) {
        // Avoid duplicate listeners
        if messageListeners[conversationId] != nil {
            return
        }

        isLoading = true

        messageListeners[conversationId] = db.collection("messages")
            .whereField("conversationId", isEqualTo: conversationId)
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.error = "❌ Error loading messages: \(error.localizedDescription)"
                    print(self.error ?? "")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let fetchedMessages = documents.compactMap { doc in
                    Message.fromFirestore(id: doc.documentID, data: doc.data())
                }

                self.messages[conversationId] = fetchedMessages
                print("✅ Loaded \(fetchedMessages.count) messages for conversation \(conversationId)")
            }
    }

    /// Setup typing indicator listener for a conversation
    func setupTypingListener(conversationId: String) {
        // Avoid duplicate listeners
        if typingListeners[conversationId] != nil {
            return
        }

        typingListeners[conversationId] = db.collection("conversations")
            .document(conversationId)
            .collection("typingIndicators")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error loading typing indicators: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var typingUserIds: Set<String> = []

                for doc in documents {
                    if let indicator = TypingIndicator.fromFirestore(id: doc.documentID, data: doc.data()) {
                        if indicator.isActive {
                            typingUserIds.insert(indicator.userId)
                        }
                    }
                }

                self.typingUsers[conversationId] = typingUserIds
            }
    }

    /// Stop listening for specific conversation
    func stopListener(conversationId: String) {
        messageListeners[conversationId]?.remove()
        messageListeners.removeValue(forKey: conversationId)

        typingListeners[conversationId]?.remove()
        typingListeners.removeValue(forKey: conversationId)
    }

    /// Stop all listeners
    private func stopAllListeners() {
        messageListeners.values.forEach { $0.remove() }
        messageListeners.removeAll()

        typingListeners.values.forEach { $0.remove() }
        typingListeners.removeAll()
    }

    // MARK: - Message Operations

    /// Send a new message
    func sendMessage(
        to conversationId: String,
        from senderId: String,
        content: String,
        participantIds: [String]
    ) async throws {
        guard !content.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(domain: "MessagesStore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Message cannot be empty"])
        }

        let message = Message(
            id: UUID().uuidString,
            conversationId: conversationId,
            senderId: senderId,
            content: content,
            createdAt: Date(),
            isRead: false,
            participantIds: participantIds
        )

        do {
            try await db.collection("messages").document(message.id).setData(message.toFirestore())
            print("✅ Message sent successfully")
        } catch {
            self.error = "❌ Failed to send message: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    /// Mark message as read
    func markAsRead(messageId: String, conversationId: String) async throws {
        do {
            try await db.collection("messages").document(messageId).updateData([
                "isRead": true
            ])
            print("✅ Message marked as read")
        } catch {
            self.error = "❌ Failed to mark message as read: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    /// Set typing status
    func setTyping(
        _ isTyping: Bool,
        in conversationId: String,
        by userId: String
    ) async throws {
        let indicator = TypingIndicator(
            id: userId,
            conversationId: conversationId,
            userId: userId,
            isTyping: isTyping,
            timestamp: Date()
        )

        do {
            try await db.collection("conversations")
                .document(conversationId)
                .collection("typingIndicators")
                .document(userId)
                .setData(indicator.toFirestore())
        } catch {
            print("❌ Failed to update typing status: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Cleanup

    /// Delete old messages older than 90 days
    func deleteExpiredMessages() async throws {
        let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()

        do {
            let snapshot = try await db.collection("messages")
                .whereField("createdAt", isLessThan: Timestamp(date: ninetyDaysAgo))
                .getDocuments()

            let batch = db.batch()
            for document in snapshot.documents {
                batch.deleteDocument(document.reference)
            }

            try await batch.commit()
            print("✅ Deleted \(snapshot.documents.count) expired messages")
        } catch {
            self.error = "❌ Failed to delete expired messages: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    // MARK: - Helper Methods

    /// Get all messages for a conversation
    func getMessages(for conversationId: String) -> [Message] {
        return messages[conversationId] ?? []
    }

    /// Get typing users for a conversation
    func getTypingUsers(for conversationId: String) -> [String] {
        return Array(typingUsers[conversationId] ?? [])
    }

    /// Check if specific user is typing
    func isUserTyping(_ userId: String, in conversationId: String) -> Bool {
        return typingUsers[conversationId]?.contains(userId) ?? false
    }

    /// Check if any user is typing
    func anyoneTyping(in conversationId: String) -> Bool {
        return !(typingUsers[conversationId]?.isEmpty ?? true)
    }
}
