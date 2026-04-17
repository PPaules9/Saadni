//
//  StorageProvider.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import SwiftUI

/// Protocol for Firebase Storage operations
/// Enables dependency injection and testing with mock implementations
protocol StorageProvider {
    func uploadServiceImage(
        _ image: UIImage,
        serviceId: String,
        providerId: String
    ) async throws -> URL

    func uploadServiceImageData(
        _ data: Data,
        imageId: String,
        providerId: String
    ) async throws -> URL
}
