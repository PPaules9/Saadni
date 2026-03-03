//
//  ShiftService.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//


import Foundation
import FirebaseFirestore

/// Represents a scheduled shift service
struct ShiftService: Codable, Hashable, Identifiable {
    
    // MARK: - Identification
    
    /// Unique identifier (Firebase document ID)
    let id: String
    
    // MARK: - Core Service Data
    
    /// Service title (e.g., "Barista needed for weekend")
    var title: String
    
    /// Price in EGP (per shift or hourly)
    var price: Double
    
    /// Where the shift will be performed
    var location: ServiceLocation
    
    /// Detailed description of the shift
    var description: String
    
    /// Service image
    var image: ServiceImage
    
    /// When this service was created
    var createdAt: Date
    
    /// Always .shift for this type (computed property)
    var jobType: JobType {
        return .shift
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

    // MARK: - Shift Specific

    /// Name of the shift (e.g., "Morning Shift")
    var shiftName: String
    
    /// Predefined category (if user selected from list)
    var category: ShiftCategory?
    
    /// Custom category name (if user entered custom)
    var customCategory: String?
    
    /// Shift scheduling information
    var schedule: ShiftSchedule
    
    // MARK: - Initializers
    
    /// Create from AddShift form data
    init(
        title: String,
        price: Double,
        location: ServiceLocation,
        description: String,
        image: ServiceImage,
        shiftName: String,
        category: ShiftCategory?,
        customCategory: String?,
        schedule: ShiftSchedule,
        providerId: String,
        status: ServiceStatus = .draft
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.price = price
        self.location = location
        self.description = description
        self.image = image
        self.shiftName = shiftName
        self.category = category
        self.customCategory = customCategory
        self.schedule = schedule
        self.providerId = providerId
        self.providerName = nil
        self.providerImageURL = nil
        self.status = status
        self.isFeatured = false
        self.applicationCount = 0
        self.createdAt = Date()
        // jobType is computed as .shift
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
        shiftName: String,
        category: ShiftCategory?,
        customCategory: String?,
        schedule: ShiftSchedule,
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
        self.shiftName = shiftName
        self.category = category
        self.customCategory = customCategory
        self.schedule = schedule
        self.applicationCount = applicationCount
        // jobType is computed as .shift
    }
}

// MARK: - Computed Properties

extension ShiftService {
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
    
    /// Get the category name (either predefined or custom)
    var categoryDisplayName: String {
        if let customCategory = customCategory, !customCategory.isEmpty {
            return customCategory
        }
        return category?.rawValue ?? "Unknown"
    }
    
    /// Total number of shifts (1 or multiple if repeated)
    var totalShifts: Int {
        return schedule.totalShifts
    }
    
    /// Duration of each shift in hours
    var shiftDuration: Double {
        return schedule.durationInHours
    }
}

// MARK: - Firestore Conversion

extension ShiftService {
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
            "jobType": "shift",
            "shiftName": shiftName,
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
            ],

            // Schedule
            "schedule": [
                "startDate": Timestamp(date: schedule.startDate),
                "startTime": Timestamp(date: schedule.startTime),
                "endTime": Timestamp(date: schedule.endTime),
                "isRepeated": schedule.isRepeated,
                "repeatDates": schedule.repeatDates.map { Timestamp(date: $0) }
            ]
        ]

        // Optional fields
        if let providerName = providerName {
            dict["providerName"] = providerName
        }
        if let providerImageURL = providerImageURL {
            dict["providerImageURL"] = providerImageURL
        }
        if let category = category {
            dict["shiftCategory"] = category.rawValue
        }
        if let customCategory = customCategory {
            dict["customCategory"] = customCategory
        }

        return dict
    }

    /// Create from Firestore data
    static func fromFirestore(id: String, data: [String: Any]) throws -> ShiftService {
        guard let title = data["title"] as? String,
              let price = data["price"] as? Double,
              let description = data["description"] as? String,
              let providerId = data["providerId"] as? String,
              let statusRaw = data["status"] as? String,
              let status = ServiceStatus(rawValue: statusRaw),
              let isFeatured = data["isFeatured"] as? Bool,
              let shiftName = data["shiftName"] as? String,
              let locationData = data["location"] as? [String: Any],
              let locationName = locationData["name"] as? String,
              let scheduleData = data["schedule"] as? [String: Any]
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

        // Parse schedule
        let startDate = (scheduleData["startDate"] as? Timestamp)?.dateValue() ?? Date()
        let startTime = (scheduleData["startTime"] as? Timestamp)?.dateValue() ?? Date()
        let endTime = (scheduleData["endTime"] as? Timestamp)?.dateValue() ?? Date()
        let isRepeated = scheduleData["isRepeated"] as? Bool ?? false
        let repeatDatesTimestamps = scheduleData["repeatDates"] as? [Timestamp] ?? []
        let repeatDates = repeatDatesTimestamps.map { $0.dateValue() }

        let schedule = ShiftSchedule(
            startDate: startDate,
            startTime: startTime,
            endTime: endTime,
            isRepeated: isRepeated,
            repeatDates: repeatDates
        )

        // Get optional category
        let categoryRaw = data["shiftCategory"] as? String
        let category = categoryRaw.flatMap { ShiftCategory(rawValue: $0) }

        return ShiftService(
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
            shiftName: shiftName,
            category: category,
            customCategory: data["customCategory"] as? String,
            schedule: schedule,
            applicationCount: applicationCount
        )
    }
}

// MARK: - Mock Data

extension ShiftService {
    static let mock1 = ShiftService(
        title: "Barista needed for weekend",
        price: 100.0,
        location: ServiceLocation(
            name: "Zamalek, Cairo",
            latitude: 30.0626,
            longitude: 31.2206
        ),
        description: "Looking for an experienced barista for Saturday morning shift.",
        image: ServiceImage(),
        shiftName: "Weekend Morning Shift",
        category: .barista,
        customCategory: nil,
        schedule: ShiftSchedule(
            startDate: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600 * 6)
        ),
        providerId: "user789"
    )
    
    static let mock2 = ShiftService(
        title: "Event photographer wanted",
        price: 300.0,
        location: ServiceLocation(
            name: "New Cairo",
            latitude: 30.0330,
            longitude: 31.4920
        ),
        description: "Need a photographer for a corporate event. 4 hours.",
        image: ServiceImage(),
        shiftName: "Corporate Event",
        category: .photographer,
        customCategory: nil,
        schedule: ShiftSchedule(
            startDate: Date().addingTimeInterval(86400 * 7),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600 * 4)
        ),
        providerId: "user101"
    )
}
