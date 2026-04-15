//
//  StorageService.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService: StorageProvider {
 static let shared = StorageService()
 private let storage = Storage.storage()
 
 private init() {}
 
 /// Upload service image to Firebase Storage
 func uploadServiceImage(_ image: UIImage, serviceId: String, providerId: String) async throws -> URL {
  guard let imageData = image.jpegData(compressionQuality: 0.7) else {
   throw NSError(domain: "StorageService", code: 1,
                 userInfo: [NSLocalizedDescriptionKey: "Could not convert image to JPEG"])
  }
  return try await uploadServiceImageData(imageData, imageId: serviceId, providerId: providerId)
 }

 /// Upload pre-compressed image data to Firebase Storage (preferred — avoids double encoding)
 func uploadServiceImageData(_ data: Data, imageId: String, providerId: String) async throws -> URL {
  let imagePath = "services/\(providerId)/\(imageId)/image.jpg"
  let storageRef = storage.reference().child(imagePath)

  let metadata = StorageMetadata()
  metadata.contentType = "image/jpeg"

  let _ = try await storageRef.putDataAsync(data, metadata: metadata)

  let downloadURL = try await storageRef.downloadURL()
  print("✅ Image uploaded to Firebase Storage: \(downloadURL.absoluteString)")
  return downloadURL
 }
 
 /// Delete service image from Storage
 func deleteServiceImage(url: String) async throws {
  let storageRef = storage.reference(forURL: url)
  try await storageRef.delete()
  print("✅ Image deleted from Firebase Storage: \(url)")
 }

 /// Upload user profile image to Firebase Storage
 func uploadUserProfileImage(_ image: UIImage, userId: String) async throws -> String {
  // Compress image
  guard let imageData = image.jpegData(compressionQuality: 0.8) else {
   throw NSError(domain: "StorageService", code: 1,
                 userInfo: [NSLocalizedDescriptionKey: "Could not convert image to JPEG"])
  }

  // Create storage reference
  let imagePath = "users/\(userId)/profile.jpg"
  let storageRef = storage.reference().child(imagePath)

  // Upload
  let metadata = StorageMetadata()
  metadata.contentType = "image/jpeg"

  let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

  // Get download URL
  let downloadURL = try await storageRef.downloadURL()
  print("✅ User profile image uploaded: \(downloadURL.absoluteString)")
  return downloadURL.absoluteString
 }

 /// Upload proof-of-completion photo to Firebase Storage
 func uploadCompletionProof(_ image: UIImage, serviceId: String, workerId: String) async throws -> String {
  guard let imageData = image.jpegData(compressionQuality: 0.75) else {
   throw NSError(domain: "StorageService", code: 2,
                 userInfo: [NSLocalizedDescriptionKey: "Could not convert proof image to JPEG"])
  }
  let path = "completions/\(serviceId)/\(workerId).jpg"
  let ref = storage.reference().child(path)
  let metadata = StorageMetadata()
  metadata.contentType = "image/jpeg"
  let _ = try await ref.putDataAsync(imageData, metadata: metadata)
  let url = try await ref.downloadURL()
  print("✅ Completion proof uploaded: \(url.absoluteString)")
  return url.absoluteString
 }

 /// Delete user profile image from Storage
 func deleteUserProfileImage(userId: String) async throws {
  let imagePath = "users/\(userId)/profile.jpg"
  let storageRef = storage.reference().child(imagePath)
  try await storageRef.delete()
  print("✅ User profile image deleted for user: \(userId)")
 }

 /// Delete all Storage files belonging to a user.
 /// Called during account deletion — errors are logged but never thrown, so a
 /// Storage hiccup cannot block the auth-account deletion that already succeeded.
 func deleteUserFiles(userId: String, serviceImageURLs: [String], hiredServiceIds: [String]) async {
  // Profile photo
  let profilePath = "users/\(userId)/profile.jpg"
  do {
   try await storage.reference().child(profilePath).delete()
   print("✅ Deleted profile image for: \(userId)")
  } catch {
   print("⚠️ Could not delete profile image (may not exist): \(error.localizedDescription)")
  }

  // Service images this user posted
  for url in serviceImageURLs {
   do {
    try await storage.reference(forURL: url).delete()
    print("✅ Deleted service image: \(url)")
   } catch {
    print("⚠️ Could not delete service image \(url): \(error.localizedDescription)")
   }
  }

  // Completion proof photos for services where this user was the hired worker
  for serviceId in hiredServiceIds {
   let proofPath = "completions/\(serviceId)/\(userId).jpg"
   do {
    try await storage.reference().child(proofPath).delete()
    print("✅ Deleted completion proof: \(proofPath)")
   } catch {
    print("⚠️ Could not delete completion proof \(proofPath) (may not exist): \(error.localizedDescription)")
   }
  }

  print("✅ Storage cleanup complete for: \(userId)")
 }
}
