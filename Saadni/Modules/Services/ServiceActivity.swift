//
//  ServiceActivity.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

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
