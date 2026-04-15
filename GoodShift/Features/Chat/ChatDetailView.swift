//
//  ChatDetailView.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ChatDetailView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(MessagesStore.self) var messagesStore
	@Environment(ConversationsStore.self) var conversationsStore
	@Environment(AuthenticationManager.self) var authManager
	@Environment(UserCache.self) var userCache
	@Environment(UserFetchCache.self) var userFetchCache
	@State private var viewModel = ChatDetailViewModel()
	@State private var messageText = ""
	@State private var isTyping = false
	@State private var scrollPosition: String?
	@State private var sendError: String?
	@State private var showSendError = false

	// Participant name state now lives in the ViewModel — not in the View
	private var otherParticipantName: String { viewModel.otherUserName }
	private var isLoadingNames: Bool { viewModel.isLoadingUser }
	private var namesLoadError: String? { viewModel.userLoadError }
	private var currentUserName: String { userCache.currentUser?.displayName ?? "You" }
	
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
						Button(action: { dismiss() }) {
								Image(systemName: "chevron.left")
									.font(.system(size: 18, weight: .semibold))
									.foregroundStyle(Colors.swiftUIColor(.textMain))
							}
							.frame(minWidth: 44, minHeight: 44)
							.accessibilityLabel("Back")
						Image(systemName: "person.crop.circle.fill")
							.resizable()
							.frame(width: 50, height: 50)
							.clipShape(Circle())
							.overlay(
								Circle()
							)
						
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
						.accessibilityLabel("More options")
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
							
							Button(action: {
								Task {
									guard let otherUserId = conversation.otherParticipantId(currentUserId: currentUserId) else { return }
									await viewModel.loadOtherUserInfo(userId: otherUserId)
								}
							}) {
								Image(systemName: "arrow.clockwise")
									.foregroundStyle(.orange)
									.font(.caption)
							}
							.frame(minWidth: 44, minHeight: 44)
							.accessibilityLabel("Retry Loading User")
						}
						.padding(12)
						.background(Color.orange.opacity(0.1))
					}
				}
				
				Divider()
				
				// Messages List
				if messagesStore.isLoading {
					LoadingStateView(message: "Loading messages...")
						.frame(maxHeight: .infinity)
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
							.onChange(of: messageText) { oldValue, newValue in
								let wasTyping = isTyping
								isTyping = !newValue.isEmpty
								if wasTyping != isTyping {
									updateTypingStatus()
								}
							}
							.background(
								RoundedRectangle(cornerRadius: 25)
									.fill(Color.clear)
									.strokeBorder(Colors.swiftUIColor(.textSecondary), lineWidth: 0.4)
							)
						
						Button(action: sendMessage) {
							Image(systemName: "paperplane.fill")
								.foregroundStyle(messageText.isEmpty ? Colors.swiftUIColor(.textSecondary) : Colors.swiftUIColor(.primary))
						}
						.disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
						.accessibilityLabel("Send message")
						.frame(minWidth: 44, minHeight: 44)
					}
					.padding(.horizontal)
					.padding(.vertical)
				}
				.background()
			}
		}
		.navigationBarBackButtonHidden(true)
		.onAppear {
			AnalyticsService.shared.track(.chatOpened)
			setupMessagesListener()
		}
		.task {
			// Wire the cache into the ViewModel before fetching
			viewModel.userFetchCache = userFetchCache
			// Load participant name through the ViewModel — not directly from Firestore
			guard let otherUserId = conversation.otherParticipantId(currentUserId: currentUserId) else { return }
			await viewModel.loadOtherUserInfo(userId: otherUserId)
		}
		.onDisappear {
			messagesStore.stopListener(conversationId: conversation.id)
			// Stop typing when leaving
			Task {
				try? await messagesStore.setTyping(false, in: conversation.id, by: currentUserId)
			}
		}
		.alert("Failed to Send", isPresented: $showSendError) {
			Button("OK", role: .cancel) { showSendError = false }
		} message: {
			Text(sendError ?? "Your message could not be sent. Please try again.")
		}
	}
	
	// MARK: - Helper Methods
	
	private func setupMessagesListener() {
		// Errors surface reactively via messagesStore.error observed in the view body — no polling needed.
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

				// Clear input only on success so the user doesn't lose their text
				messageText = ""
				isTyping = false
				try await messagesStore.setTyping(false, in: conversation.id, by: currentUserId)
			} catch {
				sendError = error.localizedDescription
				showSendError = true
				// messageText is intentionally NOT cleared — user can retry
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
	
	private static let dateDividerFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "d MMMM"
		return f
	}()

	private func formatDateDivider(_ date: Date) -> String {
		let calendar = Calendar.current
		if calendar.isDateInToday(date) {
			return "Today"
		} else if calendar.isDateInYesterday(date) {
			return "Yesterday"
		} else {
			return ChatDetailView.dateDividerFormatter.string(from: date)
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
