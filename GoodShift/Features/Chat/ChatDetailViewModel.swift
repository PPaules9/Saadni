//
//  ChatDetailViewModel.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class ChatDetailViewModel {
    // MARK: - Dependencies
    @ObservationIgnored var messagesStore: MessagesStore?
    @ObservationIgnored var userCache: UserCache?
    @ObservationIgnored var userFetchCache: UserFetchCache?

    // MARK: - UI State
    var messageText = ""
    var isSending = false
    var sendError: String?
    var isLoadingUser = false
    var userLoadError: String?
    var otherUserName: String = "User"
    var otherUserAvatar: String = ""

    // MARK: - Message Operations

    /// Sends a message in a conversation
    func sendMessage(
        conversationId: String,
        senderId: String,
        senderName: String,
        senderPhotoURL: String? = nil,
        participantIds: [String],
        text: String
    ) async {
        guard let messagesStore = messagesStore else { return }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isSending = true
        sendError = nil

        do {
            try await messagesStore.sendMessage(
                to: conversationId,
                from: senderId,
                senderName: senderName,
                senderPhotoURL: senderPhotoURL,
                content: text,
                participantIds: participantIds
            )
            AnalyticsService.shared.track(.messageSent)
            messageText = ""
            isSending = false
        } catch {
            sendError = error.localizedDescription
            isSending = false
            print("❌ Failed to send message: \(error)")
        }
    }

    /// Sets typing indicator for the current user
    func setTypingIndicator(
        conversationId: String,
        userId: String,
        isTyping: Bool
    ) async {
        guard let messagesStore = messagesStore else { return }

        do {
            try await messagesStore.setTyping(isTyping, in: conversationId, by: userId)
        } catch {
            print("⚠️ Failed to set typing indicator: \(error)")
        }
    }

    /// Loads the other participant's user information.
    /// @MainActor ensures all state assignments happen on the main thread,
    /// preventing SwiftUI layout warnings from async context updates.
    @MainActor
    func loadOtherUserInfo(userId: String) async {
        isLoadingUser = true
        userLoadError = nil

        // Use UserFetchCache when available — avoids duplicate Firestore reads
        // if multiple chat views are open or if this user was already fetched elsewhere.
        let user: User?
        if let cache = userFetchCache {
            user = await cache.fetchUser(id: userId)
        } else {
            user = try? await FirestoreService.shared.fetchUser(id: userId)
        }

        if let user {
            otherUserName = user.displayName ?? "User"
            otherUserAvatar = user.photoURL ?? ""
            isLoadingUser = false
        } else {
            userLoadError = "User not found"
            isLoadingUser = false
        }
    }

    /// Marks all messages in a conversation as read
    func markConversationAsRead(conversationId: String) async {
        guard let messagesStore = messagesStore else { return }
        let unread = messagesStore.messages[conversationId]?.filter { !$0.isRead } ?? []
        for message in unread {
            try? await messagesStore.markAsRead(messageId: message.id, conversationId: conversationId)
        }
    }
}
