//
//  AddServiceViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//


import SwiftUI
import MapKit

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
 var selectedFlexibleCategory: FlexibleJobCategory? = nil

 
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

 
 func createFlexibleJobService(category: FlexibleJobCategory) -> FlexibleJobService? {
  guard isFormValid else { return nil }
  
  guard let priceValue = Double(price)
  else { return nil }
  
  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )
  
  return FlexibleJobService(
   id: UUID().uuidString,
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   createdAt: Date(),
   providerId: "temp_provider_123",
   providerName: nil,
   providerImageURL: nil,
   status: .published,
   isFeatured: false,
   category: category
  )
 }
 
 func createShiftService() -> ShiftService? {
  // Step 1: Validation
  guard isFormValid else { return nil }

  // Step 2: Convert price to Double
  guard let priceValue = Double(price) else { return nil }

  // Step 3: Create ServiceLocation (same as flexible job)
  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  // Step 4: Create ServiceImage (same as flexible job)
  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  // Step 5: Create ShiftSchedule - NEW!
  let shiftSchedule = ShiftSchedule(
   startDate: startDate,
   startTime: startTime,
   endTime: endTime,
   isRepeated: isRepeated,
   repeatDates: Array(selectedDates) // Convert Set<Date> to [Date]
  )

  // Step 6: Determine category vs customCategory
  let finalCategory: ShiftCategory? = useCustomCategory ? nil : selectedCategory
  let finalCustomCategory: String? = useCustomCategory ? customCategoryName : nil

  // Step 7: Create and return ShiftService
  return ShiftService(
   id: UUID().uuidString,
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   createdAt: Date(),
   providerId: "temp_provider_123",
   providerName: nil,
   providerImageURL: nil,
   status: .published,
   isFeatured: false,
   shiftName: shiftName,
   category: finalCategory,
   customCategory: finalCustomCategory,
   schedule: shiftSchedule
  )
 }

 // MARK: - Draft Methods
 func createFlexibleJobDraft(category: FlexibleJobCategory) -> FlexibleJobService? {
  guard let priceValue = Double(price), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  else { return nil }

  let serviceLocation = ServiceLocation(
   name: selectedLocationName,
   coordinate: selectedLocation
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: selectedImage
  )

  return FlexibleJobService(
   id: UUID().uuidString,
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   createdAt: Date(),
   providerId: "temp_provider_123",
   providerName: nil,
   providerImageURL: nil,
   status: .draft,
   isFeatured: false,
   category: category
  )
 }

 func createShiftDraft() -> ShiftService? {
  guard let priceValue = Double(price), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  else { return nil }

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

  return ShiftService(
   id: UUID().uuidString,
   title: title,
   price: priceValue,
   location: serviceLocation,
   description: description,
   image: serviceImage,
   createdAt: Date(),
   providerId: "temp_provider_123",
   providerName: nil,
   providerImageURL: nil,
   status: .draft,
   isFeatured: false,
   shiftName: shiftName,
   category: finalCategory,
   customCategory: finalCustomCategory,
   schedule: shiftSchedule
  )
 }
}

// MARK: - ServicesStore
import FirebaseFirestore

@Observable
class ServicesStore {
    var flexibleJobs: [FlexibleJobService] = []
    var shifts: [ShiftService] = []

    private var flexibleJobsListener: ListenerRegistration?
    private var shiftsListener: ListenerRegistration?
    private var db: Firestore {
        return Firestore.firestore()
    }

