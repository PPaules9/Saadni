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

  var query: Query = db.collection(AppConstants.Firestore.services)
   .whereField("status", in: ["published", "active"])
   .order(by: "createdAt", descending: true)
   .limit(to: pageSize)

  if let category {
   query = db.collection(AppConstants.Firestore.services)
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
 
 // MARK: - Filtered Fetch (tag / date range)

 /// Search results shown when user types in BrowseJobsView search bar
 var searchResults: [JobService] = []
 var isSearching: Bool = false

 /// Fetch services filtered by serviceTag and/or a date range. Pagination-aware.
 func fetchServicesFiltered(
  tag: String? = nil,
  dateRange: ClosedRange<Date>? = nil,
  reset: Bool = false
 ) async {
  guard hasMoreServices || reset else { return }
  if reset {
   lastDocument = nil
   services = []
   hasMoreServices = true
  }
  isLoadingServices = true
  servicesError = nil

  var query: Query = db.collection(AppConstants.Firestore.services)
   .whereField("status", in: ["published", "active"])

  if let tag {
   query = query.whereField("serviceTag", isEqualTo: tag)
  }
  if let range = dateRange {
   query = query
    .whereField("serviceDate", isGreaterThanOrEqualTo: Timestamp(date: range.lowerBound))
    .whereField("serviceDate", isLessThanOrEqualTo: Timestamp(date: range.upperBound))
  }
  query = query.order(by: "serviceDate", descending: false).limit(to: pageSize)
  if let last = lastDocument { query = query.start(afterDocument: last) }

  do {
   let snapshot = try await query.getDocuments()
   lastDocument = snapshot.documents.last
   hasMoreServices = snapshot.documents.count == pageSize
   let newServices = snapshot.documents.compactMap { doc -> JobService? in
    try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
   }
   let existingIds = Set(services.map { $0.id })
   services.append(contentsOf: newServices.filter { !existingIds.contains($0.id) })
   servicesError = nil
  } catch {
   servicesError = "Failed to load services."
   print("❌ fetchServicesFiltered error: \(error)")
  }
  isLoadingServices = false
 }

 /// Server-side text search — prefix match on title field.
 func searchServices(query searchQuery: String) async {
  guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
   searchResults = []
   return
  }
  isSearching = true
  let lower = searchQuery
  let upper = searchQuery + "\u{f8ff}"
  do {
   let snapshot = try await db.collection(AppConstants.Firestore.services)
    .whereField("status", in: ["published", "active"])
    .whereField("title", isGreaterThanOrEqualTo: lower)
    .whereField("title", isLessThan: upper)
    .limit(to: 30)
    .getDocuments()
   searchResults = snapshot.documents.compactMap { doc -> JobService? in
    try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
   }
   print("🔍 Search '\(searchQuery)' returned \(searchResults.count) results")
  } catch {
   print("❌ searchServices error: \(error)")
   searchResults = []
  }
  isSearching = false
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
    let snapshot = try await db.collection(AppConstants.Firestore.services)
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

 /// Deletes every shift that shares the given jobGroupId.
 func bulkDeleteGroup(groupId: String, providerId: String) async throws {
  let siblings = try await fetchServicesByGroupId(groupId, providerId: providerId)
  for sibling in siblings {
   try await FirestoreService.shared.deleteService(id: sibling.id)
  }
  print("✅ Bulk deleted \(siblings.count) shifts in group \(groupId)")
 }
 
 // MARK: - Fetch User's Services (for My Jobs view)

 func fetchUserServices(userId: String) async -> [JobService] {
  var userServices: [JobService] = []

  do {
   let snapshot = try await db.collection(AppConstants.Firestore.services)
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
  try await db.collection(AppConstants.Firestore.services).document(serviceId).updateData([
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

  try await db.collection(AppConstants.Firestore.services).document(serviceId).updateData([
   "status": ServiceStatus.completed.rawValue,
   "completedAt": Timestamp(date: Date())
  ])

  // Update provider statistics
  try await incrementProviderJobsCompleted(providerId: service.providerId)

  print("✅ Service marked as completed: \(serviceId)")
 }

 func archiveService(serviceId: String) async throws {
  try await db.collection(AppConstants.Firestore.services).document(serviceId).updateData([
   "isArchived": true
  ])
  print("✅ Service archived: \(serviceId)")
 }

 func unarchiveService(serviceId: String) async throws {
  try await db.collection(AppConstants.Firestore.services).document(serviceId).updateData([
   "isArchived": false
  ])
  print("✅ Service unarchived: \(serviceId)")
 }

 // MARK: - Provider Statistics

 private func incrementProviderJobsCompleted(providerId: String) async throws {
  try await db.collection(AppConstants.Firestore.users).document(providerId).updateData([
   "totalJobsCompleted": FieldValue.increment(Int64(1))
  ])
  print("✅ Provider jobs completed incremented for: \(providerId)")
 }

 // MARK: - Fetch Completed Services

 func fetchCompletedServices(userId: String) async -> [JobService] {
  do {
   // Services where I was the provider
   let providerSnapshot = try await db.collection(AppConstants.Firestore.services)
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
   let applicantSnapshot = try await db.collection(AppConstants.Firestore.services)
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
   let snapshot = try await db.collection(AppConstants.Firestore.services)
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
 /// `providerId` must be supplied so the Firestore rules engine can verify
 /// `resource.data.providerId == uid()` on the collection query.
 func fetchServicesByGroupId(_ groupId: String, providerId: String) async throws -> [JobService] {
  let snapshot = try await db.collection(AppConstants.Firestore.services)
   .whereField("jobGroupId", isEqualTo: groupId)
   .whereField("providerId", isEqualTo: providerId)
   .order(by: "serviceDate", descending: false)
   .getDocuments()

  return snapshot.documents.compactMap { doc in
   try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
  }
 }

 /// Updates the shared fields on every shift in a group.
 /// Per-shift fields (serviceDate, status, hiredApplicantId, applicationCount, id) are preserved.
 ///
 /// Uses `updateData` (not `setData`) so only the listed fields are touched — Firestore
 /// merges them into the existing document without overwriting status, applicants, or any
 /// per-shift field that wasn't included in this dictionary.
 func bulkUpdateSharedFields(groupId: String, from updated: JobService) async throws {
  let siblings = try await fetchServicesByGroupId(groupId, providerId: updated.providerId)
  let batch = db.batch()

  // Build a dictionary of only the fields that are intentionally shared across shifts.
  // Per-shift fields (serviceDate, status, hiredApplicantId, applicationCount, id)
  // are intentionally excluded — they must not be overwritten.
  let sharedFields: [String: Any] = [
   "title": updated.title,
   "price": updated.price,
   "description": updated.description,
   "image": ["localId": updated.image.localId as Any, "remoteURL": updated.image.remoteURL as Any],
   "address": updated.address,
   "floor": updated.floor,
   "unit": updated.unit,
   "branchName": updated.branchName ?? NSNull(),
   "nearestLandmark": updated.nearestLandmark ?? NSNull(),
   "breakDuration": updated.breakDuration ?? NSNull(),
   "paymentMethod": updated.paymentMethod ?? NSNull(),
   "paymentTiming": updated.paymentTiming ?? NSNull(),
   "dressCode": updated.dressCode ?? NSNull(),
   "minimumAge": updated.minimumAge ?? NSNull(),
   "genderPreference": updated.genderPreference ?? NSNull(),
   "physicalRequirements": updated.physicalRequirements ?? NSNull(),
   "languageNeeded": updated.languageNeeded ?? NSNull(),
   "whatToBring": updated.whatToBring ?? NSNull(),
   "companyName": updated.companyName ?? NSNull(),
   "companyLogoURL": updated.companyLogoURL ?? NSNull(),
   "industryCategory": updated.industryCategory ?? NSNull(),
   "contactPersonName": updated.contactPersonName ?? NSNull(),
   "contactPersonPhone": updated.contactPersonPhone ?? NSNull(),
   "someoneAround": updated.someoneAround,
   "specialTools": updated.specialTools ?? NSNull(),
   "location": updated.location
  ]

  for sibling in siblings {
   let ref = db.collection(AppConstants.Firestore.services).document(sibling.id)
   batch.updateData(sharedFields, forDocument: ref)
  }

  try await batch.commit()
  print("✅ Bulk updated \(siblings.count) shifts in group \(groupId)")
 }

 /// Deletes Firebase Storage files for any image URLs that were removed from a service.
 /// Call this when updating a service's imageURLs to avoid accumulating orphaned Storage files.
 func deleteOrphanedImages(oldURLs: [String], newURLs: [String]) async {
  let removed = Set(oldURLs).subtracting(Set(newURLs))
  guard !removed.isEmpty else { return }
  for url in removed {
   do {
    try await StorageService.shared.deleteServiceImage(url: url)
    print("🗑️ Deleted orphaned image: \(url)")
   } catch {
    print("⚠️ Failed to delete orphaned image \(url): \(error)")
   }
  }
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
