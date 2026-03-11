//
//  JobService.swift
//  Saadni
//
//  Created by Pavly Paules on 10/03/2026.
//

import Foundation
import FirebaseFirestore

/// Represents both flexible jobs and shift services in a unified model
struct JobService: Codable, Hashable, Identifiable {
 
 // MARK: - Identification
 
 /// Unique identifier (Firebase document ID)
 let id: String
 
 // MARK: - Core Service Data
 
 /// Service title (e.g., "Help me move furniture" or "Barista needed for weekend")
 var title: String
 
 /// Price in EGP
 var price: Double
 
 /// Where the service will be performed
 var location: ServiceLocation
 
 /// Detailed description of the service
 var description: String
 
 /// Service image
 var image: ServiceImage
 
 /// When this service was created
 var createdAt: Date
 
 /// Type of job (flexibleJobs or shift)
 var jobType: JobType
 
 // MARK: - Provider Information
 
 /// ID of the user who created this service
 var providerId: String
 
 /// Provider's display name (optional)
 var providerName: String?
 
 /// Provider's profile image URL (optional)
 var providerImageURL: String?
 
 // MARK: - Service Status & Metadata
 
 /// Current status (draft, published, active, completed, cancelled)
 var status: ServiceStatus
 
 /// Whether this service should be featured/highlighted
 var isFeatured: Bool
 
 /// Number of applications received (for real-time badge updates)
 var applicationCount: Int
 
 // MARK: - Flexible Job Specific
 
 /// Category of flexible job (only for flexibleJobs type)
 var category: ServiceCategoryType?
 
 // MARK: - Shift Specific
 
 /// Name of the shift (e.g., "Morning Shift") - only for shift type
 var shiftName: String?
 
 /// Predefined shift category (if user selected from list) - only for shift type
 var shiftCategory: ShiftCategory?
 
 /// Custom category name (if user entered custom) - only for shift type
 var customCategory: String?
 
 /// Shift scheduling information - only for shift type
 var schedule: ShiftSchedule?
 
 // MARK: - Initializers
 
 /// Create a flexible job from form data
 init(
  title: String,
  price: Double,
  location: ServiceLocation,
  description: String,
  image: ServiceImage,
  category: ServiceCategoryType,
  providerId: String,
  status: ServiceStatus = .draft
 ) {
  self.id = UUID().uuidString
  self.title = title
  self.price = price
  self.location = location
  self.description = description
  self.image = image
  self.category = category
  self.providerId = providerId
  self.providerName = nil
  self.providerImageURL = nil
  self.status = status
  self.isFeatured = false
  self.applicationCount = 0
  self.createdAt = Date()
  self.jobType = .flexibleJobs
  
  // Shift-specific (unused for flexible jobs)
  self.shiftName = nil
  self.shiftCategory = nil
  self.customCategory = nil
  self.schedule = nil
 }
 
 /// Create a shift from form data
 init(
  title: String,
  price: Double,
  location: ServiceLocation,
  description: String,
  image: ServiceImage,
  shiftName: String,
  shiftCategory: ShiftCategory?,
  customCategory: String?,
  schedule: ShiftSchedule,
  providerId: String,
  status: ServiceStatus = .draft
 ) {
  self.id = UUID().uuidString
  self.title = title
  self.price = price
  self.location = location
  self.description = description
  self.image = image
  self.shiftName = shiftName
  self.shiftCategory = shiftCategory
  self.customCategory = customCategory
  self.schedule = schedule
  self.providerId = providerId
  self.providerName = nil
  self.providerImageURL = nil
  self.status = status
  self.isFeatured = false
  self.applicationCount = 0
  self.createdAt = Date()
  self.jobType = .shift
  
  // Flexible job specific (unused for shifts)
  self.category = nil
 }
 
