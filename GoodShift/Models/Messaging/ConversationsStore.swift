//
//  ConversationsStore.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
class ConversationsStore: ListenerManaging {
    // MARK: - State

    /// All conversations for the current user
    var conversations: [Conversation] = []

    /// Conversations indexed by other user ID for quick lookup
    var conversationsByUserId: [String: Conversation] = [:]

    /// Error state
    var error: String?

    /// Loading state
    var isLoading: Bool = false

    // MARK: - Private Properties

    // MARK: - Listener Management (from ListenerManaging protocol)
    var activeListeners: [String: ListenerRegistration] = [:]
    var listenerSetupState: [String: Bool] = [:]

    private let db: Firestore

    init() {
        self.db = Firestore.firestore()
    }

    deinit {
        removeAllListeners()
    }

    // MARK: - Setup & Teardown

    /// Setup real-time listener for user's conversations
    func setupListeners(userId: String) {
        let listenerId = "userConversations"
        
        // Skip if already listening
        guard !isListenerActive(id: listenerId) else {
            print("⚠️ Listener already active for conversations")
            return
        }

        isLoading = true

        let listener = db.collection(AppConstants.Firestore.conversations)
            .whereField("participantIds", arrayContains: userId)
            .order(by: "lastMessageTime", descending: true)
            .limit(to: 30)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.error = "❌ Error loading conversations: \(error.localizedDescription)"
                    print(self.error ?? "")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let fetchedConversations = documents.compactMap { doc in
                    Conversation.fromFirestore(id: doc.documentID, data: doc.data())
                }

                self.conversations = fetchedConversations

                // Build index by other user ID
                self.conversationsByUserId.removeAll()
                for conversation in fetchedConversations {
                    if let otherUserId = conversation.otherParticipantId(currentUserId: userId) {
                        self.conversationsByUserId[otherUserId] = conversation
                    }
                }

                print("✅ [ConversationsStore] Loaded \(fetchedConversations.count) conversations")
            }
        
