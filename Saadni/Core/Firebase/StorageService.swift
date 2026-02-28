import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage()

    private init() {}

    /// Upload service image to Firebase Storage
    func uploadServiceImage(_ image: UIImage, serviceId: String) async throws -> String {
        // Compress image
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "StorageService", code: 1,
                         userInfo: [NSLocalizedDescriptionKey: "Could not convert image to JPEG"])
        }

        // Create storage reference
        let imagePath = "services/\(serviceId)/image.jpg"
        let storageRef = storage.reference().child(imagePath)

        // Upload
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

        // Get download URL
        let downloadURL = try await storageRef.downloadURL()
        print("✅ Image uploaded to Firebase Storage: \(downloadURL.absoluteString)")
        return downloadURL.absoluteString
    }

    /// Delete service image from Storage
    func deleteServiceImage(url: String) async throws {
        let storageRef = storage.reference(forURL: url)
        try await storageRef.delete()
        print("✅ Image deleted from Firebase Storage: \(url)")
    }
}