 /// Full initializer (for Firebase decoding)
 init(
  id: String,
  title: String,
  price: Double,
  location: ServiceLocation,
  description: String,
  image: ServiceImage,
  createdAt: Date,
  providerId: String,
  providerName: String?,
  providerImageURL: String?,
  status: ServiceStatus,
  isFeatured: Bool,
  jobType: JobType,
  category: ServiceCategoryType?,
  shiftName: String?,
  shiftCategory: ShiftCategory?,
  customCategory: String?,
  schedule: ShiftSchedule?,
  applicationCount: Int = 0
 ) {
  self.id = id
  self.title = title
  self.price = price
  self.location = location
  self.description = description
  self.image = image
  self.createdAt = createdAt
  self.providerId = providerId
  self.providerName = providerName
  self.providerImageURL = providerImageURL
  self.status = status
  self.isFeatured = isFeatured
  self.jobType = jobType
  self.category = category
  self.shiftName = shiftName
  self.shiftCategory = shiftCategory
  self.customCategory = customCategory
  self.schedule = schedule
  self.applicationCount = applicationCount
 }
}

// MARK: - Computed Properties

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
 
 /// Get the category name (for shifts: either predefined or custom)
 var categoryDisplayName: String {
  if jobType == .shift {
   if let customCategory = customCategory, !customCategory.isEmpty {
    return customCategory
   }
   return shiftCategory?.rawValue ?? "Unknown"
  } else {
   return category?.rawValue ?? "Unknown"
  }
 }
 
 /// Total number of shifts (for shifts only)
 var totalShifts: Int {
  return schedule?.totalShifts ?? 0
 }
 
 /// Duration of each shift in hours (for shifts only)
 var shiftDuration: Double {
  return schedule?.durationInHours ?? 0
 }
}

// MARK: - Firestore Conversion

extension JobService {
 /// Convert to Firestore dictionary
 func toFirestore() -> [String: Any] {
  var dict: [String: Any] = [
   "id": id,
   "title": title,
   "price": price,
   "description": description,
   "createdAt": Timestamp(date: createdAt),
   "providerId": providerId,
   "status": status.rawValue,
   "isFeatured": isFeatured,
   "jobType": jobType.rawValue,
   "applicationCount": applicationCount,
   
   // Location
   "location": [
    "name": location.name,
    "latitude": location.latitude as Any,
    "longitude": location.longitude as Any
   ],
   
   // Image
   "image": [
    "localId": image.localId as Any,
    "remoteURL": image.remoteURL as Any
   ]
  ]
  
  // Optional provider fields
  if let providerName = providerName {
   dict["providerName"] = providerName
  }
  if let providerImageURL = providerImageURL {
   dict["providerImageURL"] = providerImageURL
  }
  
  // Flexible job specific fields
  if let category = category {
   dict["category"] = category.rawValue
  }
  
  // Shift specific fields
  if let shiftName = shiftName {
   dict["shiftName"] = shiftName
  }
  if let shiftCategory = shiftCategory {
   dict["shiftCategory"] = shiftCategory.rawValue
  }
  if let customCategory = customCategory {
   dict["customCategory"] = customCategory
  }
  if let schedule = schedule {
   dict["schedule"] = [
    "startDate": Timestamp(date: schedule.startDate),
    "startTime": Timestamp(date: schedule.startTime),
    "endTime": Timestamp(date: schedule.endTime),
    "isRepeated": schedule.isRepeated,
    "repeatDates": schedule.repeatDates.map { Timestamp(date: $0) }
   ]
  }
  
  return dict
 }
 
