//
//  FlexibleJobService.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//


import Foundation
import FirebaseFirestore

/// Represents a flexible, one-time service/job
struct FlexibleJobService: Codable, Hashable, Identifiable {
    
    // MARK: - Identification
    
    /// Unique identifier (Firebase document ID)
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
    
    /// Always .flexibleJobs for this type
 var jobType: JobType {
  return .flexibleJobs
 }
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

    // MARK: - Flexible Job Specific

    /// Category of flexible job
    var category: FlexibleJobCategory
    
    // MARK: - Initializers
    
    /// Create from AddService form data
    init(
        title: String,
        price: Double,
        location: ServiceLocation,
        description: String,
        image: ServiceImage,
        category: FlexibleJobCategory,
        providerId: String,
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
        self.providerName = nil
        self.providerImageURL = nil
        self.status = status
        self.isFeatured = false
        self.applicationCount = 0
        self.createdAt = Date()
        // jobType is automatically .flexibleJobs
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
        category: FlexibleJobCategory,
        applicationCount: Int = 0
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
        self.applicationCount = applicationCount
        // jobType is automatically .flexibleJobs
    }
}

// MARK: - Computed Properties

extension FlexibleJobService {
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
}

// MARK: - Firestore Conversion

extension FlexibleJobService {
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
            "jobType": "flexibleJobs",
            "category": category.rawValue,
            "applicationCount": applicationCount,

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

        // Optional fields
        if let providerName = providerName {
            dict["providerName"] = providerName
        }
        if let providerImageURL = providerImageURL {
            dict["providerImageURL"] = providerImageURL
        }

        return dict
    }

    /// Create from Firestore data
    static func fromFirestore(id: String, data: [String: Any]) throws -> FlexibleJobService {
        guard let title = data["title"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let providerId = data["providerId"] as? String,
              let statusRaw = data["status"] as? String,
              let status = ServiceStatus(rawValue: statusRaw),
              let isFeatured = data["isFeatured"] as? Bool,
              let categoryRaw = data["category"] as? String,
              let category = FlexibleJobCategory(rawValue: categoryRaw),
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

        return FlexibleJobService(
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
            applicationCount: applicationCount
        )
    }
}

// MARK: - Mock Data

extension FlexibleJobService {
    static let mock1 = FlexibleJobService(
        title: "Help me clean my apartment",
        price: 150.0,
        location: ServiceLocation(
            name: "Nasr City, Cairo",
            latitude: 30.0444,
            longitude: 31.2357
        ),
        description: "Need help cleaning a 2-bedroom apartment. Should take about 3 hours.",
        image: ServiceImage(),
        category: .helpCleaning,
        providerId: "user123"
    )
    
    static let mock2 = FlexibleJobService(
        title: "Grocery shopping needed",
        price: 50.0,
        location: ServiceLocation(
            name: "Maadi, Cairo",
            latitude: 29.9602,
            longitude: 31.2569
        ),
        description: "Please pick up groceries from Carrefour. List will be provided.",
        image: ServiceImage(),
        category: .groceryShopping,
        providerId: "user456"
    )
}
