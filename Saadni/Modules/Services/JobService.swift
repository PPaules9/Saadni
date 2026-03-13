//
//  JobService.swift
//  Saadni
//
//  Created by Pavly Paules on 10/03/2026.
//

import Foundation
import FirebaseFirestore
import CoreLocation

/// Represents the activity status of a service in user's recent activities
enum ServiceActivityType: String, Codable, CaseIterable {
    case appliedOn = "Applied On"
    case upcoming = "Upcoming"
    case finished = "Finished"
}

/// Represents a service activity for displaying in the Recent Activity section
struct ServiceActivity: Identifiable {
    let id = UUID()
    let service: JobService
    let activityType: ServiceActivityType
    let status: String
    let extraDetails: String
    let isHighlighted: Bool
}

struct JobService: Codable, Hashable, Identifiable {

    let id: String

    // MARK: - Core Service Data

    /// Service title (e.g., "Help me move furniture")
    var title: String

    /// Price in EGP
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

    /// Whether this service should be featured/highlighted
    var isFeatured: Bool

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

    // MARK: - Location Details

    /// Street address of the service location
    var address: String = ""

    /// Floor number (if applicable)
    var floor: String = ""

    /// Unit/apartment number (if applicable)
    var unit: String = ""

    // MARK: - Service Requirements

    /// Whether someone will be around during the service
    var someoneAround: Bool = false

    /// Special tools/equipment needed for the service (optional)
    var specialTools: String?

    // MARK: - Service Scheduling

    /// When the service should be performed (optional - can be flexible)
    var serviceDate: Date?

    /// Estimated duration in hours (optional)
    var estimatedDurationHours: Double?

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
        someoneAround: Bool = false,
        specialTools: String? = nil,
        serviceDate: Date? = nil,
        estimatedDurationHours: Double? = nil,
        applicationCount: Int = 0,
        hiredApplicantId: String? = nil,
        completedAt: Date? = nil,
        isArchived: Bool = false
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
        self.someoneAround = someoneAround
        self.specialTools = specialTools
        self.serviceDate = serviceDate
        self.estimatedDurationHours = estimatedDurationHours
        self.applicationCount = applicationCount
        self.hiredApplicantId = hiredApplicantId
        self.completedAt = completedAt
        self.isArchived = isArchived
    }
}

// MARK: - Computed Properties

extension JobService {
    /// Formatted price for display
    var formattedPrice: String {
        return "\(Int(price)) EGP"
    }

    /// Check if service can be edited
    var isEditable: Bool {
        return status == .draft
    }

    /// Check if service is visible to public
    var isPublished: Bool {
        return status == .published || status == .active
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

// MARK: - Firestore Conversion

extension JobService {
    /// Convert to Firestore dictionary
    func toFirestore() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "title": title,
            "price": price,
            "description": description,
            "createdAt": Timestamp(date: createdAt),
            "providerId": providerId,
            "status": status.rawValue,
            "isFeatured": isFeatured,
            "applicationCount": applicationCount,
            "isArchived": isArchived,
            "address": address,
            "floor": floor,
            "unit": unit,
            "someoneAround": someoneAround,

            // Location
            "location": [
                "name": location.name,
                "latitude": location.latitude as Any,
                "longitude": location.longitude as Any
            ],

            // Image
            "image": [
                "localId": image.localId as Any,
                "remoteURL": image.remoteURL as Any
            ]
        ]

        // Optional provider fields
        if let providerName = providerName {
            dict["providerName"] = providerName
        }
        if let providerImageURL = providerImageURL {
            dict["providerImageURL"] = providerImageURL
        }

        // Category
        if let category = category {
            dict["category"] = category.rawValue
        }

        // Special tools
        if let specialTools = specialTools {
            dict["specialTools"] = specialTools
        }

        // Scheduling
        if let serviceDate = serviceDate {
            dict["serviceDate"] = Timestamp(date: serviceDate)
        }
        if let estimatedDurationHours = estimatedDurationHours {
            dict["estimatedDurationHours"] = estimatedDurationHours
        }

        // Completion fields
        if let hiredApplicantId = hiredApplicantId {
            dict["hiredApplicantId"] = hiredApplicantId
        }
        if let completedAt = completedAt {
            dict["completedAt"] = Timestamp(date: completedAt)
        }

        return dict
    }