    // MARK: - Initialization
    init() {
        // Delay Firestore setup to allow Firebase to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupListeners()
        }
    }

    deinit {
        flexibleJobsListener?.remove()
        shiftsListener?.remove()
    }

    // MARK: - Real-time Listeners

    private func setupListeners() {
        // Listen to flexible jobs
        flexibleJobsListener = db.collection("services")
            .whereField("jobType", isEqualTo: "flexibleJobs")
            .whereField("status", in: ["published", "active"])
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching flexible jobs: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.flexibleJobs = documents.compactMap { doc in
                    try? FlexibleJobService.fromFirestore(id: doc.documentID, data: doc.data())
                }

                print("✅ Loaded \(self.flexibleJobs.count) flexible jobs from Firestore")
            }

        // Listen to shifts
        shiftsListener = db.collection("services")
            .whereField("jobType", isEqualTo: "shift")
            .whereField("status", in: ["published", "active"])
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching shifts: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.shifts = documents.compactMap { doc in
                    try? ShiftService.fromFirestore(id: doc.documentID, data: doc.data())
                }

                print("✅ Loaded \(self.shifts.count) shifts from Firestore")
            }
    }

    // MARK: - Add Services (with Firestore)

    func addFlexibleJob(_ service: FlexibleJobService) {
        Task {
            do {
                let docRef = db.collection("services").document(service.id)
                try await docRef.setData(service.toFirestore())
                print("✅ Flexible job added to Firestore: \(service.id)")
            } catch {
                print("❌ Error adding flexible job: \(error)")
            }
        }
    }

    func addShift(_ service: ShiftService) {
        Task {
            do {
                let docRef = db.collection("services").document(service.id)
                try await docRef.setData(service.toFirestore())
                print("✅ Shift added to Firestore: \(service.id)")
            } catch {
                print("❌ Error adding shift: \(error)")
            }
        }
    }

    // MARK: - Get Services (from memory, populated by listeners)

    func getAllFlexibleJobs() -> [FlexibleJobService] {
        return flexibleJobs
    }

    func getAllShifts() -> [ShiftService] {
        return shifts
    }

    // MARK: - Update Service

    func updateFlexibleJob(_ service: FlexibleJobService) {
        Task {
            do {
                let docRef = db.collection("services").document(service.id)
                try await docRef.updateData(service.toFirestore())
                print("✅ Flexible job updated: \(service.id)")
            } catch {
                print("❌ Error updating flexible job: \(error)")
            }
        }
    }

    func updateShift(_ service: ShiftService) {
        Task {
            do {
                let docRef = db.collection("services").document(service.id)
                try await docRef.updateData(service.toFirestore())
                print("✅ Shift updated: \(service.id)")
            } catch {
                print("❌ Error updating shift: \(error)")
            }
        }
    }

    // MARK: - Delete Service

    func removeFlexibleJob(id: String) {
        Task {
            do {
                try await db.collection("services").document(id).delete()
                print("✅ Flexible job deleted: \(id)")
            } catch {
                print("❌ Error deleting flexible job: \(error)")
            }
        }
    }

    func removeShift(id: String) {
        Task {
            do {
                try await db.collection("services").document(id).delete()
                print("✅ Shift deleted: \(id)")
            } catch {
                print("❌ Error deleting shift: \(error)")
            }
        }
    }

    // MARK: - Fetch User's Services (for My Jobs view)

    func fetchUserServices(userId: String) async -> ([FlexibleJobService], [ShiftService]) {
        var userFlexibleJobs: [FlexibleJobService] = []
        var userShifts: [ShiftService] = []

        do {
            // Fetch flexible jobs
            let flexibleSnapshot = try await db.collection("services")
                .whereField("providerId", isEqualTo: userId)
                .whereField("jobType", isEqualTo: "flexibleJobs")
                .order(by: "createdAt", descending: true)
                .getDocuments()

            userFlexibleJobs = flexibleSnapshot.documents.compactMap { doc in
                try? FlexibleJobService.fromFirestore(id: doc.documentID, data: doc.data())
            }

            // Fetch shifts
            let shiftsSnapshot = try await db.collection("services")
                .whereField("providerId", isEqualTo: userId)
                .whereField("jobType", isEqualTo: "shift")
                .order(by: "createdAt", descending: true)
                .getDocuments()

            userShifts = shiftsSnapshot.documents.compactMap { doc in
                try? ShiftService.fromFirestore(id: doc.documentID, data: doc.data())
            }
        } catch {
            print("❌ Error fetching user services: \(error)")
        }

        return (userFlexibleJobs, userShifts)
    }
}
