//
//  TypingIndicator.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

struct TypingIndicator: Identifiable, Codable {
    let id: String
    let conversationId: String
    let userId: String
    let isTyping: Bool
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case conversationId = "conversationId"
        case userId = "userId"
        case isTyping = "isTyping"
        case timestamp = "timestamp"
    }

    // MARK: - Firestore Conversion

    /// Convert TypingIndicator to Firestore dictionary
    func toFirestore() -> [String: Any] {
        return [
            "conversationId": conversationId,
            "userId": userId,
            "isTyping": isTyping,
            "timestamp": Timestamp(date: timestamp)
        ]
    }

    /// Create TypingIndicator from Firestore document
    static func fromFirestore(id: String, data: [String: Any]) -> TypingIndicator? {
        guard
            let conversationId = data["conversationId"] as? String,
            let userId = data["userId"] as? String,
            let isTyping = data["isTyping"] as? Bool,
            let timestampValue = data["timestamp"] as? Timestamp
        else {
            return nil
        }

        return TypingIndicator(
            id: id,
            conversationId: conversationId,
            userId: userId,
            isTyping: isTyping,
            timestamp: timestampValue.dateValue()
        )
    }

    // MARK: - Computed Properties

    /// Check if typing indicator has expired (older than 5 seconds)
    var isExpired: Bool {
        let fiveSecondsAgo = Date().addingTimeInterval(-5)
        return timestamp < fiveSecondsAgo
    }

    /// Check if currently typing and not expired
    var isActive: Bool {
        return isTyping && !isExpired
    }

    /// Time since typing was updated
    var timeSinceUpdate: TimeInterval {
        return Date().timeIntervalSince(timestamp)
    }
}
