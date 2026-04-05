//
//  JobService.swift
//  GoodShift
//
//  Created by Pavly Paules on 10/03/2026.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct JobService: Codable, Hashable, Identifiable {
	
	let id: String
	
	// MARK: - Core Service Data
	
	/// Service title (e.g., "Help me move furniture")
	var title: String
	
	/// Price (displayed in the user's selected currency)
	var price: Double
	
	/// Where the service will be performed
	var location: ServiceLocation
	
	/// Detailed description of the service
	var description: String
	
	/// Service image
	var image: ServiceImage
	
	/// When this service was created
	var createdAt: Date
	
	// MARK: - Provider Information
	
	/// ID of the user who created this service
	var providerId: String
	
	/// Provider's display name (optional)
	var providerName: String?
	
	/// Provider's profile image URL (optional)
	var providerImageURL: String?
	
	// MARK: - Service Status & Metadata
	
	/// Current status (draft, published, active, completed, cancelled)
	var status: ServiceStatus
	
	/// Number of applications received (for real-time badge updates)
	var applicationCount: Int
	
	/// Category of the service
	var category: ServiceCategoryType?
	
	// MARK: - Completion & Archive
	
	/// ID of the applicant who was hired for this service
	var hiredApplicantId: String?
	
	/// When this service was marked as completed
	var completedAt: Date?
	
	/// Whether this service has been archived by the provider
	var isArchived: Bool = false

	// MARK: - Completion Workflow Fields

	/// When the hired student submitted their completion claim
	var completionRequestedAt: Date?

	/// Optional note from student when submitting completion
	var completionNote: String?

	/// Reason provided by provider when disputing completion
	var disputeReason: String?
	
	// MARK: - Location Details
	
	/// Street address of the service location
	var address: String = ""
	
	/// Floor number (if applicable)
	var floor: String = ""
	
	/// Unit/apartment number (if applicable)
	var unit: String = ""
	
	// MARK: - Shift Specific Fields
	var breakDuration: String?
	var numberOfWorkersNeeded: Int?
	var branchName: String?
	var nearestLandmark: String?
	
	var paymentMethod: String?
	var paymentTiming: String?
	
	var dressCode: String?
	var minimumAge: String?
	var genderPreference: String?
	var physicalRequirements: String?
	var languageNeeded: String?
	var whatToBring: String?
	
	// MARK: - Company Info
	var companyName: String?
	var companyLogoURL: String?
	var industryCategory: String?
	var contactPersonName: String?
	var contactPersonPhone: String?
	
	// MARK: - Legacy / Other Fields (Keeping for compatibility if needed)
	var someoneAround: Bool = false
	var specialTools: String?
	var serviceDate: Date?
	var estimatedDurationHours: Double?
	
	var isFeatured: Bool
	
	// MARK: - Initializers
	
	/// Create a service from form data
	init(
		title: String,
		price: Double,
		location: ServiceLocation,
		description: String,
		image: ServiceImage,
		category: ServiceCategoryType,
		providerId: String,
		address: String = "",
		floor: String = "",
		unit: String = "",
		breakDuration: String? = nil,
		numberOfWorkersNeeded: Int? = 1,
		branchName: String? = nil,
		nearestLandmark: String? = nil,
		paymentMethod: String? = nil,
		paymentTiming: String? = nil,
		dressCode: String? = nil,
		minimumAge: String? = nil,
		genderPreference: String? = nil,
		physicalRequirements: String? = nil,
		languageNeeded: String? = nil,
		whatToBring: String? = nil,
		companyName: String? = nil,
		companyLogoURL: String? = nil,
		industryCategory: String? = nil,
		contactPersonName: String? = nil,
		contactPersonPhone: String? = nil,
		someoneAround: Bool = false,
		specialTools: String? = nil,
		serviceDate: Date? = nil,
		estimatedDurationHours: Double? = nil,
		status: ServiceStatus = .draft
	) {
		self.id = UUID().uuidString
		self.title = title
		self.price = price
		self.location = location
		self.description = description
		self.image = image
		self.category = category
		self.providerId = providerId
		self.address = address
		self.floor = floor
		self.unit = unit
		self.breakDuration = breakDuration
		self.numberOfWorkersNeeded = numberOfWorkersNeeded
		self.branchName = branchName
		self.nearestLandmark = nearestLandmark
		self.paymentMethod = paymentMethod
		self.paymentTiming = paymentTiming
		self.dressCode = dressCode
		self.minimumAge = minimumAge
		self.genderPreference = genderPreference
		self.physicalRequirements = physicalRequirements
		self.languageNeeded = languageNeeded
		self.whatToBring = whatToBring
		self.companyName = companyName
		self.companyLogoURL = companyLogoURL
		self.industryCategory = industryCategory
		self.contactPersonName = contactPersonName
		self.contactPersonPhone = contactPersonPhone
		self.someoneAround = someoneAround
		self.specialTools = specialTools
		self.serviceDate = serviceDate
		self.estimatedDurationHours = estimatedDurationHours
		self.providerName = nil
		self.providerImageURL = nil
		self.status = status
		self.isFeatured = false
		self.applicationCount = 0
		self.createdAt = Date()
	}
	
	/// Full initializer (for Firebase decoding)
	init(
		id: String,
		title: String,
		price: Double,
		location: ServiceLocation,
		description: String,
		image: ServiceImage,
		createdAt: Date,
		providerId: String,
		providerName: String?,
		providerImageURL: String?,
		status: ServiceStatus,
		isFeatured: Bool,
		category: ServiceCategoryType?,
		address: String = "",
		floor: String = "",
		unit: String = "",
		breakDuration: String? = nil,
		numberOfWorkersNeeded: Int? = 1,
		branchName: String? = nil,
		nearestLandmark: String? = nil,
		paymentMethod: String? = nil,
		paymentTiming: String? = nil,
		dressCode: String? = nil,
		minimumAge: String? = nil,
		genderPreference: String? = nil,
		physicalRequirements: String? = nil,
		languageNeeded: String? = nil,
		whatToBring: String? = nil,
		companyName: String? = nil,
		companyLogoURL: String? = nil,
		industryCategory: String? = nil,
		contactPersonName: String? = nil,
		contactPersonPhone: String? = nil,
		someoneAround: Bool = false,
		specialTools: String? = nil,
		serviceDate: Date? = nil,
		estimatedDurationHours: Double? = nil,
		applicationCount: Int = 0,
		hiredApplicantId: String? = nil,
		completedAt: Date? = nil,
		isArchived: Bool = false,
		completionRequestedAt: Date? = nil,
		completionNote: String? = nil,
		disputeReason: String? = nil
	) {
		self.id = id
		self.title = title
		self.price = price
		self.location = location
		self.description = description
		self.image = image
		self.createdAt = createdAt
		self.providerId = providerId
		self.providerName = providerName
		self.providerImageURL = providerImageURL
		self.status = status
		self.isFeatured = isFeatured
		self.category = category
		self.address = address
		self.floor = floor
		self.unit = unit
		self.breakDuration = breakDuration
		self.numberOfWorkersNeeded = numberOfWorkersNeeded
		self.branchName = branchName
		self.nearestLandmark = nearestLandmark
		self.paymentMethod = paymentMethod
		self.paymentTiming = paymentTiming
		self.dressCode = dressCode
		self.minimumAge = minimumAge
		self.genderPreference = genderPreference
		self.physicalRequirements = physicalRequirements
		self.languageNeeded = languageNeeded
		self.whatToBring = whatToBring
		self.companyName = companyName
		self.companyLogoURL = companyLogoURL
		self.industryCategory = industryCategory
		self.contactPersonName = contactPersonName
		self.contactPersonPhone = contactPersonPhone
		self.someoneAround = someoneAround
		self.specialTools = specialTools
		self.serviceDate = serviceDate
		self.estimatedDurationHours = estimatedDurationHours
		self.applicationCount = applicationCount
		self.hiredApplicantId = hiredApplicantId
		self.completedAt = completedAt
		self.isArchived = isArchived
		self.completionRequestedAt = completionRequestedAt
		self.completionNote = completionNote
		self.disputeReason = disputeReason
	}
}

