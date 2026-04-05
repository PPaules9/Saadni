//
//  Transaction.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

// MARK: - Enums

enum TransactionType: String, Codable, CaseIterable {
    case earning = "earning"         // Completed service payment
    case withdrawal = "withdrawal"   // User withdrew funds
    case topUp = "top_up"           // User added funds
    case fee = "fee"                // Platform fee
}

// MARK: - Transaction Model

struct Transaction: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let amount: Double              // Positive for credits, negative for debits
    let type: TransactionType
    let createdAt: Date
    let description: String

    // Optional references
    var serviceId: String?          // Link to service for earnings
    var serviceName: String?        // Denormalized for display

    // MARK: - Initializers

    init(
        userId: String,
        amount: Double,
        type: TransactionType,
        description: String,
        serviceId: String? = nil,
        serviceName: String? = nil
    ) {
        self.id = UUID().uuidString
        self.userId = userId
        self.amount = amount
        self.type = type
        self.createdAt = Date()
        self.description = description
        self.serviceId = serviceId
        self.serviceName = serviceName
    }

    /// Full initializer (for Firebase decoding)
    init(
        id: String,
        userId: String,
        amount: Double,
        type: TransactionType,
        createdAt: Date,
        description: String,
        serviceId: String? = nil,
        serviceName: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.type = type
        self.createdAt = createdAt
        self.description = description
        self.serviceId = serviceId
        self.serviceName = serviceName
    }
}

// MARK: - Computed Properties

extension Transaction {
    /// Formatted amount for display
    var formattedAmount: String {
        let sign = amount >= 0 ? "+" : ""
        return "\(sign)\(Currency.current.symbol) \(String(format: "%.2f", abs(amount)))"
    }

    /// Color based on transaction type
    var amountColor: Color {
        switch type {
        case .earning, .topUp:
            return .green
        case .withdrawal, .fee:
            return .red
        }
    }

    /// Icon for transaction type
    var icon: String {
        switch type {
        case .earning:
            return "briefcase.fill"
        case .withdrawal:
            return "arrow.down.circle.fill"
        case .topUp:
            return "arrow.up.circle.fill"
        case .fee:
            return "creditcard.fill"
        }
    }

    /// Human-readable date
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

// MARK: - Firestore Conversion

extension Transaction {
    /// Convert to Firestore dictionary
    func toFirestore() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "userId": userId,
            "amount": amount,
            "type": type.rawValue,
            "createdAt": Timestamp(date: createdAt),
            "description": description
        ]

        if let serviceId = serviceId {
            dict["serviceId"] = serviceId
        }
        if let serviceName = serviceName {
            dict["serviceName"] = serviceName
        }

        return dict
    }

    /// Create from Firestore data
    static func fromFirestore(id: String, data: [String: Any]) throws -> Transaction {
        guard let userId = data["userId"] as? String,
              let amount = data["amount"] as? Double,
              let typeRaw = data["type"] as? String,
              let type = TransactionType(rawValue: typeRaw),
              let description = data["description"] as? String
        else {
            throw NSError(domain: "FirestoreDecoding", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing required Transaction fields"])
        }

        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        let serviceId = data["serviceId"] as? String
        let serviceName = data["serviceName"] as? String

        return Transaction(
            id: id,
            userId: userId,
            amount: amount,
            type: type,
            createdAt: createdAt,
            description: description,
            serviceId: serviceId,
            serviceName: serviceName
        )
    }
}

// MARK: - Mock Data

extension Transaction {
    static let sampleData: [Transaction] = [
        Transaction(
            userId: "user-1",
            amount: 250.0,
            type: .earning,
            description: "Payment for: Home Cleaning Service",
            serviceId: "service-1",
            serviceName: "Home Cleaning Service"
        ),
        Transaction(
            userId: "user-1",
            amount: 400.0,
            type: .earning,
            description: "Payment for: Furniture Assembly",
            serviceId: "service-2",
            serviceName: "Furniture Assembly"
        ),
        Transaction(
            userId: "user-1",
            amount: -200.0,
            type: .withdrawal,
            description: "Withdrawal to bank account"
        ),
        Transaction(
            userId: "user-1",
            amount: 500.0,
            type: .topUp,
            description: "Top up wallet via credit card"
        )
    ]
}
