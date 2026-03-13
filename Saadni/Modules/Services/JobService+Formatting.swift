//
//  JobService+Formatting.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Computed Properties (Display & Formatting)

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
