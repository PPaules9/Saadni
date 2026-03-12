//
//  ChatDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ChatDetailView: View {
    @Environment(MessagesStore.self) var messagesStore
    @Environment(ConversationsStore.self) var conversationsStore
    @Environment(AuthenticationManager.self) var authManager
    @State private var messageText = ""
    @State private var isTyping = false
    @State private var scrollPosition: String?

    let conversation: Conversation

    var messages: [Message] {
        messagesStore.getMessages(for: conversation.id)
    }

    var typingUsers: [String] {
        messagesStore.getTypingUsers(for: conversation.id)
    }

    var currentUserId: String {
        authManager.currentUserId ?? ""
    }

    var body: some View {
        ZStack {
            Color(Colors.swiftUIColor(.appBackground))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("User")
                                .font(.headline)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))

                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color(UIColor(hex: "#37857D")))
                                    .frame(width: 8, height: 8)

                                Text("Online")
                                    .font(.caption)
                                    .foregroundStyle(Color(UIColor(hex: "#37857D")))
                            }
                        }

                        Spacer()

                        Menu {
                            Button("Call", action: {})
                            Button("Info", action: {})
                            Button("Delete", action: {})
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                        }
                    }
                    .padding(16)
                }
                .background(Color(UIColor(hex: "#FEFEFE")))

                Divider()

                // Messages List
                if messages.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 48))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text("No messages yet")
                            .font(.headline)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        Text("Start the conversation")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(messages) { message in
                                    MessageBubble(
                                        message: message,
                                        isFromCurrentUser: message.isSentByCurrentUser(userId: currentUserId),
                                        senderName: message.senderId == currentUserId ? nil : "Provider"
                                    )
                                    .id(message.id)
                                }

                                // Typing indicator
                                if !typingUsers.isEmpty {
                                    TypingIndicatorView()
                                        .frame(width: 60)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(16)
                        }
                        .scrollDismissesKeyboard(.interactively)
                        .onChange(of: messages.count) { oldCount, newCount in
                            if newCount > oldCount, let lastMessageId = messages.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastMessageId, anchor: .bottom)
                                }
                            }
                        }
                    }
                }

                Divider()

                // Input Area
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        TextField("Type a message...", text: $messageText)
                            .textFieldStyle(.plain)
                            .font(.body)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                            .padding(12)
                            .background(Color(UIColor(hex: "#FEFEFE")))
                            .cornerRadius(20)
                            .onChange(of: messageText) { oldValue, newValue in
                                let wasTyping = isTyping
                                isTyping = !newValue.isEmpty
                                if wasTyping != isTyping {
                                    updateTypingStatus()
                                }
                            }

                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundStyle(messageText.isEmpty ? Colors.swiftUIColor(.textSecondary) : Color(UIColor(hex: "#37857D")))
                        }
                        .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(12)
                }
                .background(Color(UIColor(hex: "#FEFEFE")))
            }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupMessagesListener()
        }
        .onDisappear {
            messagesStore.stopListener(conversationId: conversation.id)
            // Stop typing when leaving
            Task {
                try? await messagesStore.setTyping(false, in: conversation.id, by: currentUserId)
            }
        }
    }

    // MARK: - Helper Methods

    private func setupMessagesListener() {
        messagesStore.setupListener(conversationId: conversation.id)
        messagesStore.setupTypingListener(conversationId: conversation.id)
    }

    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmedMessage.isEmpty else { return }

        Task {
            do {
                try await messagesStore.sendMessage(
                    to: conversation.id,
                    from: currentUserId,
                    content: trimmedMessage,
                    participantIds: conversation.participantIds
                )

                // Update conversation last message
                try await conversationsStore.updateLastMessage(
                    conversationId: conversation.id,
                    message: trimmedMessage,
                    timestamp: Date(),
                    senderId: currentUserId
                )

                // Clear input
                messageText = ""
                isTyping = false
                try await messagesStore.setTyping(false, in: conversation.id, by: currentUserId)
            } catch {
                print("❌ Failed to send message: \(error)")
            }
        }
    }

    private func updateTypingStatus() {
        Task {
            do {
                try await messagesStore.setTyping(isTyping, in: conversation.id, by: currentUserId)
            } catch {
                print("❌ Failed to update typing status: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(
            conversation: Conversation(
                id: "conv_1",
                participantIds: ["user_1", "user_2"],
                lastMessage: "See you soon!",
                lastMessageTime: Date(),
                lastMessageSenderId: "user_1"
            )
        )
        .environment(MessagesStore())
        .environment(ConversationsStore())
        .environment(AuthenticationManager(userCache: UserCache()))
    }
}
