//
//  AddServiceViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//


import SwiftUI
import MapKit
import FirebaseFirestore

@Observable
class AddServiceViewModel {
 // MARK: - Common Properties
 var title: String = ""
 var price: String = ""
 var description: String = ""
 var selectedImage: UIImage?
 var selectedLocation: CLLocationCoordinate2D?
 var selectedLocationName: String = ""
 var jobType: JobType? = nil
 var currentUserId: String?

 // MARK: - Shift Properties
 var shiftName: String = ""
 var selectedCategory: ShiftCategory? = .barista
 var customCategoryName: String = ""
 var useCustomCategory: Bool = false
 var startTime: Date = Date()
 var endTime: Date = Date().addingTimeInterval(3600 * 8)
 var startDate: Date = Date()
 var isRepeated: Bool = false
 var selectedDates: Set<Date> = []

 // MARK: - Flexible Job Properties
 var selectedFlexibleCategory: ServiceCategoryType? = nil


 // MARK: - UI State
 var showImagePicker: Bool = false
 var showMapSheet: Bool = false
 var showJobTypeSheet: Bool = false
 var showJobCategorySheet: Bool = false
 var showCalendar: Bool = false
 var mapPosition: MapCameraPosition = .region(
  MKCoordinateRegion(
   center: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
   span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
  )
 )
 var selectedJobPath: String = ""  // Display string

 // MARK: - Computed Properties
 var jobTypeDisplayName: String {
  switch jobType {
  case .flexibleJobs: return "Flexible Job"
  case .shift: return "Shift Job"
  case nil: return "Select Job Type"
  }
 }
 
 
 
 // MARK: - Validation
 var isFormValid: Bool {
  let isTitleValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  let isPriceValid = Double(price) ?? 0 > 0
  let isImageValid = selectedImage != nil
  let isLocationValid = selectedLocation != nil && !selectedLocationName.isEmpty
  let isJobTypeValid = jobType != nil
  let isShiftValid = jobType == .shift ? !shiftName.trimmingCharacters(in: .whitespaces).isEmpty : true

  return isTitleValid && isPriceValid && isImageValid &&
  isLocationValid && isJobTypeValid && isShiftValid
 }

 
 func createJobService(category: ServiceCategoryType) -> JobService? {
  guard isFormValid else { return nil }
  guard let priceValue = Double(price) else { return nil }
  guard let providerId = currentUserId else { return nil }

  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  return JobService(
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   category: category,
   providerId: providerId,
   status: .published
  )
 }
 
 func createShiftService() -> JobService? {
  // Step 1: Validation
  guard isFormValid else { return nil }
  guard let priceValue = Double(price) else { return nil }
  guard let providerId = currentUserId else { return nil }

  // Step 2: Create ServiceLocation
  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  // Step 3: Create ServiceImage
  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  // Step 4: Create ShiftSchedule
  let shiftSchedule = ShiftSchedule(
   startDate: startDate,
   startTime: startTime,
   endTime: endTime,
   isRepeated: isRepeated,
   repeatDates: Array(selectedDates)
  )

  // Step 5: Determine category vs customCategory
  let finalCategory: ShiftCategory? = useCustomCategory ? nil : selectedCategory
  let finalCustomCategory: String? = useCustomCategory ? customCategoryName : nil

  // Step 6: Create and return JobService
  return JobService(
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   shiftName: shiftName,
   shiftCategory: finalCategory,
   customCategory: finalCustomCategory,
   schedule: shiftSchedule,
   providerId: providerId,
   status: .published
  )
 }

 // MARK: - Draft Methods
 func createFlexibleJobDraft(category: ServiceCategoryType) -> JobService? {
  guard let priceValue = Double(price), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
  guard let providerId = currentUserId else { return nil }

  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  return JobService(
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   category: category,
   providerId: providerId,
   status: .draft
  )
 }

 func createShiftDraft() -> JobService? {
  guard let priceValue = Double(price), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
  guard let providerId = currentUserId else { return nil }

  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  let shiftSchedule = ShiftSchedule(
   startDate: startDate,
   startTime: startTime,
   endTime: endTime,
   isRepeated: isRepeated,
   repeatDates: Array(selectedDates)
  )

  let finalCategory: ShiftCategory? = useCustomCategory ? nil : selectedCategory
  let finalCustomCategory: String? = useCustomCategory ? customCategoryName : nil

  return JobService(
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   shiftName: shiftName,
   shiftCategory: finalCategory,
   customCategory: finalCustomCategory,
   schedule: shiftSchedule,
   providerId: providerId,
   status: .draft
  )
 }
}
