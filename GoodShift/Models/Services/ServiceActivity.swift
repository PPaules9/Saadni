//
//  ServiceActivity.swift
//  GoodShift
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

// MARK: - Factory from real application data
extension ServiceActivity {
    /// Maps a real JobApplication + its JobService into a displayable activity.
    /// Returns nil for withdrawn applications (they don't appear in the feed).
    init?(application: JobApplication, service: JobService) {
        self.service = service

        switch application.status {
        case .pending:
            activityType = .appliedOn
            status = "Pending Review"
            extraDetails = application.appliedAt.relativeFormatted()
            isHighlighted = false

        case .accepted:
            let isFuture = service.serviceDate.map { $0 > Date() } ?? false
            activityType = isFuture ? .upcoming : .appliedOn
            status = isFuture ? "Starting On" : "In Progress"
            extraDetails = service.serviceDate?.shortFormatted()
                ?? application.respondedAt?.relativeFormatted()
                ?? ""
            isHighlighted = true

        case .rejected:
            activityType = .finished
            status = "Not Selected"
            extraDetails = application.respondedAt?.relativeFormatted() ?? ""
            isHighlighted = false

        case .completed:
            activityType = .finished
            status = "Earned \(service.formattedPrice)"
            extraDetails = application.respondedAt?.relativeFormatted() ?? ""
            isHighlighted = true

        case .withdrawn:
            return nil
        }
    }
}
