//
//  ServicesStore.swift
//  Saadni
//
//  Created by Pavly Paules on 10/03/2026.
//

import FirebaseFirestore

@Observable
class ServicesStore {
 var services: [JobService] = []

 private var servicesListener: ListenerRegistration?

 private var db: Firestore {
  Firestore.firestore()
 }



 func startListening() {
  setupListeners()
 }
 
 deinit {
  servicesListener?.remove()
 }
 
 // MARK: - Real-time Listeners
 
    private func setupListeners() {
        // Listen to all published services
        servicesListener = db.collection("services")
   .whereField("status", in: ["published", "active"])
   .order(by: "createdAt", descending: true)
   .addSnapshotListener { [weak self] snapshot, error in
    guard let self = self else { return }
    
    if let error = error {
     print("❌ Error fetching services: \(error)")
     return
    }
    
    guard let documents = snapshot?.documents else { return }
    
    self.services = documents.compactMap { doc in
     do {
      return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
     } catch {
      print("⚠️ Failed to decode service \(doc.documentID): \(error)")
      return nil
     }
    }
    
    print("✅ Loaded \(self.services.count) services from Firestore")
   }
 }
 
 // MARK: - Add Services (with Image Upload)
 
 func addService(_ service: JobService, image: UIImage?) async throws {
  var updatedService = service

  // Upload image first, fail if it fails
  if let image = image {
   let imageURL = try await StorageService.shared.uploadServiceImage(image, serviceId: service.id, providerId: service.providerId)
   // ✅ Update the service object with the image URL before saving
   updatedService.image = ServiceImage(
    localId: updatedService.image.localId,
    remoteURL: imageURL.absoluteString,
    localImage: nil  // Clear local image after upload
   )
   print("✅ Image uploaded and service updated: \(service.id)")
  }

  // Then save service to Firestore
  try await FirestoreService.shared.saveService(updatedService)
 }
 
    // MARK: - Get Services (from memory, populated by listeners)

    func getAllServices() -> [JobService] {
        return services
    }

 // MARK: - Fetch Services by IDs

 func fetchServicesByIds(_ serviceIds: [String]) async -> [JobService] {
  guard !serviceIds.isEmpty else { return [] }

  var fetchedServices: [JobService] = []

  do {
   for serviceId in serviceIds {
    let snapshot = try await db.collection("services").document(serviceId).getDocument()
    do {
     let service = try JobService.fromFirestore(id: snapshot.documentID, data: snapshot.data() ?? [:])
     fetchedServices.append(service)
    } catch {
     print("⚠️ Failed to decode service \(serviceId): \(error)")
    }
   }
   print("✅ Fetched \(fetchedServices.count) services by IDs")
   return fetchedServices
  } catch {
   print("❌ Error fetching services by IDs: \(error)")
   return []
  }
 }

 // MARK: - Update Service
 
 func updateService(_ service: JobService) async throws {
  try await FirestoreService.shared.updateService(service)
 }
 
 // MARK: - Delete Service
 
 func removeService(id: String) async throws {
  try await FirestoreService.shared.deleteService(id: id)
 }
 
 // MARK: - Fetch User's Services (for My Jobs view)

 func fetchUserServices(userId: String) async -> [JobService] {
  var userServices: [JobService] = []

  do {
   let snapshot = try await db.collection("services")
    .whereField("providerId", isEqualTo: userId)
    .order(by: "createdAt", descending: true)
    .getDocuments()

   userServices = snapshot.documents.compactMap { doc in
    do {
     return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
    } catch {
     print("⚠️ Failed to decode user service \(doc.documentID): \(error)")
     return nil
    }
   }
  } catch {
   print("❌ Error fetching user services: \(error)")
  }

  return userServices
 }

 // MARK: - Service Status Transitions

 func markServiceAsActive(serviceId: String, hiredApplicantId: String) async throws {
  try await db.collection("services").document(serviceId).updateData([
   "status": ServiceStatus.active.rawValue,
   "hiredApplicantId": hiredApplicantId
  ])
  print("✅ Service marked as active: \(serviceId)")
 }

 func markServiceAsCompleted(serviceId: String) async throws {
  try await db.collection("services").document(serviceId).updateData([
   "status": ServiceStatus.completed.rawValue,
   "completedAt": Timestamp(date: Date())
  ])

  // Update provider statistics
  if let service = services.first(where: { $0.id == serviceId }) {
   try await incrementProviderJobsCompleted(providerId: service.providerId)
  }

  print("✅ Service marked as completed: \(serviceId)")
 }

 func archiveService(serviceId: String) async throws {
  try await db.collection("services").document(serviceId).updateData([
   "isArchived": true
  ])
  print("✅ Service archived: \(serviceId)")
 }

 func unarchiveService(serviceId: String) async throws {
  try await db.collection("services").document(serviceId).updateData([
   "isArchived": false
  ])
  print("✅ Service unarchived: \(serviceId)")
 }

 // MARK: - Provider Statistics

 private func incrementProviderJobsCompleted(providerId: String) async throws {
  try await db.collection("users").document(providerId).updateData([
   "totalJobsCompleted": FieldValue.increment(Int64(1))
  ])
  print("✅ Provider jobs completed incremented for: \(providerId)")
 }

 // MARK: - Fetch Completed Services

 func fetchCompletedServices(userId: String) async -> [JobService] {
  do {
   // Services where I was the provider
   let providerSnapshot = try await db.collection("services")
    .whereField("providerId", isEqualTo: userId)
    .whereField("status", isEqualTo: ServiceStatus.completed.rawValue)
    .whereField("isArchived", isEqualTo: false)
    .order(by: "completedAt", descending: true)
    .getDocuments()

   let providerServices = providerSnapshot.documents.compactMap { doc in
    do {
     return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
    } catch {
     print("⚠️ Failed to decode completed provider service \(doc.documentID): \(error)")
     return nil
    }
   }

   // Services where I was the hired applicant
   let applicantSnapshot = try await db.collection("services")
    .whereField("hiredApplicantId", isEqualTo: userId)
    .whereField("status", isEqualTo: ServiceStatus.completed.rawValue)
    .order(by: "completedAt", descending: true)
    .getDocuments()

   let applicantServices = applicantSnapshot.documents.compactMap { doc in
    do {
     return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
    } catch {
     print("⚠️ Failed to decode completed applicant service \(doc.documentID): \(error)")
     return nil
    }
   }

   let combined = (providerServices + applicantServices).sorted {
    ($0.completedAt ?? Date.distantPast) > ($1.completedAt ?? Date.distantPast)
   }

   print("✅ Fetched \(combined.count) completed services for user: \(userId)")
   return combined
  } catch {
   print("❌ Error fetching completed services: \(error)")
   return []
  }
 }

 // MARK: - Fetch Archived Services

 func fetchArchivedServices(userId: String) async -> [JobService] {
  do {
   let snapshot = try await db.collection("services")
    .whereField("providerId", isEqualTo: userId)
    .whereField("isArchived", isEqualTo: true)
    .order(by: "completedAt", descending: true)
    .getDocuments()

   let archived = snapshot.documents.compactMap { doc in
    do {
     return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
    } catch {
     print("⚠️ Failed to decode archived service \(doc.documentID): \(error)")
     return nil
    }
   }

   print("✅ Fetched \(archived.count) archived services for user: \(userId)")
   return archived
  } catch {
   print("❌ Error fetching archived services: \(error)")
   return []
  }
 }
}
