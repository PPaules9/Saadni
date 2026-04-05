import Foundation

// MARK: - Notification Type Enum

enum NotificationType: String, Codable, CaseIterable {
    // MARK: - NeedWorker (Job Seeker) Types
    case applicationStatus = "application_status"
    case newMessageFromProvider = "new_message_provider"
    case jobReminder = "job_reminder"
    case reviewPostedByProvider = "review_posted_provider"
    case jobCancelledByProvider = "job_cancelled"
    case earningReceived = "earning_received"
    case topupSuccess = "topup_success"
    case withdrawalProcessed = "withdrawal_processed"
    case matchingJob = "matching_job"
    case applicationWithdrawnAck = "application_withdrawn_ack"

    // MARK: - JobProvider (Service Provider) Types
    case newApplicationReceived = "new_application"
    case newMessageFromSeeker = "new_message_seeker"
    case applicationAcceptedBySeeker = "application_accepted"
    case applicationWithdrawnBySeeker = "application_withdrawn"
    case jobStartsSoon = "job_starts_soon"
    case paymentReceived = "payment_received"
    case reviewPostedBySeeker = "review_posted_seeker"
    case jobExpiringSoon = "job_expiring_soon"
    case lowRatingAlert = "low_rating_alert"
    case withdrawalPending = "withdrawal_pending"

    // MARK: - Properties

    var displayName: String {
        switch self {
        case .applicationStatus:
            return "Application Status Update"
        case .newMessageFromProvider:
            return "New Message from Provider"
        case .jobReminder:
            return "Job Reminder"
        case .reviewPostedByProvider:
            return "Review from Provider"
        case .jobCancelledByProvider:
            return "Job Cancelled"
        case .earningReceived:
            return "Earning Received"
        case .topupSuccess:
            return "Top-up Successful"
        case .withdrawalProcessed:
            return "Withdrawal Processed"
        case .matchingJob:
            return "New Job Available"
        case .applicationWithdrawnAck:
            return "Application Withdrawn"

        case .newApplicationReceived:
            return "New Application"
        case .newMessageFromSeeker:
            return "New Message from Seeker"
        case .applicationAcceptedBySeeker:
            return "Application Accepted"
        case .applicationWithdrawnBySeeker:
            return "Application Withdrawn"
        case .jobStartsSoon:
            return "Job Starting Soon"
        case .paymentReceived:
            return "Payment Received"
        case .reviewPostedBySeeker:
            return "Review from Seeker"
        case .jobExpiringSoon:
            return "Job Expiring Soon"
        case .lowRatingAlert:
            return "Rating Alert"
        case .withdrawalPending:
            return "Withdrawal Pending"
        }
    }

    var category: NotificationCategory {
        switch self {
        case .applicationStatus, .newApplicationReceived, .applicationAcceptedBySeeker, .applicationWithdrawnBySeeker, .applicationWithdrawnAck:
            return .applications
        case .newMessageFromProvider, .newMessageFromSeeker:
            return .messages
        case .jobReminder, .jobStartsSoon, .jobCancelledByProvider, .jobExpiringSoon:
            return .jobs
        case .reviewPostedByProvider, .reviewPostedBySeeker:
            return .reviews
        case .earningReceived, .paymentReceived, .topupSuccess, .withdrawalProcessed, .withdrawalPending:
            return .earnings
        case .matchingJob:
            return .matching
        case .lowRatingAlert:
            return .ratings
        }
    }

    var priority: NotificationPriority {
        switch self {
        case .newApplicationReceived, .applicationAcceptedBySeeker, .paymentReceived, .earningReceived, .reviewPostedByProvider, .reviewPostedBySeeker:
            return .high
        case .applicationStatus, .newMessageFromProvider, .newMessageFromSeeker, .withdrawalProcessed, .withdrawalPending:
            return .high
        case .jobReminder, .jobStartsSoon, .jobCancelledByProvider:
            return .medium
        case .topupSuccess, .matchingJob, .jobExpiringSoon:
            return .low
        case .applicationWithdrawnBySeeker, .applicationWithdrawnAck, .lowRatingAlert:
            return .medium
        }
    }

    var isActionable: Bool {
        switch self {
        case .jobReminder, .jobExpiringSoon, .matchingJob, .lowRatingAlert:
            return false
        default:
            return true
        }
    }
}

// MARK: - Notification Category

enum NotificationCategory: String, Codable, CaseIterable {
    case applications
    case messages
    case jobs
    case reviews
    case earnings
    case matching
    case ratings

    var displayName: String {
        switch self {
        case .applications:
            return "Applications"
        case .messages:
            return "Messages"
        case .jobs:
            return "Jobs"
        case .reviews:
            return "Reviews"
        case .earnings:
            return "Earnings"
        case .matching:
            return "Matching Jobs"
        case .ratings:
            return "Ratings"
        }
    }
}

// MARK: - Notification Priority

enum NotificationPriority: String, Codable {
    case high
    case medium
    case low
}
