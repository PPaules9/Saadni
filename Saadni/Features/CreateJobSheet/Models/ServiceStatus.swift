//
//  ServiceStatus.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//

import Foundation

/// Represents the lifecycle status of a service
enum ServiceStatus: String, Codable {
    /// Service is being created, not yet published
    case draft = "draft"

    /// Service is live and available in browse views
    case published = "published"

    /// Someone is currently working on the service
    case active = "active"

    /// Service has been completed and paid
    case completed = "completed"

    /// Service was cancelled before completion
    case cancelled = "cancelled"
}
