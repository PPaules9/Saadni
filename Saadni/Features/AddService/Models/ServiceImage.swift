//
//  ServiceImage.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//

import Foundation
import UIKit

/// Handles service images in both local and remote states
struct ServiceImage: Codable, Hashable {
  
 /// Temporary ID for local images before upload
 let localId: String?
 
 /// Firebase Storage URL after upload
 let remoteURL: String?
 
 /// The actual image data (NOT saved to Firebase)
 var localImage: UIImage?
 
 // MARK: - Codable Conformance
 
 /// Tells Codable to only encode localId and remoteURL
 enum CodingKeys: String, CodingKey {
  case localId
  case remoteURL
  // localImage intentionally omitted
 }
 
 // MARK: - Initializers
 
 /// Create from local image (when user picks)
 init(localImage: UIImage) {
  self.localId = UUID().uuidString
  self.remoteURL = nil
  self.localImage = localImage
 }
 
 /// Create from remote URL (when loading from Firebase)
 init(remoteURL: String) {
  self.localId = nil
  self.remoteURL = remoteURL
  self.localImage = nil
 }
 
 /// Create empty (no image)
 init() {
  self.localId = nil
  self.remoteURL = nil
  self.localImage = nil
 }
 
 /// Full initializer
 init(localId: String?, remoteURL: String?, localImage: UIImage? = nil) {
  self.localId = localId
  self.remoteURL = remoteURL
  self.localImage = localImage
 }
}

// MARK: - Hashable Conformance

extension ServiceImage {
 /// Custom hash (exclude localImage)
 func hash(into hasher: inout Hasher) {
  hasher.combine(localId)
  hasher.combine(remoteURL)
 }
 
 /// Custom equality (exclude localImage)
 static func == (lhs: ServiceImage, rhs: ServiceImage) -> Bool {
  return lhs.localId == rhs.localId &&
  lhs.remoteURL == rhs.remoteURL
 }
}

