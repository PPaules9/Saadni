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


/*
extension ServiceStatus {
 /// Check if service can be edited
 var isEditable: Bool {
  return self == .draft
 }
 
 /// Check if service is visible to others
 var isPublic: Bool {
  return self == .published
 }
 
 /// Display color for UI
 var displayColor: String {
  switch self {
  case .draft: return "gray"
  case .published: return "blue"
  case .active: return "green"
  case .completed: return "purple"
  case .cancelled: return "red"
  }
 }
}
*/
