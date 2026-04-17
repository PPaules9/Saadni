//
//  MockStorageService.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import UIKit

/// Mock Storage service for testing
/// Allows unit tests to run without Firebase Storage dependency
class MockStorageService: StorageProvider {
    // MARK: - Mock Data
    var uploadedImages: [String: (serviceId: String, providerId: String)] = [:]

    // MARK: - Error Configuration
    var shouldFailUpload = false
    var mockUploadURL: URL = URL(fileURLWithPath: "/mock/image.jpg")

    // MARK: - Storage Operations
    func uploadServiceImage(
        _ image: UIImage,
        serviceId: String,
        providerId: String
    ) async throws -> URL {
        if shouldFailUpload {
            throw AppError.firestore("Mock: Image upload failed")
        }

        let mockId = UUID().uuidString
        uploadedImages[mockId] = (serviceId: serviceId, providerId: providerId)
        print("✅ [Mock] Image uploaded: \(mockId)")

        return mockUploadURL // Already a URL type
    }

    func uploadServiceImageData(
        _ data: Data,
        imageId: String,
        providerId: String
    ) async throws -> URL {
        if shouldFailUpload {
            throw AppError.firestore("Mock: Image upload failed")
        }
        let mockId = UUID().uuidString
        uploadedImages[mockId] = (serviceId: imageId, providerId: providerId)
        print("✅ [Mock] Image data uploaded: \(mockId)")
        return mockUploadURL
    }

    // MARK: - Testing Utilities
    func reset() {
        uploadedImages.removeAll()
        shouldFailUpload = false
        mockUploadURL = URL(fileURLWithPath: "/mock/image.jpg")
    }

    func getUploadCount() -> Int {
        return uploadedImages.count
    }
}
