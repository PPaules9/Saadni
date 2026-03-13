//
//  User.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Supporting Enums & Structures

enum VerificationLevel: String, Codable {
 case unverified
 case bronze   // Email verified
 case silver   // Email + Phone verified
 case gold     // Email + Phone + ID verified
}

enum AccountStatus: String, Codable {
 case active
 case suspended
 case banned
 case pendingVerification
}

struct Badge: Codable, Hashable, Identifiable {
 let id: String
 let name: String
 let description: String?
 let earnedAt: Date
 let icon: String?  // SF Symbol name
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
  self.phoneNumber = firebaseUser.phoneNumber
  self.createdAt = firebaseUser.metadata.creationDate ?? Date()
  self.lastLoginAt = Date()
  self.accountCreatedAt = firebaseUser.metadata.creationDate
  
  // Defaults for new users
  self.isServiceProvider = false
  self.isJobSeeker = false
  self.isEmailVerified = firebaseUser.isEmailVerified
  self.verificationLevel = firebaseUser.isEmailVerified ? .bronze : .unverified
 }
 
 /// Full initializer (for Firestore decoding - existing users)
 init(
  id: String,
  email: String,
  displayName: String?,
  photoURL: String?,
  phoneNumber: String?,
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

// MARK: - Computed Properties
extension User {
 /// User's initials for avatar display
 var initials: String {
  if let name = displayName {
   let components = name.components(separatedBy: " ")
   let initials = components.compactMap { $0.first }.prefix(2)
   return String(initials).uppercased()
  }
  return String(email.prefix(2)).uppercased()
 }
 
 
 
 
 /// Rating display with stars (e.g., "4.8 ⭐")
 var ratingDisplayAsProvider: String {
  guard let rating = rating else { return "No ratings yet" }
  let stars = String(repeating: "⭐", count: Int(rating.rounded()))
  return String(format: "%.1f", rating) + " " + stars
 }
 
 var ratingDisplayAsJopSeeker: String {
  guard let rating = rating else { return "No ratings yet" }
  let stars = String(repeating: "⭐", count: Int(rating.rounded()))
  return String(format: "%.1f", rating) + " " + stars
 }
 
 
 /// Verification badge color
 var verificationBadgeColor: String {
  switch verificationLevel {
  case .unverified:
   return "gray"
  case .bronze:
   return "orange"
  case .silver:
   return "blue"
  case .gold:
   return "yellow"
  }
 }
 
 
 
 
 /// Whether user can post services (service provider)
 var canPostServices: Bool {
  return isServiceProvider && accountStatus == .active
 }
 
 /// Whether user can apply to jobs (job seeker)
 var canApplyToJobs: Bool {
  return isJobSeeker && accountStatus == .active
 }
 
 /// Account is in good standing
 var accountInGoodStanding: Bool {
  return accountStatus == .active && verificationLevel != .unverified
 }
 
 /// Is account fully verified
 var isFullyVerified: Bool {
  return verificationLevel == .gold && isEmailVerified && isPhoneVerified
 }
 
 
 
 
 /// Score for ranking service providers (0-100)
 var providerScore: Int {
  var score = 0
  
  // Rating (40 points)
  if let rating = rating {
   score += Int((rating / 5.0) * 40)
  }
  
  // Completion rate (30 points)
  if let completionRate = completionRate {
   score += Int((completionRate / 100.0) * 30)
  }
  
  // Verification level (20 points)
  switch verificationLevel {
  case .unverified:
   score += 0
  case .bronze:
   score += 5
  case .silver:
   score += 10
  case .gold:
   score += 20
  }
  
  // Reviews (10 points)
  if totalReviews >= 10 {
   score += 10
  } else if totalReviews > 0 {
   score += (totalReviews / 10) * 10
  }
  
  return min(score, 100)
 }
 
 /// Account age in days
 var accountAgeDays: Int {
  return Int(Date().timeIntervalSince(createdAt) / AppConstants.Time.secondsPerDay)
 }
 
 /// Human-readable last login time
 var lastLoginFormatted: String {
  let formatter = RelativeDateTimeFormatter()
  formatter.unitsStyle = .short
  return formatter.localizedString(for: lastLoginAt, relativeTo: Date())
 }
 
 /// Profile completion status
 var profileCompletionStatus: String {
  switch profileCompletionPercentage {
  case 0...33:
   return "Incomplete"
  case 34...66:
   return "Partial"
  case 67...99:
   return "Nearly Complete"
  default:
   return "Complete"
  }
 }
 
 /// Whether premium membership is active
 var isPremiumActive: Bool {
  guard isPremiumMember else { return false }
  guard let expiresAt = premiumExpiresAt else { return true }
  return expiresAt > Date()
 }
 
 /// Days until premium expires
 var daysUntilPremiumExpires: Int? {
  guard let expiresAt = premiumExpiresAt else { return nil }
  return Int(expiresAt.timeIntervalSince(Date()) / AppConstants.Time.secondsPerDay)
 }
 
 /// Premium status display
 var premiumStatusDisplay: String {
  if !isPremiumMember {
   return "Free Member"
  }
  if isPremiumActive {
   if let days = daysUntilPremiumExpires {
    return "Premium - \(days) days left"
   }
   return "Premium Member"
  }
  return "Premium Expired"
 }
 
 /// Formatted wallet balance
 var walletBalanceFormatted: String {
  guard let balance = walletBalance else { return "N/A" }
  return String(format: "$%.2f", balance)
 }
 
 /// Formatted total earnings
 var totalEarningsFormatted: String {
  guard let earnings = totalEarnings else { return "$0.00" }
  return String(format: "$%.2f", earnings)
 }
 
 /// Formatted hourly rate
 var avgHourlyRateFormatted: String {
  guard let rate = avgHourlyRate else { return "Not set" }
  return String(format: "$%.2f/hr", rate)
 }
 
 /// Primary contact method display
 var contactMethodDisplay: String {
  switch preferredContactMethod {
  case "email":
   return "📧 Email"
  case "phone":
   return "📱 Phone"
  case "whatsapp":
   return "💬 WhatsApp"
  default:
   return "Not specified"
  }
 }
 
 /// Whether user has auto-reply enabled
 var hasAutoReply: Bool {
  return responseMessage != nil && !responseMessage!.isEmpty
 }
}
