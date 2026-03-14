//
//  StorageProvider.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import UIKit

/// Protocol for Firebase Storage operations
/// Enables dependency injection and testing with mock implementations
protocol StorageProvider {
    /// Uploads a service image to storage
    /// - Parameters:
    ///   - image: The UIImage to upload
    ///   - serviceId: The service ID for organization
    ///   - providerId: The provider ID for organization
    /// - Returns: The download URL of the uploaded image
    func uploadServiceImage(
        _ image: UIImage,
        serviceId: String,
        providerId: String
    ) async throws -> URL
}
