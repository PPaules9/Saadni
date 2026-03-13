//
//  User.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - User Model

struct User: Codable, Identifiable, Hashable {
    // MARK: - Identification
    let id: String  // Firebase UID

    // MARK: - Profile Information
    var email: String
    var displayName: String?
    var photoURL: String?
    var phoneNumber: String?

    // MARK: - Location & Services
    var city: String?
    var locationCoordinates: GeoPoint?  // Firebase location type
    var bio: String?  // Service Providers describe their skills
    var offeredServices: [String] = []  // e.g., ["Plumbing", "Painting"]

    // MARK: - User Type (Dual-Role Support)
    var isServiceProvider: Bool = false  // Can post services
    var isJobSeeker: Bool = false        // Can apply to jobs

    // MARK: - Verification & Trust
    var isEmailVerified: Bool = false
    var isPhoneVerified: Bool = false
    var verificationLevel: VerificationLevel = .unverified
    var accountStatus: AccountStatus = .active

    // MARK: - Rating & Statistics
    var rating: Double?  // Average rating (0-5)
    var totalReviews: Int = 0  // Number of reviews received

    // Service Provider Statistics
    var totalServicesPosted: Int = 0
    var totalJobsCompleted: Int = 0
    var acceptanceRate: Double?  // % of applications accepted (0-100)
    var averageResponseTime: TimeInterval?  // In seconds
    var completionRate: Double?  // % of jobs completed (0-100)

    // Job Seeker Statistics
    var totalApplicationsSubmitted: Int = 0
    var totalJobsAppliedTo: Int = 0

    // MARK: - Profile Completion
    var profileCompletionPercentage: Int = 0

    // MARK: - Preferences
    var preferredLanguage: String = "en"
    var timezone: String?
    var notificationsEnabled: Bool = true
    var emailNotifications: Bool = true
    var smsNotifications: Bool = true

    // MARK: - Trust & Badges
    var badges: [Badge] = []
    var isTrustedProvider: Bool = false  // Set by admin when meeting criteria

    // MARK: - Financial Data
    var totalEarnings: Double?           // Lifetime earnings from completed jobs
    var monthlyEarnings: Double?         // Monthly earnings from completed jobs
    var walletBalance: Double?           // Current available balance
    var avgHourlyRate: Double?           // Service provider average rate

    // MARK: - Subscription & Membership
    var isPremiumMember: Bool = false
    var premiumExpiresAt: Date?
    var premiumFeatures: [String] = []   // e.g., ["priority_support", "verified_badge", "featured_profile"]

    // MARK: - Communication Preferences
    var preferredContactMethod: String? // "email", "phone", "whatsapp"
    var responseMessage: String?        // Auto-reply message when unavailable

    // MARK: - Metadata
    var createdAt: Date
    var lastLoginAt: Date
    var lastProfileUpdateAt: Date?
    var accountCreatedAt: Date?

    // MARK: - Initializers

    /// Create from Firebase Auth user (new user signup)
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL?.absoluteString
        self.createdAt = Date()
        self.lastLoginAt = Date()
    }

    /// Full initializer
    init(
        id: String,
        email: String,
        displayName: String? = nil,
        photoURL: String? = nil,
        phoneNumber: String? = nil,
        city: String? = nil,
        locationCoordinates: GeoPoint? = nil,
        bio: String? = nil,
        offeredServices: [String] = [],
        isServiceProvider: Bool = false,
        isJobSeeker: Bool = false,
        isEmailVerified: Bool = false,
        isPhoneVerified: Bool = false,
        verificationLevel: VerificationLevel = .unverified,
        accountStatus: AccountStatus = .active,
        rating: Double? = nil,
        totalReviews: Int = 0,
        totalServicesPosted: Int = 0,
        totalJobsCompleted: Int = 0,
        acceptanceRate: Double? = nil,
        averageResponseTime: TimeInterval? = nil,
        completionRate: Double? = nil,
        totalApplicationsSubmitted: Int = 0,
        totalJobsAppliedTo: Int = 0,
        profileCompletionPercentage: Int = 0,
        preferredLanguage: String = "en",
        timezone: String? = nil,
        notificationsEnabled: Bool = true,
        emailNotifications: Bool = true,
        smsNotifications: Bool = true,
        badges: [Badge] = [],
        isTrustedProvider: Bool = false,
        totalEarnings: Double? = nil,
        monthlyEarnings: Double? = nil,
        walletBalance: Double? = nil,
        avgHourlyRate: Double? = nil,
        isPremiumMember: Bool = false,
        premiumExpiresAt: Date? = nil,
        premiumFeatures: [String] = [],
        preferredContactMethod: String? = nil,
        responseMessage: String? = nil,
        createdAt: Date,
        lastLoginAt: Date,
        lastProfileUpdateAt: Date? = nil,
        accountCreatedAt: Date? = nil
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
        self.city = city
        self.locationCoordinates = locationCoordinates
        self.bio = bio
        self.offeredServices = offeredServices
        self.isServiceProvider = isServiceProvider
        self.isJobSeeker = isJobSeeker
        self.isEmailVerified = isEmailVerified
        self.isPhoneVerified = isPhoneVerified
        self.verificationLevel = verificationLevel
        self.accountStatus = accountStatus
        self.rating = rating
        self.totalReviews = totalReviews
        self.totalServicesPosted = totalServicesPosted
        self.totalJobsCompleted = totalJobsCompleted
        self.acceptanceRate = acceptanceRate
        self.averageResponseTime = averageResponseTime
        self.completionRate = completionRate
        self.totalApplicationsSubmitted = totalApplicationsSubmitted
        self.totalJobsAppliedTo = totalJobsAppliedTo
        self.profileCompletionPercentage = profileCompletionPercentage
        self.preferredLanguage = preferredLanguage
        self.timezone = timezone
        self.notificationsEnabled = notificationsEnabled
        self.emailNotifications = emailNotifications
        self.smsNotifications = smsNotifications
        self.badges = badges
        self.isTrustedProvider = isTrustedProvider
        self.totalEarnings = totalEarnings
        self.monthlyEarnings = monthlyEarnings
        self.walletBalance = walletBalance
        self.avgHourlyRate = avgHourlyRate
        self.isPremiumMember = isPremiumMember
        self.premiumExpiresAt = premiumExpiresAt
        self.premiumFeatures = premiumFeatures
        self.preferredContactMethod = preferredContactMethod
        self.responseMessage = responseMessage
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
        self.lastProfileUpdateAt = lastProfileUpdateAt
        self.accountCreatedAt = accountCreatedAt
    }
}
