//
//  JobService+SampleData.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Mock Data

extension JobService {
    /// Sample activities for Recent Activity section
    static let sampleActivities: [ServiceActivity] = [
        ServiceActivity(
            service: sampleData[0],
            activityType: .appliedOn,
            status: "Status",
            extraDetails: sampleData[0].isFeatured ? "Featured Shift" : "Applications: \(sampleData[0].applicationCount)",
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
            title: "Barista Shift at Starbucks",
            price: 250,
            location: ServiceLocation(
                name: "Cairo Festival City",
                latitude: 30.0298,
                longitude: 31.4057
            ),
            description: "Looking for a dynamic barista for a single evening shift.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(),
            providerId: "provider-1",
            providerName: "Starbucks CFC",
            providerImageURL: nil,
            status: .published,
            isFeatured: true,
            category: .foodAndBeverage,
            address: "Ring Road",
            floor: "Ground",
            unit: "Store 42",
            breakDuration: "30 mins",
            numberOfWorkersNeeded: 2,
            branchName: "CFC Branch",
            paymentMethod: "Cash after shift",
            paymentTiming: "Same day",
            companyName: "Starbucks",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 1),
            estimatedDurationHours: 6.0,
            applicationCount: 5
        ),
        JobService(
            id: "service-2",
            title: "Warehouse Picker",
            price: 400,
            location: ServiceLocation(
                name: "Giza, Egypt",
                latitude: 30.0131,
                longitude: 31.2089
            ),
            description: "Help organize and pack orders in our fulfillment center.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -86400),
            providerId: "provider-2",
            providerName: "Noon Logistics",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .logisticsAndWarehousing,
            address: "Logistics Zone",
            floor: "1",
            unit: "Warehouse A",
            breakDuration: "45 mins",
            numberOfWorkersNeeded: 5,
            branchName: "Giza Hub",
            paymentMethod: "Bank Transfer",
            paymentTiming: "End of week",
            companyName: "Noon",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 2),
            estimatedDurationHours: 8.0,
            applicationCount: 12
        ),
        JobService(
            id: "service-3",
            title: "Sales Associate Shift",
            price: 300,
            location: ServiceLocation(
                name: "Mall of Arabia",
                latitude: 30.0074,
                longitude: 30.9733
            ),
            description: "Assist customers in the clothing section and manage fitting rooms.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -172800),
            providerId: "provider-3",
            providerName: "Zara MOA",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .retailAndMalls,
            address: "Juhayna Square",
            floor: "1",
            unit: "Store 12",
            breakDuration: "1 hour",
            numberOfWorkersNeeded: 3,
            branchName: "Mall of Arabia",
            paymentMethod: "In-app Wallet",
            paymentTiming: "Within 24h",
            companyName: "Zara",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 3),
            estimatedDurationHours: 8.0,
            applicationCount: 8
        ),
        JobService(
            id: "service-4",
            title: "Event Security Assistant",
            price: 500,
            location: ServiceLocation(
                name: "Zamalek, Egypt",
                latitude: 30.0667,
                longitude: 31.2333
            ),
            description: "Help with crowd management and ticket checking at a music concert.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -259200),
            providerId: "provider-4",
            providerName: "EventCo",
            providerImageURL: nil,
            status: .published,
            isFeatured: true,
            category: .securityAndCrowdManagement,
            address: "Cairo Opera House",
            floor: "Ground",
            unit: "Main Entrance",
            breakDuration: "1 hour",
            numberOfWorkersNeeded: 10,
            branchName: "Opera",
            paymentMethod: "Cash after shift",
            paymentTiming: "Same day",
            companyName: "EventCo Security",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 4),
            estimatedDurationHours: 6.0,
            applicationCount: 15
        ),
        JobService(
            id: "service-5",
            title: "Mall Cleaning Shift",
            price: 200,
            location: ServiceLocation(
                name: "Heliopolis, Egypt",
                latitude: 30.0667,
                longitude: 31.3333
            ),
            description: "Maintaining cleanliness of the common areas in the mall.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(timeIntervalSinceNow: -345600),
            providerId: "provider-5",
            providerName: "CleanMasters",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .cleaningAndMaintenance,
            address: "City Stars Mall",
            floor: "All",
            unit: "-",
            breakDuration: "30 mins",
            numberOfWorkersNeeded: 4,
            branchName: "City Stars",
            paymentMethod: "Bank Transfer",
            paymentTiming: "End of week",
            companyName: "CleanMasters",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 5),
            estimatedDurationHours: 8.0,
            applicationCount: 3
        ),
        JobService(
            id: "service-6",
            title: "Furniture Assembly Helper",
            price: 350,
            location: ServiceLocation(
                name: "Downtown Cairo, Egypt",
                latitude: 30.0626,
                longitude: 31.2454
            ),
            description: "Help assemble office furniture for a new branch.",
            image: ServiceImage(localId: nil, remoteURL: nil),
            createdAt: Date(),
            providerId: "provider-6",
            providerName: "IKEA Fleet",
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .movingAndLabour,
            address: "Tahrir Square",
            floor: "5",
            unit: "Office 501",
            breakDuration: "45 mins",
            numberOfWorkersNeeded: 2,
            branchName: "Downtown",
            paymentMethod: "In-app Wallet",
            paymentTiming: "Same day",
            companyName: "IKEA Installers",
            serviceDate: Date(timeIntervalSinceNow: 86400 * 10),
            estimatedDurationHours: 5.0,
            applicationCount: 2
        )
    ]
}
