//
//  JobService+SampleData.swift
//  Saadni
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
