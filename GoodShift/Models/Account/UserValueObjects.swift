//
//  UserValueObjects.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Supporting Enums & Structures

enum VerificationLevel: String, Codable {
    case unverified
    case bronze     // Email verified
    case silver     // Email + Phone verified
    case gold       // Email + Phone + ID verified
}

enum AccountStatus: String, Codable {
    case active
    case suspended
    case banned
    case pendingVerification
}

struct Badge: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let earnedAt: Date
    let icon: String?  // SF Symbol name
}