// MARK: - Firestore Conversion (Thin Wrappers)

extension JobService {
	/// Convert to Firestore dictionary
	func toFirestore() -> [String: Any] {
		return JobServiceFirestoreMapper.toFirestore(self)
	}
	
	/// Create from Firestore data
	static func fromFirestore(id: String, data: [String: Any]) throws -> JobService {
		return try JobServiceFirestoreMapper.fromFirestore(id: id, data: data)
	}
}


import Foundation

// MARK: - Computed Properties (Display & Formatting)

extension JobService {
	/// Formatted price for display
	var formattedPrice: String {
		return "\(Int(price)) \(Currency.current.symbol)"
	}
	
	/// Check if service can be edited
	var isEditable: Bool {
		return status == .draft
	}
	
	/// Check if service is visible to public
	var isPublished: Bool {
		return status == .published || status == .active || status == .pendingCompletion
	}

	/// Check if student has submitted a completion claim pending provider confirmation
	var isPendingCompletion: Bool {
		return status == .pendingCompletion
	}

	/// Check if provider disputed the completion
	var isDisputed: Bool {
		return status == .disputed
	}
	
	/// Get the category display name
	var categoryDisplayName: String {
		return category?.rawValue ?? "Unknown"
	}
	
	/// Check if service was created today
	var isNew: Bool {
		return Calendar.current.isDateInToday(createdAt)
	}
	
	/// Check if service is completed
	var isCompleted: Bool {
		return status == .completed
	}
	
	/// Check if service can be reviewed (must be completed with timestamp)
	var canBeReviewed: Bool {
		return status == .completed && completedAt != nil
	}
	
	/// Check if service is currently active with someone hired
	var isActive: Bool {
		return status == .active && hiredApplicantId != nil
	}
	
	/// Formatted completion date for display
	var completedDateFormatted: String {
		guard let completedAt = completedAt else { return "Not completed" }
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .short
		return formatter.localizedString(for: completedAt, relativeTo: Date())
	}
}
