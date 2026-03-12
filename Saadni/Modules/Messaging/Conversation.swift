//
//  Conversation.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

struct Conversation: Identifiable, Codable {
    let id: String
    let participantIds: [String]
    let lastMessage: String
    let lastMessageTime: Date
    let lastMessageSenderId: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case participantIds = "participantIds"
        case lastMessage = "lastMessage"
        case lastMessageTime = "lastMessageTime"
        case lastMessageSenderId = "lastMessageSenderId"
    }

    // MARK: - Firestore Conversion

    /// Convert Conversation to Firestore dictionary
    func toFirestore() -> [String: Any] {
        return [
            "participantIds": participantIds,
            "lastMessage": lastMessage,
            "lastMessageTime": Timestamp(date: lastMessageTime),
            "lastMessageSenderId": lastMessageSenderId
        ]
    }

    /// Create Conversation from Firestore document
    static func fromFirestore(id: String, data: [String: Any]) -> Conversation? {
        guard
            let participantIds = data["participantIds"] as? [String],
            let lastMessage = data["lastMessage"] as? String,
            let lastMessageTimeTimestamp = data["lastMessageTime"] as? Timestamp,
            let lastMessageSenderId = data["lastMessageSenderId"] as? String
        else {
            return nil
        }

        return Conversation(
            id: id,
            participantIds: participantIds,
            lastMessage: lastMessage,
            lastMessageTime: lastMessageTimeTimestamp.dateValue(),
            lastMessageSenderId: lastMessageSenderId
        )
    }

    // MARK: - Computed Properties

    /// Get the other participant's ID (for one-on-one conversations)
    func otherParticipantId(currentUserId: String) -> String? {
        return participantIds.first { $0 != currentUserId }
    }

    /// Format last message time for display
    var formattedLastMessageTime: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(lastMessageTime) {
            formatter.timeStyle = .short
            formatter.dateStyle = .none
        } else if calendar.isDateInYesterday(lastMessageTime) {
            return "Yesterday"
        } else {
            formatter.timeStyle = .none
            formatter.dateStyle = .short
        }

        return formatter.string(from: lastMessageTime)
    }

    /// Truncate last message for preview
    var lastMessagePreview: String {
        if lastMessage.count > 50 {
            return String(lastMessage.prefix(50)) + "..."
        }
        return lastMessage
    }

    /// Check if last message is from current user
    func isLastMessageFromUser(_ userId: String) -> Bool {
        return lastMessageSenderId == userId
    }
}
