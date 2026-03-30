//
//  User.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Sub-models

struct SavedAddress: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var address: String
    var floor: String
    var unit: String
    var city: String
}

// MARK: - User Model

struct User: Codable, Identifiable, Hashable {
    // MARK: - Identification
    let id: String  // Firebase UID

    // MARK: - Profile Information
    var email: String
    var displayName: String?
    var photoURL: String?
    var phoneNumber: String?
    var age: Int?
    var gender: String?  // "male", "female", "prefer_not_to_say"

    // MARK: - Location & Services
    var city: String?
    var locationCoordinates: GeoPoint?  // Firebase location type
    var bio: String?  // Service Providers describe their skills
    var offeredServices: [String] = []  // e.g., ["Plumbing", "Painting"]

    // MARK: - User Type (Dual-Role Support)
    var isServiceProvider: Bool = false  // Can post services
    var isJobSeeker: Bool = false        // Can apply to jobs
    var isCompany: Bool = false          // Service provider is company (not individual)
    var companyName: String?             // Company name if isCompany is true
    var industryCategory: String?        // Industry/sector e.g. "Fast Food", "Retail"
    var contactPersonName: String?       // Contact person for job postings
    var contactPersonPhone: String?      // Contact phone for job postings

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

    // MARK: - Profile Completion (Per-Role)
    var jobSeekerCompletionPercentage: Int = 0
    var providerCompletionPercentage: Int = 0

    // MARK: - Saved Addresses
    var savedAddresses: [SavedAddress]?
    var defaultAddressId: String?

    // MARK: - Preferences
    var preferredLanguage: String = "en"
    var timezone: String?
    var notificationsEnabled: Bool = true
    var emailNotifications: Bool = true
    var smsNotifications: Bool = true

    // MARK: - Firebase Cloud Messaging
    var fcmToken: String = ""
    var fcmTokens: [String] = []  // Multi-device support
    var lastNotificationCheck: Date?
    var unreadNotificationCount: Int = 0

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
        age: Int? = nil,
        gender: String? = nil,
        city: String? = nil,
        locationCoordinates: GeoPoint? = nil,
        bio: String? = nil,
        offeredServices: [String] = [],
        isServiceProvider: Bool = false,
        isJobSeeker: Bool = false,
        isCompany: Bool = false,
        companyName: String? = nil,
        contactPersonName: String? = nil,
        contactPersonPhone: String? = nil,
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
        jobSeekerCompletionPercentage: Int = 0,
        providerCompletionPercentage: Int = 0,
        savedAddresses: [SavedAddress]? = nil,
        defaultAddressId: String? = nil,
        preferredLanguage: String = "en",
        timezone: String? = nil,
        notificationsEnabled: Bool = true,
        emailNotifications: Bool = true,
        smsNotifications: Bool = true,
        fcmToken: String = "",
        fcmTokens: [String] = [],
        lastNotificationCheck: Date? = nil,
        unreadNotificationCount: Int = 0,
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
        self.age = age
        self.gender = gender
        self.city = city
        self.locationCoordinates = locationCoordinates
        self.bio = bio
        self.offeredServices = offeredServices
        self.isServiceProvider = isServiceProvider
        self.isJobSeeker = isJobSeeker
        self.isCompany = isCompany
        self.companyName = companyName
        self.contactPersonName = contactPersonName
        self.contactPersonPhone = contactPersonPhone
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
        self.jobSeekerCompletionPercentage = jobSeekerCompletionPercentage
        self.providerCompletionPercentage = providerCompletionPercentage
        self.savedAddresses = savedAddresses
        self.defaultAddressId = defaultAddressId
        self.preferredLanguage = preferredLanguage
        self.timezone = timezone
        self.notificationsEnabled = notificationsEnabled
        self.emailNotifications = emailNotifications
        self.smsNotifications = smsNotifications
        self.fcmToken = fcmToken
        self.fcmTokens = fcmTokens
        self.lastNotificationCheck = lastNotificationCheck
        self.unreadNotificationCount = unreadNotificationCount
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

// MARK: - Profile Completion Extension

enum UserRole {
    case jobSeeker
    case provider
}

extension User {
    /// Recalculates profile completion percentages for both roles
    mutating func recalculateProfileCompletion() {
        jobSeekerCompletionPercentage = calculateJobSeekerCompletion()
        providerCompletionPercentage = calculateProviderCompletion()
    }

    /// Calculates job seeker profile completion (6 required fields)
    private func calculateJobSeekerCompletion() -> Int {
        var completed = 0
        let totalFields = 6

        if displayName != nil && !displayName!.isEmpty { completed += 1 }
        if age != nil { completed += 1 }
        if gender != nil { completed += 1 }
        if phoneNumber != nil && !phoneNumber!.isEmpty { completed += 1 }
        if city != nil && !city!.isEmpty { completed += 1 }
        if bio != nil && !bio!.isEmpty { completed += 1 }

        return Int((Double(completed) / Double(totalFields)) * 100)
    }

    /// Calculates provider profile completion (3 required fields, varies by company status)
    private func calculateProviderCompletion() -> Int {
        if isCompany {
            var completed = 0
            let totalFields = 3
            if companyName != nil && !companyName!.isEmpty { completed += 1 }
            if phoneNumber != nil && !phoneNumber!.isEmpty { completed += 1 }
            if bio != nil && !bio!.isEmpty { completed += 1 }
            return Int((Double(completed) / Double(totalFields)) * 100)
        } else {
            var completed = 0
            let totalFields = 3
            if displayName != nil && !displayName!.isEmpty { completed += 1 }
            if phoneNumber != nil && !phoneNumber!.isEmpty { completed += 1 }
            if bio != nil && !bio!.isEmpty { completed += 1 }
            return Int((Double(completed) / Double(totalFields)) * 100)
        }
    }

    /// Returns the completion percentage for the specified role
    func getCompletionPercentage(forRole role: UserRole) -> Int {
        switch role {
        case .jobSeeker:
            return jobSeekerCompletionPercentage
        case .provider:
            return providerCompletionPercentage
        }
    }
}
