//
//  JobServiceFirestoreMapper.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation
import FirebaseFirestore

// MARK: - Firestore Conversion

struct JobServiceFirestoreMapper {
    /// Convert JobService to Firestore dictionary
    static func toFirestore(_ service: JobService) -> [String: Any] {
        var dict: [String: Any] = [
            "id": service.id,
            "title": service.title,
            "price": service.price,
            "description": service.description,
            "createdAt": Timestamp(date: service.createdAt),
            "providerId": service.providerId,
            "status": service.status.rawValue,
            "isFeatured": service.isFeatured,
            "applicationCount": service.applicationCount,
            "isArchived": service.isArchived,
            "address": service.address,
            "floor": service.floor,
            "unit": service.unit,
            "someoneAround": service.someoneAround,

            // Location
            "location": [
                "name": service.location.name,
                "latitude": service.location.latitude as Any,
                "longitude": service.location.longitude as Any
            ],

            // Image
            "image": [
                "localId": service.image.localId as Any,
                "remoteURL": service.image.remoteURL as Any
            ]
        ]

        // Optional provider fields
        if let providerName = service.providerName { dict["providerName"] = providerName }
        if let providerImageURL = service.providerImageURL { dict["providerImageURL"] = providerImageURL }

        // Category
        if let category = service.category { dict["category"] = category.rawValue }

        // Shift specific fields
        if let breakDuration = service.breakDuration { dict["breakDuration"] = breakDuration }
        if let numberOfWorkersNeeded = service.numberOfWorkersNeeded { dict["numberOfWorkersNeeded"] = numberOfWorkersNeeded }
        if let branchName = service.branchName { dict["branchName"] = branchName }
        if let nearestLandmark = service.nearestLandmark { dict["nearestLandmark"] = nearestLandmark }
        if let paymentMethod = service.paymentMethod { dict["paymentMethod"] = paymentMethod }
        if let paymentTiming = service.paymentTiming { dict["paymentTiming"] = paymentTiming }
        if let dressCode = service.dressCode { dict["dressCode"] = dressCode }
        if let minimumAge = service.minimumAge { dict["minimumAge"] = minimumAge }
        if let genderPreference = service.genderPreference { dict["genderPreference"] = genderPreference }
        if let physicalRequirements = service.physicalRequirements { dict["physicalRequirements"] = physicalRequirements }
        if let languageNeeded = service.languageNeeded { dict["languageNeeded"] = languageNeeded }
        if let whatToBring = service.whatToBring { dict["whatToBring"] = whatToBring }

        // Company Details
        if let companyName = service.companyName { dict["companyName"] = companyName }
        if let companyLogoURL = service.companyLogoURL { dict["companyLogoURL"] = companyLogoURL }
        if let industryCategory = service.industryCategory { dict["industryCategory"] = industryCategory }
        if let contactPersonName = service.contactPersonName { dict["contactPersonName"] = contactPersonName }
        if let contactPersonPhone = service.contactPersonPhone { dict["contactPersonPhone"] = contactPersonPhone }

        // Legacy/Special
        if let specialTools = service.specialTools { dict["specialTools"] = specialTools }
        if let serviceDate = service.serviceDate { dict["serviceDate"] = Timestamp(date: serviceDate) }
        if let estimatedDurationHours = service.estimatedDurationHours { dict["estimatedDurationHours"] = estimatedDurationHours }

        // Completion fields
        if let hiredApplicantId = service.hiredApplicantId { dict["hiredApplicantId"] = hiredApplicantId }
        if let completedAt = service.completedAt { dict["completedAt"] = Timestamp(date: completedAt) }
        if let completionRequestedAt = service.completionRequestedAt { dict["completionRequestedAt"] = Timestamp(date: completionRequestedAt) }
        if let completionNote = service.completionNote { dict["completionNote"] = completionNote }
        if let disputeReason = service.disputeReason { dict["disputeReason"] = disputeReason }

        // Job group
        if let jobGroupId = service.jobGroupId { dict["jobGroupId"] = jobGroupId }

        // Service tag
        if let serviceTag = service.serviceTag { dict["serviceTag"] = serviceTag }

        return dict
    }

    /// Create JobService from Firestore data
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
        let completionRequestedAt = (data["completionRequestedAt"] as? Timestamp)?.dateValue()
        let completionNote = data["completionNote"] as? String
        let disputeReason = data["disputeReason"] as? String

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
            breakDuration: data["breakDuration"] as? String,
            numberOfWorkersNeeded: data["numberOfWorkersNeeded"] as? Int,
            branchName: data["branchName"] as? String,
            nearestLandmark: data["nearestLandmark"] as? String,
            paymentMethod: data["paymentMethod"] as? String,
            paymentTiming: data["paymentTiming"] as? String,
            dressCode: data["dressCode"] as? String,
            minimumAge: data["minimumAge"] as? String,
            genderPreference: data["genderPreference"] as? String,
            physicalRequirements: data["physicalRequirements"] as? String,
            languageNeeded: data["languageNeeded"] as? String,
            whatToBring: data["whatToBring"] as? String,
            companyName: data["companyName"] as? String,
            companyLogoURL: data["companyLogoURL"] as? String,
            industryCategory: data["industryCategory"] as? String,
            contactPersonName: data["contactPersonName"] as? String,
            contactPersonPhone: data["contactPersonPhone"] as? String,
            someoneAround: someoneAround,
            specialTools: specialTools,
            serviceDate: serviceDate,
            estimatedDurationHours: estimatedDurationHours,
            applicationCount: applicationCount,
            hiredApplicantId: hiredApplicantId,
            completedAt: completedAt,
            isArchived: isArchived,
            completionRequestedAt: completionRequestedAt,
            completionNote: completionNote,
            disputeReason: disputeReason,
            jobGroupId: data["jobGroupId"] as? String,
            serviceTag: data["serviceTag"] as? String
        )
    }
}
