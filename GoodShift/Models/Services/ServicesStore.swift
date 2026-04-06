//
//  ServicesStore.swift
//  GoodShift
//
//  Created by Pavly Paules on 10/03/2026.
//

import FirebaseFirestore

@Observable
class ServicesStore: ListenerManaging {
 var services: [JobService] = []

 // MARK: - Error States
 var isLoadingServices: Bool = false
 var servicesError: String? = nil

 // MARK: - Pagination State
 private var lastDocument: QueryDocumentSnapshot?
 private(set) var hasMoreServices: Bool = true
 private let pageSize = 20

 // MARK: - Listener Management (from ListenerManaging protocol)
 var activeListeners: [String: ListenerRegistration] = [:]
 var listenerSetupState: [String: Bool] = [:]

 private var db: Firestore {
  Firestore.firestore()
 }

 // MARK: - Paginated Fetch (replaces real-time listener)

 /// Fetches the next page of published/active services.
 /// Call with reset: true when changing category or doing pull-to-refresh.
 func fetchServicesPage(category: ServiceCategoryType? = nil, reset: Bool = false) async {
  guard hasMoreServices || reset else { return }

  if reset {
   lastDocument = nil
   services = []
   hasMoreServices = true
  }

  isLoadingServices = true
  servicesError = nil

  var query: Query = db.collection("services")
   .whereField("status", in: ["published", "active"])
   .order(by: "createdAt", descending: true)
   .limit(to: pageSize)

  if let category {
   query = db.collection("services")
    .whereField("status", in: ["published", "active"])
    .whereField("category", isEqualTo: category.rawValue)
    .order(by: "createdAt", descending: true)
    .limit(to: pageSize)
  }

  if let last = lastDocument {
   query = query.start(afterDocument: last)
  }

  do {
   let snapshot = try await query.getDocuments()
   lastDocument = snapshot.documents.last
   hasMoreServices = snapshot.documents.count == pageSize

   let newServices = snapshot.documents.compactMap { doc -> JobService? in
    do {
     return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
    } catch {
     print("⚠️ Failed to decode service \(doc.documentID): \(error)")
     return nil
    }
   }

   let existingIds = Set(services.map { $0.id })
   services.append(contentsOf: newServices.filter { !existingIds.contains($0.id) })
   servicesError = nil
   print("✅ Fetched \(newServices.count) services (total: \(services.count), hasMore: \(hasMoreServices))")
  } catch {
   servicesError = "Failed to load services. Check your connection."
   print("❌ Error fetching services: \(error)")
  }

  isLoadingServices = false
 }
 
 // MARK: - Add Services (with Image Upload)
 
 /// Save a service to Firestore. The image must already be resolved (remoteURL or assetName)
 /// before calling this — upload happens in the caller, not here.
 func addService(_ service: JobService) async throws {
  try ServiceValidator.canPublish(service)
  try await FirestoreService.shared.saveService(service)
 }
 
    // MARK: - Get Services (from memory, populated by paginated fetch)

    func getAllServices() -> [JobService] {
        return services
    }

 // MARK: - Fetch Services by IDs (batched — no N+1)

