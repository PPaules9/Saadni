//
//  AnalyticsEvent.swift
//  GoodShift
//

import Foundation

enum AnalyticsEvent {

    // MARK: - Auth
    case signedUp
    case loggedIn
    case loggedOut
    case guestSignIn

    // MARK: - Onboarding
    case onboardingCompleted
    case roleSelected(role: String)
    case profileSetupCompleted(role: String, skipped: Bool)

    // MARK: - Job Creation Funnel
    case jobCreationStarted(category: String)
    case jobCreationStepCompleted(step: Int, category: String)
    case jobCreationAbandoned(lastStep: Int, category: String)
    case jobPublished(category: String, price: Double, city: String, numDates: Int)

    // MARK: - Core Transaction Funnel
    case jobViewed(jobId: String, category: String, price: Double)
    case jobApplied(jobId: String, category: String)
    case applicationAccepted(jobId: String, numApplicants: Int)
    case applicationRejected(jobId: String)
    case jobCompleted(jobId: String, category: String, price: Double)

    // MARK: - Reviews
    case reviewSubmitted(rating: Int, role: String)

    // MARK: - Messaging
    case chatOpened
    case messageSent

    // MARK: - Wallet
    case walletViewed

    // MARK: - Search
    case searchPerformed(query: String, resultsCount: Int, category: String?)

    // MARK: - Profile
    case roleSwitched(to: String)

    // MARK: - Errors
    case applicationFailed(errorType: String)
    case jobPublishFailed(step: Int, error: String)

    // MARK: - Name

    var name: String {
        switch self {
        case .signedUp:                  return "signed_up"
        case .loggedIn:                  return "logged_in"
        case .loggedOut:                 return "logged_out"
        case .guestSignIn:               return "guest_sign_in"
        case .onboardingCompleted:       return "onboarding_completed"
        case .roleSelected:              return "role_selected"
        case .profileSetupCompleted:     return "profile_setup_completed"
        case .jobCreationStarted:        return "job_creation_started"
        case .jobCreationStepCompleted:  return "job_creation_step_completed"
        case .jobCreationAbandoned:      return "job_creation_abandoned"
        case .jobPublished:              return "job_published"
        case .jobViewed:                 return "job_viewed"
        case .jobApplied:                return "job_applied"
        case .applicationAccepted:       return "application_accepted"
        case .applicationRejected:       return "application_rejected"
        case .jobCompleted:              return "job_completed"
        case .reviewSubmitted:           return "review_submitted"
        case .chatOpened:                return "chat_opened"
        case .messageSent:               return "message_sent"
        case .walletViewed:              return "wallet_viewed"
        case .searchPerformed:           return "search_performed"
        case .roleSwitched:              return "role_switched"
        case .applicationFailed:         return "application_failed"
        case .jobPublishFailed:          return "job_publish_failed"
        }
    }

    // MARK: - Properties

    var properties: [String: Any] {
        switch self {
        case .roleSelected(let role):
            return ["role": role]
        case .profileSetupCompleted(let role, let skipped):
            return ["role": role, "skipped": skipped]
        case .jobCreationStarted(let category):
            return ["category": category]
        case .jobCreationStepCompleted(let step, let category):
            return ["step": step, "category": category]
        case .jobCreationAbandoned(let lastStep, let category):
            return ["last_step": lastStep, "category": category]
        case .jobPublished(let category, let price, let city, let numDates):
            return ["category": category, "price": price, "city": city, "num_dates": numDates]
        case .jobViewed(let jobId, let category, let price):
            return ["job_id": jobId, "category": category, "price": price]
        case .jobApplied(let jobId, let category):
            return ["job_id": jobId, "category": category]
        case .applicationAccepted(let jobId, let numApplicants):
            return ["job_id": jobId, "num_applicants": numApplicants]
        case .applicationRejected(let jobId):
            return ["job_id": jobId]
        case .jobCompleted(let jobId, let category, let price):
            return ["job_id": jobId, "category": category, "price": price]
        case .reviewSubmitted(let rating, let role):
            return ["rating": rating, "reviewer_role": role]
        case .searchPerformed(let query, let resultsCount, let category):
            var props: [String: Any] = ["query": query, "results_count": resultsCount]
            if let cat = category { props["category"] = cat }
            return props
        case .roleSwitched(let role):
            return ["to_role": role]
        case .applicationFailed(let errorType):
            return ["error_type": errorType]
        case .jobPublishFailed(let step, let error):
            return ["step": step, "error": error]
        default:
            return [:]
        }
    }
}
