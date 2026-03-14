//
//  ChatDetailViewModel.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class ChatDetailViewModel {
    // MARK: - Dependencies
    @ObservationIgnored var messagesStore: MessagesStore?
    @ObservationIgnored var userCache: UserCache?

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
        text: String
    ) async {
        guard let messagesStore = messagesStore else { return }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isSending = true
        sendError = nil

        do {
            let message = Message(
                id: UUID().uuidString,
                conversationId: conversationId,
                senderId: senderId,
                senderName: senderName,
                text: text,
                timestamp: Date(),
                isRead: false
            )
            try await messagesStore.sendMessage(message)
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

    /// Loads the other participant's user information
    func loadOtherUserInfo(userId: String) async {
        guard let userCache = userCache else { return }

        isLoadingUser = true
        userLoadError = nil

        do {
            if let user = try await userCache.fetchUser(id: userId) {
                otherUserName = user.fullName
                otherUserAvatar = user.profileImageURL ?? ""
                isLoadingUser = false
            } else {
                userLoadError = "User not found"
                isLoadingUser = false
            }
        } catch {
            userLoadError = error.localizedDescription
            isLoadingUser = false
            print("❌ Failed to load user info: \(error)")
        }
    }

    /// Marks all messages in a conversation as read
    func markConversationAsRead(conversationId: String) async {
        guard let messagesStore = messagesStore else { return }

        do {
            try await messagesStore.markConversationAsRead(conversationId)
        } catch {
            print("⚠️ Failed to mark conversation as read: \(error)")
        }
    }
}
