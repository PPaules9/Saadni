import Foundation

// MARK: - Notification Preferences Model

struct NotificationPreferences: Codable {
    // MARK: - Global Settings
    var notificationsEnabled: Bool = true

    // MARK: - Category Settings
    var applications: CategoryPreference = CategoryPreference()
    var messages: MessagePreference = MessagePreference()
    var jobReminders: ReminderPreference = ReminderPreference()
    var reviews: CategoryPreference = CategoryPreference()
    var earnings: CategoryPreference = CategoryPreference()
    var matchingJobs: MatchingJobPreference = MatchingJobPreference()

    // MARK: - Quiet Hours
    var quietHoursEnabled: Bool = false
    var quietHoursStart: String = "22:00"
    var quietHoursEnd: String = "08:00"
    var quietHoursAllowUrgent: Bool = true

    // MARK: - Do Not Disturb
    var doNotDisturb: Bool = false

    // MARK: - Metadata
    var updatedAt: Date = Date()

    enum CodingKeys: String, CodingKey {
        case notificationsEnabled
        case applications, messages, jobReminders, reviews, earnings, matchingJobs
        case quietHoursEnabled, quietHoursStart, quietHoursEnd, quietHoursAllowUrgent
        case doNotDisturb
        case updatedAt
    }
}

// MARK: - Category Preference

struct CategoryPreference: Codable {
    var enabled: Bool = true
    var sound: Bool = true
    var badge: Bool = true

    enum CodingKeys: String, CodingKey {
        case enabled, sound, badge
    }
}

// MARK: - Message Preference

struct MessagePreference: Codable {
    var enabled: Bool = true
    var sound: Bool = true
    var badge: Bool = true
    var preview: MessagePreviewMode = .full

    enum CodingKeys: String, CodingKey {
        case enabled, sound, badge, preview
    }

    enum MessagePreviewMode: String, Codable {
        case full
        case summary
        case none
    }
}

// MARK: - Reminder Preference

struct ReminderPreference: Codable {
    var enabled: Bool = true
    var sound: Bool = false
    var badge: Bool = true
    var timeBefore: Int = 1440 // minutes (1 day)

    enum CodingKeys: String, CodingKey {
        case enabled, sound, badge, timeBefore
    }
}

// MARK: - Matching Job Preference

struct MatchingJobPreference: Codable {
    var enabled: Bool = false
    var sound: Bool = false
    var badge: Bool = false
    var frequency: FrequencyMode = .daily

    enum CodingKeys: String, CodingKey {
        case enabled, sound, badge, frequency
    }

    enum FrequencyMode: String, Codable {
        case instant
        case daily
        case weekly
    }
}
