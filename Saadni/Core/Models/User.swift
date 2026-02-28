import Foundation
import FirebaseAuth

/// Represents a Saadni user
struct User: Codable, Identifiable, Hashable {
    // MARK: - Identification
    let id: String  // Firebase UID

    // MARK: - Profile Information
    var email: String
    var displayName: String?
    var photoURL: String?
    var phoneNumber: String?

    // MARK: - Metadata
    var createdAt: Date
    var lastLoginAt: Date

    // MARK: - User Type (for future role-based features)
    var isServiceProvider: Bool  // Can post jobs
    var isJobSeeker: Bool        // Can apply to jobs

    // MARK: - Statistics (for future features)
    var totalJobsPosted: Int
    var totalJobsCompleted: Int
    var rating: Double?

    // MARK: - Initializers

    /// Create from Firebase Auth user
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL?.absoluteString
        self.phoneNumber = firebaseUser.phoneNumber
        self.createdAt = firebaseUser.metadata.creationDate ?? Date()
        self.lastLoginAt = Date()
        self.isServiceProvider = true
        self.isJobSeeker = true
        self.totalJobsPosted = 0
        self.totalJobsCompleted = 0
        self.rating = nil
    }

    /// Full initializer (for Firestore decoding)
    init(
        id: String,
        email: String,
        displayName: String?,
        photoURL: String?,
        phoneNumber: String?,
        createdAt: Date,
        lastLoginAt: Date,
        isServiceProvider: Bool,
        isJobSeeker: Bool,
        totalJobsPosted: Int,
        totalJobsCompleted: Int,
        rating: Double?
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
        self.isServiceProvider = isServiceProvider
        self.isJobSeeker = isJobSeeker
        self.totalJobsPosted = totalJobsPosted
        self.totalJobsCompleted = totalJobsCompleted
        self.rating = rating
    }
}

// MARK: - Computed Properties
extension User {
    var initials: String {
        if let name = displayName {
            let components = name.components(separatedBy: " ")
            let initials = components.compactMap { $0.first }.prefix(2)
            return String(initials).uppercased()
        }
        return String(email.prefix(2)).uppercased()
    }
}
