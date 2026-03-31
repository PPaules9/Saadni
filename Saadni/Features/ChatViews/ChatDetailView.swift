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
	@Environment(UserCache.self) var userCache
	@State private var messageText = ""
	@State private var isTyping = false
	@State private var scrollPosition: String?
	@State private var otherParticipantName: String = "User"
	@State private var currentUserName: String = "You"
	@State private var isLoadingNames: Bool = true
	@State private var namesLoadError: String?
	
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
							if isLoadingNames {
								HStack(spacing: 8) {
									ProgressView()
										.scaleEffect(0.8)
									Text("Loading...")
										.font(.caption)
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								}
							} else {
								Text(otherParticipantName)
									.font(.headline)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
								
								HStack(spacing: 4) {
									Circle()
										.fill(Colors.swiftUIColor(.primary))
										.frame(width: 8, height: 8)
									
									Text("Online")
										.font(.caption)
										.foregroundStyle(Colors.swiftUIColor(.primary))
								}
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
					
					// Show error banner if there's an issue
					if let error = namesLoadError {
						HStack(spacing: 12) {
							Image(systemName: "exclamationmark.triangle.fill")
								.foregroundStyle(.orange)
							
							VStack(alignment: .leading, spacing: 2) {
								Text("Could not load names")
									.font(.caption)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
								Text(error)
									.font(.caption2)
									.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							}
							
							Spacer()
							
							Button(action: { loadOtherParticipantInfo() }) {
								Image(systemName: "arrow.clockwise")
									.foregroundStyle(.orange)
									.font(.caption)
							}
						}
						.padding(12)
						.background(Color.orange.opacity(0.1))
					}
				}
				
				Divider()
				
				// Messages List
				if messagesStore.isLoading {
					VStack(spacing: 16) {
						ProgressView()
							.tint(Colors.swiftUIColor(.primary))
						Text("Loading messages...")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else if let error = messagesStore.error {
					VStack(spacing: 16) {
						Image(systemName: "exclamationmark.circle")
							.font(.system(size: 48))
							.foregroundStyle(.red)
						
						Text("Failed to load messages")
							.font(.headline)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						
						Text(error.errorDescription ?? "Unknown error")
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							.multilineTextAlignment(.center)
							.padding(.horizontal)
						
						Button(action: { setupMessagesListener() }) {
							HStack(spacing: 8) {
								Image(systemName: "arrow.clockwise")
								Text("Retry")
									.fontWeight(.semibold)
							}
							.padding(.vertical, 10)
							.padding(.horizontal, 16)
							.cornerRadius(8)
						}
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else if messages.isEmpty {
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
								ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
									let showDivider: Bool = {
										if index == 0 { return true }
										let previousMessage = messages[index - 1]
										return !Calendar.current.isDate(message.createdAt, inSameDayAs: previousMessage.createdAt)
									}()
									
									if showDivider {
										Text(formatDateDivider(message.createdAt))
											.font(.caption2)
											.fontWeight(.medium)
											.foregroundStyle(Colors.swiftUIColor(.textSecondary))
											.padding(.vertical, 4)
											.padding(.horizontal, 12)
											.background(Colors.swiftUIColor(.surfaceWhite))
											.clipShape(Capsule())
											.padding(.vertical, 8)
											.frame(maxWidth: .infinity, alignment: .center)
									}
									
									MessageBubble(
										message: message,
										isFromCurrentUser: message.isSentByCurrentUser(userId: currentUserId),
										senderName: message.senderId == currentUserId ? nil : message.senderName
									)
									.id(message.id)
								}
								
								// Typing indicator
								if typingUsers.contains(where: { $0 != currentUserId }) {
									TypingIndicatorView()
										.frame(width: 60)
										.frame(maxWidth: .infinity, alignment: .leading)
										.padding(.horizontal, 16)
								}
							}
							.padding(16)
						}
						.scrollDismissesKeyboard(.interactively)
						.onAppear {
							if let lastMessageId = messages.last?.id {
								proxy.scrollTo(lastMessageId, anchor: .bottom)
							}
						}
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
								.foregroundStyle(messageText.isEmpty ? Colors.swiftUIColor(.textSecondary) : Colors.swiftUIColor(.primary))
						}
						.disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
					}
					.padding(12)
				}
			}
		}
		.navigationTitle("Chat")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			setupMessagesListener()
			loadOtherParticipantInfo()
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
		print("🔄 [ChatDetail] Setting up message and typing listeners for conversation: \(conversation.id)")
		messagesStore.setupListener(conversationId: conversation.id)
		messagesStore.setupTypingListener(conversationId: conversation.id)
		
		// Give Firestore a moment to start loading, then log status
		Task {
			try? await Task.sleep(for: .milliseconds(500))
			await MainActor.run {
				if let error = messagesStore.error {
					print("❌ [ChatDetail] Message listener error: \(error)")
					print("   If this mentions 'Missing or insufficient permissions':")
					print("   1. Deploy Firestore rules from FIRESTORE_RULES_DEPLOYMENT_GUIDE.txt")
					print("   2. Wait 2 minutes for rules to propagate")
					print("   3. Restart the app and try again")
				} else {
					print("✅ [ChatDetail] Message listeners setup successfully")
				}
			}
		}
	}
	
	private func loadOtherParticipantInfo() {
		// Get the other participant's ID
		guard let otherUserId = conversation.otherParticipantId(currentUserId: currentUserId) else {
			print("⚠️ [ChatDetail] Could not determine other participant")
			print("   Conversation participantIds: \(conversation.participantIds)")
			print("   Current user ID: \(currentUserId)")
			namesLoadError = "Could not find other participant in conversation"
			isLoadingNames = false
			return
		}
		
		isLoadingNames = true
		namesLoadError = nil
		
		Task {
			// Load current user's name
			if let currentUser = userCache.currentUser {
				await MainActor.run {
					currentUserName = currentUser.displayName ?? currentUser.email ?? "You"
					print("✅ [ChatDetail] Loaded current user name: \(currentUserName)")
				}
			}
			
			// Fetch other participant's name from Firestore
			do {
				print("🔄 [ChatDetail] Fetching other participant info for: \(otherUserId)")
				if let otherUser = try await FirestoreService.shared.fetchUser(id: otherUserId) {
					await MainActor.run {
						otherParticipantName = otherUser.displayName ?? otherUser.email ?? "Provider"
						isLoadingNames = false
						print("✅ [ChatDetail] Loaded other participant name: \(otherParticipantName)")
					}
				} else {
					await MainActor.run {
						otherParticipantName = "Provider"
						isLoadingNames = false
						namesLoadError = "User not found"
						print("⚠️ [ChatDetail] Other participant not found in Firestore")
					}
				}
			} catch {
				await MainActor.run {
					otherParticipantName = "Provider"
					isLoadingNames = false
					namesLoadError = "Permission denied or network error"
					print("❌ [ChatDetail] Failed to fetch other participant info:")
					print("   Error: \(error.localizedDescription)")
					print("   This is often due to Firestore security rules not allowing user reads")
					print("   Solution: Deploy Firestore rules from FIRESTORE_RULES_DEPLOYMENT_GUIDE.txt")
				}
			}
		}
	}
	
	private func sendMessage() {
		let trimmedMessage = messageText.trimmingCharacters(in: .whitespaces)
		guard !trimmedMessage.isEmpty else { return }
		
		Task {
			do {
				try await messagesStore.sendMessage(
					to: conversation.id,
					from: currentUserId,
					senderName: currentUserName,
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
	
	private func formatDateDivider(_ date: Date) -> String {
		let calendar = Calendar.current
		if calendar.isDateInToday(date) {
			return "Today"
		} else if calendar.isDateInYesterday(date) {
			return "Yesterday"
		} else {
			let formatter = DateFormatter()
			formatter.dateFormat = "d MMMM"
			return formatter.string(from: date)
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
		.environment(UserCache())
	}
}
