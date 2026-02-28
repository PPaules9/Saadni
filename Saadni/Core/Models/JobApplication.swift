import Foundation

/// Represents a job application submitted by a user
struct JobApplication: Codable, Identifiable, Hashable {
    // MARK: - Identification
    let id: String

    // MARK: - References
    let serviceId: String       // Which service this application is for
    let applicantId: String     // User who applied
    var applicantName: String
    var applicantPhotoURL: String?

    // MARK: - Application Details
    var status: JobApplicationStatus
    var appliedAt: Date

    // Optional fields
    var coverMessage: String?      // Why they want the job
    var proposedPrice: Double?     // Counter-offer price

    // MARK: - Response from Service Provider
    var responseMessage: String?
    var respondedAt: Date?

    // MARK: - Initializers

    /// Create new application
    init(
        serviceId: String,
        applicantId: String,
        applicantName: String,
        applicantPhotoURL: String? = nil,
        coverMessage: String? = nil,
        proposedPrice: Double? = nil
    ) {
        self.id = UUID().uuidString
        self.serviceId = serviceId
        self.applicantId = applicantId
        self.applicantName = applicantName
        self.applicantPhotoURL = applicantPhotoURL
        self.status = .pending
        self.appliedAt = Date()
        self.coverMessage = coverMessage
        self.proposedPrice = proposedPrice
        self.responseMessage = nil
        self.respondedAt = nil
    }

    /// Full initializer (for Firestore decoding)
    init(
        id: String,
        serviceId: String,
        applicantId: String,
        applicantName: String,
        applicantPhotoURL: String?,
        status: JobApplicationStatus,
        appliedAt: Date,
        coverMessage: String?,
        proposedPrice: Double?,
        responseMessage: String?,
        respondedAt: Date?
    ) {
        self.id = id
        self.serviceId = serviceId
        self.applicantId = applicantId
        self.applicantName = applicantName
        self.applicantPhotoURL = applicantPhotoURL
        self.status = status
        self.appliedAt = appliedAt
        self.coverMessage = coverMessage
        self.proposedPrice = proposedPrice
        self.responseMessage = responseMessage
        self.respondedAt = respondedAt
    }
}

// MARK: - Job Application Status
enum JobApplicationStatus: String, Codable {
    case pending = "pending"        // Waiting for provider response
    case accepted = "accepted"      // Provider accepted
    case rejected = "rejected"      // Provider rejected
    case withdrawn = "withdrawn"    // Applicant cancelled
}

// MARK: - Computed Properties
extension JobApplication {
    var isPending: Bool {
        return status == .pending
    }

    var isAccepted: Bool {
        return status == .accepted
    }

    var statusDisplayText: String {
        switch status {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .withdrawn: return "Withdrawn"
        }
    }

    var statusColor: String {
        switch status {
        case .pending: return "blue"
        case .accepted: return "green"
        case .rejected: return "red"
        case .withdrawn: return "gray"
        }
    }
}
