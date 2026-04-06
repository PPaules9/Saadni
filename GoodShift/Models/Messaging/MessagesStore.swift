//
//  MessagesStore.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
class MessagesStore: ListenerManaging {
	
	
	var messages: [String: [Message]] = [:]
	
	/// Tracks whether older messages can be loaded per conversation
	var hasOlderMessages: [String: Bool] = [:]
	
	private let initialPageSize = 50
	private let olderPageSize = 30
	
	/// Typing users in each conversation (conversationId -> Set of userIds)
	var typingUsers: [String: Set<String>] = [:]
	
	/// Error state
	var error: AppError?
	
	/// Loading state
	var isLoading: Bool = false
	
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
	
	// MARK: - Listener Management Implementation
	
	/// Clear all listeners and reset local data
	func removeAllListeners() {
		print("🧹 [MessagesStore] Clearing all listeners and resetting state...")
		
		// Remove Firestore listeners
		activeListeners.values.forEach { $0.remove() }
		activeListeners.removeAll()
		listenerSetupState.removeAll()
		
		// Clear local data for next session
		messages = [:]
		hasOlderMessages = [:]
		typingUsers = [:]
		isLoading = false
		error = nil
		
		print("🧹 [MessagesStore] State cleared")
	}
	
	// MARK: - Setup & Teardown
	
	/// Setup real-time listener for a conversation
	func setupListener(conversationId: String) {
		let listenerId = "messages_\(conversationId)"
		
		// Skip if already listening
		guard !isListenerActive(id: listenerId) else {
			print("⚠️ Listener already active for conversation: \(conversationId)")
			return
		}
		
		isLoading = true
		
		// Fetch newest messages first, then reverse so oldest appears at top of chat.
		// Limit prevents loading entire history on open.
		let listener = db.collection("messages")
			.whereField("conversationId", isEqualTo: conversationId)
			.order(by: "createdAt", descending: true)
			.limit(to: initialPageSize)
			.addSnapshotListener { [weak self] snapshot, error in
				Task { @MainActor [weak self] in
					guard let self else { return }

					self.isLoading = false

					if let error = error {
						self.error = AppError.from(error)
						print("❌ Error loading messages: \(error)")
						return
					}

					guard let documents = snapshot?.documents else { return }

					let fetchedMessages = documents.compactMap { doc in
						Message.fromFirestore(id: doc.documentID, data: doc.data())
					}

					// Reverse so messages are in chronological order (oldest first)
					self.messages[conversationId] = fetchedMessages.reversed()
					self.hasOlderMessages[conversationId] = fetchedMessages.count == self.initialPageSize
					print("✅ Loaded \(fetchedMessages.count) messages for conversation \(conversationId)")
				}
			}
		
		addListener(id: listenerId, listener: listener)
	}
	
	/// Setup typing indicator listener for a conversation
	func setupTypingListener(conversationId: String) {
		let listenerId = "typing_\(conversationId)"
		
		// Skip if already listening
		guard !isListenerActive(id: listenerId) else {
			print("⚠️ Typing listener already active for conversation: \(conversationId)")
			return
		}
		
		let listener = db.collection("conversations")
			.document(conversationId)
			.collection("typingIndicators")
			.addSnapshotListener { [weak self] snapshot, error in
				Task { @MainActor [weak self] in
					guard let self else { return }

					if let error = error {
						print("❌ Error loading typing indicators: \(error)")
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
		
		addListener(id: listenerId, listener: listener)
	}
	
	/// Stop listening for specific conversation
	func stopListener(conversationId: String) {
		removeListener(id: "messages_\(conversationId)")
		removeListener(id: "typing_\(conversationId)")
	}
	
	// MARK: - Message Operations
	
	/// Send a new message
	func sendMessage(
		to conversationId: String,
		from senderId: String,
		senderName: String,
		senderPhotoURL: String? = nil,
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
			senderName: senderName,
			senderPhotoURL: senderPhotoURL,
			content: content,
			createdAt: Date(),
			isRead: false,
			participantIds: participantIds
		)
		
		do {
			try await db.collection("messages").document(message.id).setData(message.toFirestore())
			print("✅ Message sent successfully")
		} catch {
			self.error = AppError.from(error)
			print("❌ Failed to send message: \(error.localizedDescription)")
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
			self.error = AppError.from(error)
			print("❌ Failed to mark message as read: \(error.localizedDescription)")
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
	
	// MARK: - Load Older Messages (pagination when scrolling up)
	
	/// Loads messages older than the oldest currently loaded message.
	func loadOlderMessages(conversationId: String) async {
		guard hasOlderMessages[conversationId] == true,
					let oldest = messages[conversationId]?.first,
					let oldestTimestamp = oldest.createdAt as Date? else { return }
		
		do {
			let snapshot = try await db.collection("messages")
				.whereField("conversationId", isEqualTo: conversationId)
				.order(by: "createdAt", descending: true)
				.whereField("createdAt", isLessThan: Timestamp(date: oldestTimestamp))
				.limit(to: olderPageSize)
				.getDocuments()
			
			let older = snapshot.documents.compactMap { doc in
				Message.fromFirestore(id: doc.documentID, data: doc.data())
			}.reversed() as [Message]
			
			messages[conversationId]?.insert(contentsOf: older, at: 0)
			hasOlderMessages[conversationId] = snapshot.documents.count == olderPageSize
			print("✅ Loaded \(older.count) older messages for conversation \(conversationId)")
		} catch {
			self.error = AppError.from(error)
			print("❌ Failed to load older messages: \(error.localizedDescription)")
		}
	}
	
	// NOTE: Message cleanup (deleting messages older than 90 days) is handled
	// by a scheduled Cloud Function — never run bulk deletes from the client.
	
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
