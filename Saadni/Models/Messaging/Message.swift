//
//  Message.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
	let id: String
	let conversationId: String
	let senderId: String
	let senderName: String
	let senderPhotoURL: String?  // Denormalized for quick display
	let content: String
	let createdAt: Date
	var isRead: Bool
	let participantIds: [String]
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case conversationId = "conversationId"
		case senderId = "senderId"
		case senderName = "senderName"
		case senderPhotoURL = "senderPhotoURL"
		case content = "content"
		case createdAt = "createdAt"
		case isRead = "isRead"
		case participantIds = "participantIds"
	}
	
	// MARK: - Firestore Conversion
	
	/// Convert Message to Firestore dictionary
	func toFirestore() -> [String: Any] {
		var dict: [String: Any] = [
			"conversationId": conversationId,
			"senderId": senderId,
			"senderName": senderName,
			"content": content,
			"createdAt": Timestamp(date: createdAt),
			"isRead": isRead,
			"participantIds": participantIds
		]
		
		if let photoURL = senderPhotoURL {
			dict["senderPhotoURL"] = photoURL
		}
		
		return dict
	}
	
	/// Create Message from Firestore document
	static func fromFirestore(id: String, data: [String: Any]) -> Message? {
		guard
			let conversationId = data["conversationId"] as? String,
			let senderId = data["senderId"] as? String,
			let content = data["content"] as? String,
			let createdAtTimestamp = data["createdAt"] as? Timestamp,
			let isRead = data["isRead"] as? Bool,
			let participantIds = data["participantIds"] as? [String]
		else {
			return nil
		}
		
		// Optional fields for backward compatibility
		let senderName = data["senderName"] as? String ?? "User"
		let senderPhotoURL = data["senderPhotoURL"] as? String
		
		return Message(
			id: id,
			conversationId: conversationId,
			senderId: senderId,
			senderName: senderName,
			senderPhotoURL: senderPhotoURL,
			content: content,
			createdAt: createdAtTimestamp.dateValue(),
			isRead: isRead,
			participantIds: participantIds
		)
	}
	
	// MARK: - Computed Properties
	
	/// Check if message was sent by current user
	func isSentByCurrentUser(userId: String) -> Bool {
		return senderId == userId
	}
	
	/// Format creation time for display
	var formattedTime: String {
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.dateStyle = .none
		return formatter.string(from: createdAt)
	}
	
	/// Check if message is older than 90 days
	var isExpired: Bool {
		let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()
		return createdAt < ninetyDaysAgo
	}
}