 func fetchServicesByIds(_ serviceIds: [String]) async -> [JobService] {
  guard !serviceIds.isEmpty else { return [] }

  var fetchedServices: [JobService] = []

  // Firestore "in" queries support max 30 items per query
  let chunks = stride(from: 0, to: serviceIds.count, by: 30).map {
   Array(serviceIds[$0..<min($0 + 30, serviceIds.count)])
  }

  do {
   for chunk in chunks {
    let snapshot = try await db.collection("services")
     .whereField(FieldPath.documentID(), in: chunk)
     .getDocuments()
    let decoded = snapshot.documents.compactMap { doc -> JobService? in
     do {
      return try JobService.fromFirestore(id: doc.documentID, data: doc.data())
     } catch {
      print("⚠️ Failed to decode service \(doc.documentID): \(error)")
      return nil
     }
    }
    fetchedServices.append(contentsOf: decoded)
   }
   servicesError = nil
   print("✅ Fetched \(fetchedServices.count) services by IDs (\(chunks.count) batch(es))")
   return fetchedServices
  } catch {
   servicesError = "Failed to load services. Check your connection."
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

   servicesError = nil
  } catch {
   servicesError = "Failed to load your services. Check your connection."
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
  // Validate service state before completion
  guard let service = services.first(where: { $0.id == serviceId }) else {
   throw NSError(
    domain: "ServicesStore",
    code: 1,
    userInfo: [NSLocalizedDescriptionKey: "Service not found: \(serviceId)"]
   )
  }

  try ServiceValidator.canMarkAsCompleted(service)

  try await db.collection("services").document(serviceId).updateData([
   "status": ServiceStatus.completed.rawValue,
   "completedAt": Timestamp(date: Date())
  ])

  // Update provider statistics
  try await incrementProviderJobsCompleted(providerId: service.providerId)

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

   servicesError = nil
   print("✅ Fetched \(combined.count) completed services for user: \(userId)")
   return combined
  } catch {
   servicesError = "Failed to load completed services. Check your connection."
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

   servicesError = nil
   print("✅ Fetched \(archived.count) archived services for user: \(userId)")
   return archived
  } catch {
   servicesError = "Failed to load archived services. Check your connection."
   print("❌ Error fetching archived services: \(error)")
   return []
  }
 }

 // MARK: - Job Group Operations

 /// Fetches all shifts that share the same jobGroupId.
 func fetchServicesByGroupId(_ groupId: String) async throws -> [JobService] {
  let snapshot = try await db.collection("services")
   .whereField("jobGroupId", isEqualTo: groupId)
   .order(by: "serviceDate", descending: false)
   .getDocuments()

  return snapshot.documents.compactMap { doc in
   try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
  }
 }

 /// Updates the shared fields on every shift in a group.
 /// Per-shift fields (serviceDate, status, hiredApplicantId, applicationCount, id) are preserved.
 func bulkUpdateSharedFields(groupId: String, from updated: JobService) async throws {
  let siblings = try await fetchServicesByGroupId(groupId)
  let batch = db.batch()

  for sibling in siblings {
   var patched = sibling
   patched.title = updated.title
   patched.price = updated.price
   patched.location = updated.location
   patched.description = updated.description
   patched.image = updated.image
   patched.address = updated.address
   patched.floor = updated.floor
   patched.unit = updated.unit
   patched.branchName = updated.branchName
   patched.nearestLandmark = updated.nearestLandmark
   patched.breakDuration = updated.breakDuration
   patched.paymentMethod = updated.paymentMethod
   patched.paymentTiming = updated.paymentTiming
   patched.dressCode = updated.dressCode
   patched.minimumAge = updated.minimumAge
   patched.genderPreference = updated.genderPreference
   patched.physicalRequirements = updated.physicalRequirements
   patched.languageNeeded = updated.languageNeeded
   patched.whatToBring = updated.whatToBring
   patched.companyName = updated.companyName
   patched.companyLogoURL = updated.companyLogoURL
   patched.industryCategory = updated.industryCategory
   patched.contactPersonName = updated.contactPersonName
   patched.contactPersonPhone = updated.contactPersonPhone
   patched.someoneAround = updated.someoneAround
   patched.specialTools = updated.specialTools

   let ref = db.collection("services").document(sibling.id)
   batch.setData(patched.toFirestore(), forDocument: ref)
  }

  try await batch.commit()
  print("✅ Bulk updated \(siblings.count) shifts in group \(groupId)")
 }

 // MARK: - Retry Logic


  func retryLoadingServices() {
    Task { await fetchServicesPage(reset: true) }
  }

  // MARK: - Cleanup Implementation

  /// Clear all services and reset pagination state
  func removeAllListeners() {
    print("🧹 [ServicesStore] Clearing data and resetting state...")

    // Remove Firestore listeners (if any were added in the future)
    activeListeners.values.forEach { $0.remove() }
    activeListeners.removeAll()
    listenerSetupState.removeAll()

    // Clear local data
    services = []
    lastDocument = nil
    hasMoreServices = true
    isLoadingServices = false
    servicesError = nil
    
    print("🧹 [ServicesStore] State cleared")
  }

  deinit {
    removeAllListeners()
  }
}
