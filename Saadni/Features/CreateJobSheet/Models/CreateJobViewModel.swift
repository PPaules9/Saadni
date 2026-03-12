//
//  CreateJobViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import MapKit
import FirebaseFirestore

enum AroundOption: String, CaseIterable {
    case you = "You"
    case someoneElse = "Someone Else"
    case noOne = "No One"
}

enum ToolsNeeded: String, CaseIterable {
    case yes = "Yes"
    case maybe = "Maybe"
    case no = "No"
}

enum ServiceTimeline: String, CaseIterable {
    case asap = "ASAP"
    case flexible = "Flexible"
    case specificDate = "Specific Date"
}

enum DurationOption: String, CaseIterable {
    case lessThanHour = "Less than 1 hour"
    case oneToThree = "1-3 hours"
    case fourToEight = "4-8 hours"
    case fullDay = "Full day (8+ hours)"
    case multipleDays = "Multiple days"
    case custom = "Custom"
}

@Observable
class CreateJobViewModel {
    // MARK: - Tab 1: Job Details & Location
    var jobName: String = ""
    var address: String = ""
    var floor: String = ""
    var unit: String = ""
    var city: String = ""

    // MARK: - Tab 2: Pictures & Around
    var selectedImage: UIImage?
    var aroundOption: AroundOption = .you

    // MARK: - Tab 3: Tools
    var toolsNeeded: ToolsNeeded = .yes
    var toolsDescription: String = ""

    // MARK: - Tab 4: Price
    var price: String = ""

    // MARK: - Tab 5: Schedule & Duration
    var serviceTimeline: ServiceTimeline = .flexible
    var specificDate: Date = Date()
    var durationOption: DurationOption = .oneToThree
    var customDurationHours: String = ""

    // MARK: - Tab 6: Details
    var otherDetails: String = ""

    // MARK: - Location & Service Properties
    var selectedLocation: CLLocationCoordinate2D?
    var selectedLocationName: String = ""
    var description: String = ""
    var currentUserId: String?

    // MARK: - Service Category Tags
    var selectedCategoryTags: Set<String> = []

    // MARK: - UI State
    var currentTab: Int = 0
    var showConfetti: Bool = false
    var showImagePicker: Bool = false
    var showMapSheet: Bool = false
    var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )
    )

    // MARK: - Validation
    var isTab1Valid: Bool {
        !jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isTab2Valid: Bool {
        selectedImage != nil
    }

    var isTab3Valid: Bool {
        if toolsNeeded == .yes {
            return !toolsDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }

    var isTab4Valid: Bool {
        guard let priceValue = Double(price), priceValue > 0 else { return false }
        return true
    }

    var isTab5Valid: Bool {
        // If specific date is selected, date must be in the future
        if serviceTimeline == .specificDate {
            return specificDate > Date()
        }
        // If custom duration is selected, must have valid hours
        if durationOption == .custom {
            guard let hours = Double(customDurationHours), hours > 0 else { return false }
            return true
        }
        return true
    }

    var isCurrentTabValid: Bool {
        switch currentTab {
        case 0: return isTab1Valid
        case 1: return isTab2Valid
        case 2: return isTab3Valid
        case 3: return isTab4Valid
        case 4: return isTab5Valid
        case 5: return true
        default: return false
        }
    }

    var isFormValid: Bool {
        let isTitleValid = !jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isPriceValid = Double(price) ?? 0 > 0
        let isImageValid = selectedImage != nil
        let isLocationValid = selectedLocation != nil && !city.isEmpty

        return isTitleValid && isPriceValid && isImageValid && isLocationValid
    }

    // MARK: - Navigation
    func canPublish() -> Bool {
        return isTab1Valid && isTab2Valid && isTab3Valid && isTab4Valid && isTab5Valid
    }

    func nextTab() {
        if currentTab < 5 {
            currentTab += 1
        }
    }

    func previousTab() {
        if currentTab > 0 {
            currentTab -= 1
        }
    }

    // MARK: - Schedule Helpers
    func getEstimatedDurationHours() -> Double? {
        switch durationOption {
        case .lessThanHour: return 0.5
        case .oneToThree: return 2.0
        case .fourToEight: return 6.0
        case .fullDay: return 8.0
        case .multipleDays: return 24.0
        case .custom: return Double(customDurationHours)
        }
    }

    func getServiceDate() -> Date? {
        return serviceTimeline == .specificDate ? specificDate : nil
    }

    // MARK: - Service Creation
    func createService(category: ServiceCategoryType) -> JobService? {
        guard isFormValid else { return nil }
        guard let priceValue = Double(price) else { return nil }
        guard let providerId = currentUserId else { return nil }

        let serviceLocation = ServiceLocation(
            name: city,
            coordinate: selectedLocation
        )

        let serviceImage = ServiceImage(
            localId: UUID().uuidString,
            remoteURL: nil,
            localImage: selectedImage
        )

        return JobService(
            title: jobName,
            price: priceValue,
            location: serviceLocation,
            description: otherDetails,
            image: serviceImage,
            category: category,
            providerId: providerId,
            address: address,
            floor: floor,
            unit: unit,
            someoneAround: aroundOption != .noOne,
            specialTools: toolsNeeded == .yes ? toolsDescription : nil,
            serviceDate: getServiceDate(),
            estimatedDurationHours: getEstimatedDurationHours(),
            status: .published
        )
    }

    func createServiceDraft(category: ServiceCategoryType) -> JobService? {
        guard let priceValue = Double(price), !jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let providerId = currentUserId else { return nil }

        let serviceLocation = ServiceLocation(
            name: city,
            coordinate: selectedLocation
        )

        let serviceImage = ServiceImage(
            localId: UUID().uuidString,
            remoteURL: nil,
            localImage: selectedImage
        )

        return JobService(
            title: jobName,
            price: priceValue,
            location: serviceLocation,
            description: otherDetails,
            image: serviceImage,
            category: category,
            providerId: providerId,
            address: address,
            floor: floor,
            unit: unit,
            someoneAround: aroundOption != .noOne,
            specialTools: toolsNeeded == .yes ? toolsDescription : nil,
            serviceDate: getServiceDate(),
            estimatedDurationHours: getEstimatedDurationHours(),
            status: .draft
        )
    }
}