        addListener(id: listenerId, listener: listener)
    }

    /// Stop listening for conversations and clear local state
    func removeAllListeners() {
        print("🧹 [ConversationsStore] Removing all listeners and clearing state...")
        
        // Remove Firestore listeners
        activeListeners.values.forEach { $0.remove() }
        activeListeners.removeAll()
        listenerSetupState.removeAll()
        
        // Clear local data for next session
        conversations = []
        conversationsByUserId = [:]
        error = nil
        isLoading = false
        
        print("🧹 [ConversationsStore] State cleared")
    }

    @available(*, deprecated, renamed: "removeAllListeners")
    func stopListening() {
        removeAllListeners()
    }

    // MARK: - Conversation Operations

    /// Get or create conversation with another user
    /// Returns existing conversation ID if one exists, otherwise creates new one
    func getOrCreateConversation(with otherUserId: String, currentUserId: String) async throws -> String {
        // Check if conversation already exists with this user
        if let existingConversation = conversationsByUserId[otherUserId] {
            print("✅ Found existing conversation with \(otherUserId): \(existingConversation.id)")
            return existingConversation.id
        }

        // Create new conversation
        let conversationId = UUID().uuidString
        let participantIds = [currentUserId, otherUserId].sorted()

        let conversation = Conversation(
            id: conversationId,
            participantIds: participantIds,
            lastMessage: "",
            lastMessageTime: Date(),
            lastMessageSenderId: currentUserId
        )

        do {
            try await db.collection(AppConstants.Firestore.conversations).document(conversationId).setData(conversation.toFirestore())
            print("✅ Conversation created: \(conversationId)")
            return conversationId
        } catch {
            self.error = "❌ Failed to create conversation: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    /// Update last message in a conversation
    func updateLastMessage(
        conversationId: String,
        message: String,
        timestamp: Date,
        senderId: String
    ) async throws {
        do {
            try await db.collection(AppConstants.Firestore.conversations).document(conversationId).updateData([
                "lastMessage": message,
                "lastMessageTime": Timestamp(date: timestamp),
                "lastMessageSenderId": senderId
            ])
            print("✅ Last message updated")
        } catch {
            self.error = "❌ Failed to update last message: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    /// Delete a conversation entirely — removes all messages, typing indicators, and the conversation document from Firestore, plus clears local cache.
    func deleteConversation(_ conversationId: String) async throws {
        do {
            // 1. Delete all messages for this conversation (batch in chunks of 500)
            var lastSnapshot: QuerySnapshot? = nil
            repeat {
                var query = db.collection(AppConstants.Firestore.messages)
                    .whereField("conversationId", isEqualTo: conversationId)
                    .limit(to: 500)
                if let last = lastSnapshot?.documents.last {
                    query = query.start(afterDocument: last)
                }
                let snapshot = try await query.getDocuments()
                lastSnapshot = snapshot
                if !snapshot.documents.isEmpty {
                    let batch = db.batch()
                    snapshot.documents.forEach { batch.deleteDocument($0.reference) }
                    try await batch.commit()
                    print("🗑️ Deleted \(snapshot.documents.count) messages for conversation \(conversationId)")
                }
            } while lastSnapshot?.documents.count == 500

            // 2. Delete typing indicators subcollection
            let typingDocs = try await db.collection(AppConstants.Firestore.conversations)
                .document(conversationId)
                .collection("typingIndicators")
                .getDocuments()
            if !typingDocs.documents.isEmpty {
                let batch = db.batch()
                typingDocs.documents.forEach { batch.deleteDocument($0.reference) }
                try await batch.commit()
            }

            // 3. Delete the conversation document itself
            try await db.collection(AppConstants.Firestore.conversations).document(conversationId).delete()

            // 4. Remove from local cache immediately
            conversations.removeAll { $0.id == conversationId }
            conversationsByUserId = conversationsByUserId.filter { $0.value.id != conversationId }

            print("✅ Conversation \(conversationId) fully deleted")
        } catch {
            self.error = "❌ Failed to delete conversation: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    /// Pin or unpin a conversation — pinned conversations appear at the top of the list.
    func pinConversation(_ conversationId: String, isPinned: Bool) async throws {
        do {
            try await db.collection(AppConstants.Firestore.conversations).document(conversationId).updateData([
                "isPinned": isPinned
            ])
            // Update local cache optimistically
            if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
                let old = conversations[index]
                conversations[index] = Conversation(
                    id: old.id,
                    participantIds: old.participantIds,
                    lastMessage: old.lastMessage,
                    lastMessageTime: old.lastMessageTime,
                    lastMessageSenderId: old.lastMessageSenderId,
                    isPinned: isPinned
                )
            }
            print("✅ Conversation \(conversationId) \(isPinned ? "pinned" : "unpinned")")
        } catch {
            self.error = "❌ Failed to pin conversation: \(error.localizedDescription)"
            print(self.error ?? "")
            throw error
        }
    }

    // MARK: - Helper Methods

    /// Get conversation with specific user
    func getConversation(with otherUserId: String) -> Conversation? {
        return conversationsByUserId[otherUserId]
    }

    /// Get conversation by ID
    func getConversationById(_ conversationId: String) -> Conversation? {
        return conversations.first { $0.id == conversationId }
    }

    /// Check if conversation exists with user
    func conversationExists(with otherUserId: String) -> Bool {
        return conversationsByUserId[otherUserId] != nil
    }

    /// Search conversations by last message content — pinned results appear first
    func searchConversations(_ query: String) -> [Conversation] {
        guard !query.isEmpty else { return sortedConversations }

        return conversations
            .filter { $0.lastMessage.localizedCaseInsensitiveContains(query) }
            .sorted {
                if $0.isPinned != $1.isPinned { return $0.isPinned }
                return $0.lastMessageTime > $1.lastMessageTime
            }
    }

    /// Get unread message count for a conversation
    func getUnreadCount(for conversationId: String) async throws -> Int {
        // This would require tracking read receipts in the Conversation model
        // For now, returning 0
        return 0
    }

    /// Sort conversations — pinned first, then by most recent
    var sortedConversations: [Conversation] {
        return conversations.sorted {
            if $0.isPinned != $1.isPinned { return $0.isPinned }
            return $0.lastMessageTime > $1.lastMessageTime
        }
    }
}
