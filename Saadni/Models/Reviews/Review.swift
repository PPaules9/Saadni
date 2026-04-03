//
//  Review.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

// MARK: - Enums

enum ReviewerRole: String, Codable, CaseIterable {
    case provider = "provider"    // Service provider (job poster)
    case seeker = "seeker"        // Job seeker (applicant)
}

// MARK: - Review Model

struct Review: Codable, Identifiable, Hashable {
    let id: String

    // MARK: - Core Review Data
    let serviceId: String
    let reviewerId: String        // Who wrote this review
    let revieweeId: String        // Who is being reviewed
    let reviewerRole: ReviewerRole

    var rating: Int               // 1-5 stars
    var comment: String?          // Optional text review

    let createdAt: Date
    var isEdited: Bool = false
    var lastEditedAt: Date?

    // MARK: - Denormalized Data (for display without additional queries)
    var reviewerName: String?
    var reviewerPhotoURL: String?
    var revieweeName: String?
    var serviceName: String?

    // MARK: - Initializers

    /// Create a new review
    init(
        serviceId: String,
        reviewerId: String,
        revieweeId: String,
        reviewerRole: ReviewerRole,
        rating: Int,
        comment: String? = nil,
        reviewerName: String? = nil,
        reviewerPhotoURL: String? = nil,
        revieweeName: String? = nil,
        serviceName: String? = nil
    ) {
        self.id = UUID().uuidString
        self.serviceId = serviceId
        self.reviewerId = reviewerId
        self.revieweeId = revieweeId
        self.reviewerRole = reviewerRole
        self.rating = rating
        self.comment = comment
        self.createdAt = Date()
        self.isEdited = false
        self.lastEditedAt = nil
        self.reviewerName = reviewerName
        self.reviewerPhotoURL = reviewerPhotoURL
        self.revieweeName = revieweeName
        self.serviceName = serviceName
    }

    /// Full initializer (for Firebase decoding)
    init(
        id: String,
        serviceId: String,
        reviewerId: String,
        revieweeId: String,
        reviewerRole: ReviewerRole,
        rating: Int,
        comment: String? = nil,
        createdAt: Date,
        isEdited: Bool = false,
        lastEditedAt: Date? = nil,
        reviewerName: String? = nil,
        reviewerPhotoURL: String? = nil,
        revieweeName: String? = nil,
        serviceName: String? = nil
    ) {
        self.id = id
        self.serviceId = serviceId
        self.reviewerId = reviewerId
        self.revieweeId = revieweeId
        self.reviewerRole = reviewerRole
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
        self.isEdited = isEdited
        self.lastEditedAt = lastEditedAt
        self.reviewerName = reviewerName
        self.reviewerPhotoURL = reviewerPhotoURL
        self.revieweeName = revieweeName
        self.serviceName = serviceName
    }
}

// MARK: - Computed Properties

extension Review {
    /// Star rating as emoji string
    var ratingStars: String {
        String(repeating: "⭐", count: rating)
    }

    /// Human-readable date (e.g., "2 days ago")
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }

    /// Whether reviewer was the service provider
    var isProviderReview: Bool {
        reviewerRole == .provider
    }

    /// Whether reviewer was the job seeker
    var isSeekerReview: Bool {
        reviewerRole == .seeker
    }
}

// MARK: - Firestore Conversion

extension Review {
    /// Convert to Firestore dictionary
    func toFirestore() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "serviceId": serviceId,
            "reviewerId": reviewerId,
            "revieweeId": revieweeId,
            "reviewerRole": reviewerRole.rawValue,
            "rating": rating,
            "createdAt": Timestamp(date: createdAt),
            "isEdited": isEdited
        ]

        // Optional fields
        if let comment = comment {
            dict["comment"] = comment
        }
        if let lastEditedAt = lastEditedAt {
            dict["lastEditedAt"] = Timestamp(date: lastEditedAt)
        }
        if let reviewerName = reviewerName {
            dict["reviewerName"] = reviewerName
        }
        if let reviewerPhotoURL = reviewerPhotoURL {
            dict["reviewerPhotoURL"] = reviewerPhotoURL
        }
        if let revieweeName = revieweeName {
            dict["revieweeName"] = revieweeName
        }
        if let serviceName = serviceName {
            dict["serviceName"] = serviceName
        }

        return dict
    }

    /// Create from Firestore data
    static func fromFirestore(id: String, data: [String: Any]) throws -> Review {
        guard let serviceId = data["serviceId"] as? String,
              let reviewerId = data["reviewerId"] as? String,
              let revieweeId = data["revieweeId"] as? String,
              let roleRaw = data["reviewerRole"] as? String,
              let role = ReviewerRole(rawValue: roleRaw),
              let rating = data["rating"] as? Int
        else {
            throw NSError(domain: "FirestoreDecoding", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing required Review fields"])
        }

        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        let isEdited = data["isEdited"] as? Bool ?? false
        let lastEditedAt = (data["lastEditedAt"] as? Timestamp)?.dateValue()
        let comment = data["comment"] as? String
        let reviewerName = data["reviewerName"] as? String
        let reviewerPhotoURL = data["reviewerPhotoURL"] as? String
        let revieweeName = data["revieweeName"] as? String
        let serviceName = data["serviceName"] as? String

        return Review(
            id: id,
            serviceId: serviceId,
            reviewerId: reviewerId,
            revieweeId: revieweeId,
            reviewerRole: role,
            rating: rating,
            comment: comment,
            createdAt: createdAt,
            isEdited: isEdited,
            lastEditedAt: lastEditedAt,
            reviewerName: reviewerName,
            reviewerPhotoURL: reviewerPhotoURL,
            revieweeName: revieweeName,
            serviceName: serviceName
        )
    }
}

// MARK: - Mock Data

extension Review {
    static let sampleData: [Review] = [
        Review(
            serviceId: "service-1",
            reviewerId: "user-2",
            revieweeId: "user-1",
            reviewerRole: .seeker,
            rating: 5,
            comment: "Excellent work! Very professional and on time.",
            reviewerName: "Ahmed Hassan",
            reviewerPhotoURL: nil,
            revieweeName: "Fatima Khalil",
            serviceName: "Home Cleaning Service"
        ),
        Review(
            serviceId: "service-1",
            reviewerId: "user-1",
            revieweeId: "user-2",
            reviewerRole: .provider,
            rating: 4,
            comment: "Great communication, easy to work with.",
            reviewerName: "Fatima Khalil",
            reviewerPhotoURL: nil,
            revieweeName: "Ahmed Hassan",
            serviceName: "Home Cleaning Service"
        ),
        Review(
            serviceId: "service-2",
            reviewerId: "user-3",
            revieweeId: "user-4",
            reviewerRole: .seeker,
            rating: 5,
            comment: "Perfect! Exactly what I needed.",
            reviewerName: "Mohammed Saleh",
            reviewerPhotoURL: nil,
            revieweeName: "Layla Ahmed",
            serviceName: "Furniture Assembly"
        )
    ]
}