    /// Create from Firestore data
    static func fromFirestore(id: String, data: [String: Any]) throws -> JobService {
        guard let title = data["title"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let providerId = data["providerId"] as? String,
              let statusRaw = data["status"] as? String,
              let status = ServiceStatus(rawValue: statusRaw),
              let isFeatured = data["isFeatured"] as? Bool,
              let locationData = data["location"] as? [String: Any],
              let locationName = locationData["name"] as? String
        else {
            throw NSError(domain: "FirestoreDecoding", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing required fields"])
        }

        let location = ServiceLocation(
            name: locationName,
            latitude: locationData["latitude"] as? Double,
            longitude: locationData["longitude"] as? Double
        )

        let imageData = data["image"] as? [String: Any]
        let image = ServiceImage(
            localId: imageData?["localId"] as? String,
            remoteURL: imageData?["remoteURL"] as? String
        )

        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        let applicationCount = data["applicationCount"] as? Int ?? 0

        // Parse category
        let categoryRaw = data["category"] as? String
        let category = categoryRaw.flatMap { ServiceCategoryType(rawValue: $0) }

        // Parse completion fields
        let hiredApplicantId = data["hiredApplicantId"] as? String
        let completedAt = (data["completedAt"] as? Timestamp)?.dateValue()
        let isArchived = data["isArchived"] as? Bool ?? false

        let address = data["address"] as? String ?? ""
        let floor = data["floor"] as? String ?? ""
        let unit = data["unit"] as? String ?? ""
        let someoneAround = data["someoneAround"] as? Bool ?? false
        let specialTools = data["specialTools"] as? String
        let serviceDate = (data["serviceDate"] as? Timestamp)?.dateValue()
        let estimatedDurationHours = data["estimatedDurationHours"] as? Double

        return JobService(
            id: id,
            title: title,
            price: price,
            location: location,
            description: description,
            image: image,
            createdAt: createdAt,
            providerId: providerId,
            providerName: data["providerName"] as? String,
            providerImageURL: data["providerImageURL"] as? String,
            status: status,
            isFeatured: isFeatured,
            category: category,
            address: address,
            floor: floor,
            unit: unit,
            someoneAround: someoneAround,
            specialTools: specialTools,
            serviceDate: serviceDate,
            estimatedDurationHours: estimatedDurationHours,
            applicationCount: applicationCount,
            hiredApplicantId: hiredApplicantId,
            completedAt: completedAt,
            isArchived: isArchived
        )
    }
}














// MARK: - Mock Data

extension JobService {
    /// Sample activities for Recent Activity section
    static let sampleActivities: [ServiceActivity] = [
        ServiceActivity(
            service: sampleData[0],
            activityType: .appliedOn,
            status: "Status",
            extraDetails: sampleData[0].isFeatured ? "Featured Service" : "Applications: \(sampleData[0].applicationCount)",
            isHighlighted: sampleData[0].isFeatured
        ),
        ServiceActivity(
            service: sampleData[1],
            activityType: .upcoming,
            status: "Location",
            extraDetails: sampleData[1].location.name,
            isHighlighted: true
        ),
        ServiceActivity(
            service: sampleData[2],
            activityType: .finished,
            status: "Category",
            extraDetails: sampleData[2].categoryDisplayName,
            isHighlighted: sampleData[2].isNew
        ),
        ServiceActivity(
            service: sampleData[3],
            activityType: .finished,
            status: sampleData[3].formattedPrice,
            extraDetails: "Provider: \(sampleData[3].providerName ?? "Unknown")",
            isHighlighted: false
        )
    ]

    static let sampleData: [JobService] = [
        JobService(
            id: "service-1",
            title: "Home Cleaning Service",
            price: 250,
            location: ServiceLocation(
                name: "Cairo, Egypt",
                latitude: 30.0444,
                longitude: 31.2357
            ),
            description: "Professional home cleaning including all rooms and basic furniture cleaning.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(),
            providerId: "provider-1",
            providerName: "Ahmed Hassan",
            providerImageURL: nil,
            status: .published,
            isFeatured: true,
            category: .homeCleaning,
            address: "123 Main St",
            floor: "2",
            unit: "A",
            someoneAround: true,
            specialTools: nil,
            serviceDate: Date(timeIntervalSinceNow: AppConstants.Time.secondsPerDay * 3),
            estimatedDurationHours: 2.0,
            applicationCount: 5
        ),
        JobService(
            id: "service-2",
            title: "Furniture Assembly",
            price: 400,
            location: ServiceLocation(
                name: "Giza, Egypt",
                latitude: 30.0131,
                longitude: 31.2089
            ),
            description: "Expert furniture assembly for IKEA and other brands.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -AppConstants.Time.secondsPerDay),
            providerId: "provider-2",
            providerName: "Fatima Khalil",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .furnitureAssembly,
            address: "456 Oak Ave",
            floor: "3",
            unit: "B",
            someoneAround: true,
            specialTools: "Power drill, Allen keys",
            serviceDate: Date(timeIntervalSinceNow: AppConstants.Time.secondsPerDay * 7),
            estimatedDurationHours: 4.0,
            applicationCount: 2
        ),
        JobService(
            id: "service-3",
            title: "Electrical Installation",
            price: 500,
            location: ServiceLocation(
                name: "New Cairo, Egypt",
                latitude: 29.9737,
                longitude: 31.4957
            ),
            description: "Professional electrical work and installations with warranty.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -172800),
            providerId: "provider-3",
            providerName: "Mohammed Saleh",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .electricalWork,
            address: "789 Park Rd",
            floor: "5",
            unit: "C",
            someoneAround: false,
            specialTools: "Electrical testing equipment, cable tester",
            serviceDate: Date(timeIntervalSinceNow: AppConstants.Time.secondsPerDay * 2),
            estimatedDurationHours: 6.0,
            applicationCount: 8
        ),
        JobService(
            id: "service-4",
            title: "Plumbing Repair",
            price: 350,
            location: ServiceLocation(
                name: "Zamalek, Egypt",
                latitude: 30.0667,
                longitude: 31.2333
            ),
            description: "Emergency plumbing services available 24/7.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -259200),
            providerId: "provider-4",
            providerName: "Layla Ahmed",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .plumbing,
            address: "321 Water St",
            floor: "1",
            unit: "D",
            someoneAround: true,
            specialTools: "Pipe wrench, plunger, snake",
            serviceDate: nil,
            estimatedDurationHours: 1.5,
            applicationCount: 3
        ),
        JobService(
            id: "service-5",
            title: "Baby Sitting Service",
            price: 200,
            location: ServiceLocation(
                name: "Heliopolis, Egypt",
                latitude: 30.0667,
                longitude: 31.3333
            ),
            description: "Experienced baby sitter with certification and references.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -345600),
            providerId: "provider-5",
            providerName: "Noor Hassan",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .babySitting,
            address: "654 Garden Ln",
            floor: "2",
            unit: "E",
            someoneAround: false,
            specialTools: nil,
            serviceDate: Date(timeIntervalSinceNow: AppConstants.Time.secondsPerDay * 5),
            estimatedDurationHours: 8.0,
            applicationCount: 6
        ),
        JobService(
            id: "service-6",
            title: "Painting Service",
            price: 600,
            location: ServiceLocation(
                name: "Downtown Cairo, Egypt",
                latitude: 30.0626,
                longitude: 31.2454
            ),
            description: "Professional interior and exterior painting with high-quality materials.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(),
            providerId: "provider-6",
            providerName: "Karim Ahmed",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .painting,
            address: "987 Color Ave",
            floor: "4",
            unit: "F",
            someoneAround: true,
            specialTools: "Paint roller, brush set, drop cloth",
            serviceDate: Date(timeIntervalSinceNow: AppConstants.Time.secondsPerDay * 10),
            estimatedDurationHours: 8.0,
            applicationCount: 3
        )
    ]
}