 /// Create from Firestore data
 static func fromFirestore(id: String, data: [String: Any]) throws -> JobService {
  guard let title = data["title"] as? String,
        let price = data["price"] as? Double,
        let description = data["description"] as? String,
        let providerId = data["providerId"] as? String,
        let statusRaw = data["status"] as? String,
        let status = ServiceStatus(rawValue: statusRaw),
        let isFeatured = data["isFeatured"] as? Bool,
        let jobTypeRaw = data["jobType"] as? String,
        let jobType = JobType(rawValue: jobTypeRaw),
        let locationData = data["location"] as? [String: Any],
        let locationName = locationData["name"] as? String
  else {
   throw NSError(domain: "FirestoreDecoding", code: 1,
                 userInfo: [NSLocalizedDescriptionKey: "Missing required fields"])
  }
  
  let location = ServiceLocation(
   name: locationName,
   latitude: locationData["latitude"] as? Double,
   longitude: locationData["longitude"] as? Double
  )
  
  let imageData = data["image"] as? [String: Any]
  let image = ServiceImage(
   localId: imageData?["localId"] as? String,
   remoteURL: imageData?["remoteURL"] as? String
  )
  
  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
  let applicationCount = data["applicationCount"] as? Int ?? 0
  
  // Parse flexible job category
  let categoryRaw = data["category"] as? String
  let category = categoryRaw.flatMap { ServiceCategoryType(rawValue: $0) }
  
  // Parse shift fields
  let shiftName = data["shiftName"] as? String
  let shiftCategoryRaw = data["shiftCategory"] as? String
  let shiftCategory = shiftCategoryRaw.flatMap { ShiftCategory(rawValue: $0) }
  let customCategory = data["customCategory"] as? String
  
  var schedule: ShiftSchedule? = nil
  if let scheduleData = data["schedule"] as? [String: Any] {
   let startDate = (scheduleData["startDate"] as? Timestamp)?.dateValue() ?? Date()
   let startTime = (scheduleData["startTime"] as? Timestamp)?.dateValue() ?? Date()
   let endTime = (scheduleData["endTime"] as? Timestamp)?.dateValue() ?? Date()
   let isRepeated = scheduleData["isRepeated"] as? Bool ?? false
   let repeatDatesTimestamps = scheduleData["repeatDates"] as? [Timestamp] ?? []
   let repeatDates = repeatDatesTimestamps.map { $0.dateValue() }
   
   schedule = ShiftSchedule(
    startDate: startDate,
    startTime: startTime,
    endTime: endTime,
    isRepeated: isRepeated,
    repeatDates: repeatDates
   )
  }
  
  return JobService(
   id: id,
   title: title,
   price: price,
   location: location,
   description: description,
   image: image,
   createdAt: createdAt,
   providerId: providerId,
   providerName: data["providerName"] as? String,
   providerImageURL: data["providerImageURL"] as? String,
   status: status,
   isFeatured: isFeatured,
   jobType: jobType,
   category: category,
   shiftName: shiftName,
   shiftCategory: shiftCategory,
   customCategory: customCategory,
   schedule: schedule,
   applicationCount: applicationCount
  )
 }
}

// MARK: - Mock Data

extension JobService {
 static let mockFlexibleJob1 = JobService(
  title: "Help me clean my apartment",
  price: 150.0,
  location: ServiceLocation(
   name: "Nasr City, Cairo",
   latitude: 30.0444,
   longitude: 31.2357
  ),
  description: "Need help cleaning a 2-bedroom apartment. Should take about 3 hours.",
  image: ServiceImage(),
  category: .homeCleaning,
  providerId: "user123"
 )
 
 static let mockFlexibleJob2 = JobService(
  title: "Grocery shopping needed",
  price: 50.0,
  location: ServiceLocation(
   name: "Maadi, Cairo",
   latitude: 29.9602,
   longitude: 31.2569
  ),
  description: "Please pick up groceries from Carrefour. List will be provided.",
  image: ServiceImage(),
  category: .groceryShopping,
  providerId: "user456"
 )
 
 static let mockShift1 = JobService(
  title: "Barista needed for weekend",
  price: 100.0,
  location: ServiceLocation(
   name: "Zamalek, Cairo",
   latitude: 30.0626,
   longitude: 31.2206
  ),
  description: "Looking for an experienced barista for Saturday morning shift.",
  image: ServiceImage(),
  shiftName: "Weekend Morning Shift",
  shiftCategory: .barista,
  customCategory: nil,
  schedule: ShiftSchedule(
   startDate: Date(),
   startTime: Date(),
   endTime: Date().addingTimeInterval(3600 * 6)
  ),
  providerId: "user789"
 )
 
 static let mockShift2 = JobService(
  title: "Event photographer wanted",
  price: 300.0,
  location: ServiceLocation(
   name: "New Cairo",
   latitude: 30.0330,
   longitude: 31.4920
  ),
  description: "Need a photographer for a corporate event. 4 hours.",
  image: ServiceImage(),
  shiftName: "Corporate Event",
  shiftCategory: .photographer,
  customCategory: nil,
  schedule: ShiftSchedule(
   startDate: Date().addingTimeInterval(86400 * 7),
   startTime: Date(),
   endTime: Date().addingTimeInterval(3600 * 4)
  ),
  providerId: "user101"
 )
}
