import Foundation
import FirebaseFirestore

// MARK: - Notification Model

struct Notification: Identifiable, Codable {
    // MARK: - Core Properties
    @DocumentID var id: String?
    let userId: String
    let type: NotificationType
    let title: String
    let body: String

    // MARK: - Payload Data
    let payload: NotificationPayload?

    // MARK: - Metadata
    let timestamp: Date
    var read: Bool = false
    var readAt: Date?
    var deleted: Bool = false
    var deletedAt: Date?

    // MARK: - Display Properties
    let priority: NotificationPriority
    let actionable: Bool
    let expiresAt: Date?
    let category: NotificationCategory

    // MARK: - Initializer
    init(
        userId: String,
        type: NotificationType,
        title: String,
        body: String,
        payload: NotificationPayload? = nil,
        timestamp: Date = Date(),
        priority: NotificationPriority,
        category: NotificationCategory,
        expiresAt: Date? = nil
    ) {
        self.userId = userId
        self.type = type
        self.title = title
        self.body = body
        self.payload = payload
        self.timestamp = timestamp
        self.priority = priority
        self.actionable = type.isActionable
        self.category = category
        // Default expiry: 90 days
        self.expiresAt = expiresAt ?? Calendar.current.date(byAdding: .day, value: 90, to: timestamp)
    }

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case type
        case title
        case body
        case payload
        case timestamp
        case read
        case readAt
        case deleted
        case deletedAt
        case priority
        case actionable
        case expiresAt
        case category
    }

    // MARK: - Custom Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Try to decode using @DocumentID pattern
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        }

        userId = try container.decode(String.self, forKey: .userId)
        type = try container.decode(NotificationType.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        payload = try container.decodeIfPresent(NotificationPayload.self, forKey: .payload)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        read = try container.decodeIfPresent(Bool.self, forKey: .read) ?? false
        readAt = try container.decodeIfPresent(Date.self, forKey: .readAt)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted) ?? false
        deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        priority = try container.decode(NotificationPriority.self, forKey: .priority)
        actionable = try container.decodeIfPresent(Bool.self, forKey: .actionable) ?? true
        expiresAt = try container.decodeIfPresent(Date.self, forKey: .expiresAt)
        category = try container.decode(NotificationCategory.self, forKey: .category)
    }

    // MARK: - Computed Properties
    var isRead: Bool {
        read
    }

    var isUnread: Bool {
        !read
    }

    var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }

    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)

        if interval < 60 {
            return "now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

// MARK: - Notification Payload

struct NotificationPayload: Codable {
    // Job/Service Related
    let jobId: String?
    let jobName: String?
    let serviceId: String?
    let serviceName: String?

    // Application Related
    let applicationId: String?
    let status: String?

    // User Related
    let seekerId: String?
    let seekerName: String?
    let seekerRating: Double?

    let providerId: String?
    let providerName: String?
    let providerRating: Double?

    // Message Related
    let conversationId: String?
    let senderId: String?
    let senderName: String?
    let messagePreview: String?

    // Financial Related
    let amount: Double?
    let currency: String?
    let transactionId: String?

    // Review Related
    let reviewId: String?
    let rating: Int?
    let reviewText: String?

    // Other
    let scheduledTime: Date?
    let expiryDate: Date?
    let currentRating: Double?
    let previousRating: Double?
    let estimatedTime: String?
    let category: String?
    let actionUrl: String?

    enum CodingKeys: String, CodingKey {
        case jobId, jobName, serviceId, serviceName
        case applicationId, status
        case seekerId, seekerName, seekerRating
        case providerId, providerName, providerRating
        case conversationId, senderId, senderName, messagePreview
        case amount, currency, transactionId
        case reviewId, rating, reviewText
        case scheduledTime, expiryDate
        case currentRating, previousRating
        case estimatedTime, category, actionUrl
    }
}
