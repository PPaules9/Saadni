//
//  ApplicationsStore.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseFirestore

@Observable
class ApplicationsStore: ListenerManaging {
 // MARK: - State
 var myApplications: [JobApplication] = []       // Applications I submitted
 var receivedApplications: [JobApplication] = [] // Applications to my services

 // MARK: - Error States
 var isLoadingApplications: Bool = false
 var applicationsError: AppError? = nil

 // MARK: - Listener Management (from ListenerManaging protocol)
 var activeListeners: [String: ListenerRegistration] = [:]
 var listenerSetupState: [String: Bool] = [:]

 private var currentUserId: String?

 private var db: Firestore {
  Firestore.firestore()
 }

 // MARK: - Initialization
 init() {}

 deinit {
  removeAllListeners()
 }

 // MARK: - Listener Management Implementation

 func addListener(id: String, listener: ListenerRegistration) {
  removeListener(id: id)
  activeListeners[id] = listener
  print("📡 [Listener] Added: \(id) (total active: \(activeListeners.count))")
 }

 func removeListener(id: String) {
  if let listener = activeListeners.removeValue(forKey: id) {
   listener.remove()
   print("🧹 [Listener] Removed: \(id) (total active: \(activeListeners.count))")
  }
 }

 func removeAllListeners() {
  print("🧹 [Listener] Removing all \(activeListeners.count) listeners...")
  activeListeners.values.forEach { $0.remove() }
  activeListeners.removeAll()
  listenerSetupState.removeAll()
  print("🧹 [Listener] All listeners removed")
 }

 // MARK: - Setup Listeners

 /// Sets up real-time listeners for user applications (submitted and received)
 /// - Parameter userId: The user ID to listen for applications
 /// - Throws: Firestore errors during listener setup
 func setupListeners(userId: String) async throws {
  removeAllListeners()

  currentUserId = userId
  isLoadingApplications = true
  applicationsError = nil

  // Setup my applications listener
  let listenerId = "myApplications"
  guard !isListenerActive(id: listenerId) else {
    print("⚠️ Listener already active for my applications")
    return
  }

  let listener = db.collection("applications")
   .whereField("applicantId", isEqualTo: userId)
   .order(by: "appliedAt", descending: true)
   .addSnapshotListener { [weak self] snapshot, error in
    guard let self = self else { return }

    if let error = error {
     self.applicationsError = AppError.from(error)
     self.isLoadingApplications = false
     print("❌ Error fetching my applications: \(error)")
     return
    }

    guard let documents = snapshot?.documents else { return }

    let decoded = documents.compactMap { doc in
     do {
      return try Firestore.Decoder().decode(JobApplication.self, from: doc.data())
     } catch {
      print("⚠️ Failed to decode my application \(doc.documentID): \(error)")
      return nil
     }
    }

    Task { @MainActor in
     self.myApplications = decoded
     self.applicationsError = nil
     print("✅ Loaded \(self.myApplications.count) my applications")
    }
   }

  addListener(id: listenerId, listener: listener)

  // Listen to applications received on my services
  try await setupReceivedApplicationsListener(userId: userId)

  isLoadingApplications = false
  print("🔄 [ApplicationsStore] Listeners setup for user: \(userId)")
 }

 private func setupReceivedApplicationsListener(userId: String) async throws {
  // Get all service IDs created by this user
  let servicesSnapshot = try await db.collection("services")
   .whereField("providerId", isEqualTo: userId)
   .getDocuments()

  let serviceIds = servicesSnapshot.documents.map { $0.documentID }

  if serviceIds.isEmpty {
   print("📝 User has no services, no applications to receive")
   return
  }

  // Batch into chunks of 10 (Firestore "in" query limit)
  let chunks = stride(from: 0, to: serviceIds.count, by: 10).map { startIndex in
   Array(serviceIds[startIndex..<min(startIndex + 10, serviceIds.count)])
  }

  print("ℹ️ Setting up \(chunks.count) listener(s) for \(serviceIds.count) services")

  // Setup listener for each chunk with deduplication
  for (index, serviceIdChunk) in chunks.enumerated() {
   let listenerId = "receivedApplications_chunk_\(index)"

   // Skip if already listening to this chunk
   guard !isListenerActive(id: listenerId) else {
    print("⚠️ Listener already active for chunk \(index), skipping")
    continue
   }

   let listener = db.collection("applications")
    .whereField("serviceId", in: serviceIdChunk)
    .order(by: "appliedAt", descending: true)
    .addSnapshotListener { [weak self] snapshot, error in
     guard let self = self else { return }

     if let error = error {
      self.applicationsError = AppError.from(error)
      self.isLoadingApplications = false
      print("❌ Error fetching received applications (chunk \(index)): \(error)")
      return
     }

     guard let documents = snapshot?.documents else { return }

     let decoded = documents.compactMap { doc in
      do {
       return try Firestore.Decoder().decode(JobApplication.self, from: doc.data())
      } catch {
       print("⚠️ Failed to decode received application \(doc.documentID): \(error)")
       return nil
      }
     }

     Task { @MainActor in
      // Merge with existing applications, avoiding duplicates
      let existingIds = Set(self.receivedApplications.map { $0.id })
      let newApplications = decoded.filter { !existingIds.contains($0.id) }

      self.receivedApplications.append(contentsOf: newApplications)
      self.receivedApplications.sort { $0.appliedAt > $1.appliedAt }

      print("✅ Loaded applications for service chunk \(index + 1)/\(chunks.count)")
     }
    }

   addListener(id: listenerId, listener: listener)
  }

  print("✅ Set up \(chunks.count) listener(s) for received applications")
 }

 // MARK: - Submit Application

 func submitApplication(
  serviceId: String,
  applicantId: String,
  applicantName: String,
  applicantPhotoURL: String?,
  coverMessage: String? = nil
 ) async throws {
  // Check if already applied (to this specific service)
  let existingApplication = myApplications.first { $0.serviceId == serviceId && $0.status != .withdrawn }
  if existingApplication != nil {
   throw NSError(domain: "ApplicationsStore", code: 2,
                 userInfo: [NSLocalizedDescriptionKey: "You have already applied to this job"])
  }

  // Create application
  let application = JobApplication(
   serviceId: serviceId,
   applicantId: applicantId,
   applicantName: applicantName,
   applicantPhotoURL: applicantPhotoURL,
   coverMessage: coverMessage
  )

  // Save to Firestore using FirestoreService
  try await FirestoreService.shared.saveApplication(application)

  // Increment application count on service
  try await db.collection("services").document(serviceId).updateData([
   "applicationCount": FieldValue.increment(Int64(1))
  ])

  print("✅ Application submitted: \(application.id)")
 }

 // MARK: - Update Application Status

 func updateApplicationStatus(
  applicationId: String,
  newStatus: JobApplicationStatus,
  responseMessage: String? = nil
 ) async throws {
  var updateData: [String: Any] = [
   "status": newStatus.rawValue,
   "respondedAt": Timestamp(date: Date())
  ]

  if let responseMessage = responseMessage {
   updateData["responseMessage"] = responseMessage
  }

  try await db.collection("applications").document(applicationId).updateData(updateData)
  print("✅ Application status updated: \(applicationId) -> \(newStatus.rawValue)")
 }

 // MARK: - Accept Application (with Service Activation)

 func acceptApplication(
  applicationId: String,
  serviceId: String,
  responseMessage: String? = nil
 ) async throws {
  // Get the accepted application to extract applicant ID
  guard let acceptedApplication = receivedApplications.first(where: { $0.id == applicationId }) else {
   throw NSError(domain: "ApplicationsStore", code: 4,
                 userInfo: [NSLocalizedDescriptionKey: "Application not found"])
  }

  // Update application status to accepted
  try await updateApplicationStatus(
   applicationId: applicationId,
   newStatus: .accepted,
   responseMessage: responseMessage
  )

  // Mark service as active with hired applicant
  try await db.collection("services").document(serviceId).updateData([
   "status": ServiceStatus.active.rawValue,
   "hiredApplicantId": acceptedApplication.applicantId
  ])

  print("✅ Service marked as active with hired applicant: \(acceptedApplication.applicantId)")

  // Reject all other pending applications for this service
  try await rejectOtherApplications(serviceId: serviceId, acceptedId: applicationId)
 }

 private func rejectOtherApplications(serviceId: String, acceptedId: String) async throws {
  let pendingApplications = receivedApplications.filter {
   $0.serviceId == serviceId && $0.id != acceptedId && $0.status == .pending
  }

  for application in pendingApplications {
   try await updateApplicationStatus(
    applicationId: application.id,
    newStatus: .rejected,
    responseMessage: "Position has been filled"
   )
  }

  print("✅ Rejected \(pendingApplications.count) other applications for service: \(serviceId)")
 }

 // MARK: - Withdraw Application

 func withdrawApplication(applicationId: String) async throws {
  let application = myApplications.first { $0.id == applicationId }
  guard let application = application else {
   throw NSError(domain: "ApplicationsStore", code: 3,
                 userInfo: [NSLocalizedDescriptionKey: "Application not found"])
  }

  // Update status to withdrawn
  try await updateApplicationStatus(applicationId: applicationId, newStatus: .withdrawn)

  // Decrement application count
  try await db.collection("services").document(application.serviceId).updateData([
   "applicationCount": FieldValue.increment(Int64(-1))
  ])
 }

 // MARK: - Check if Applied

 func hasApplied(to serviceId: String) -> Bool {
  return myApplications.contains { $0.serviceId == serviceId && $0.status != .withdrawn }
 }

 // MARK: - Get Applications for Service

 func getApplications(for serviceId: String) -> [JobApplication] {
  return receivedApplications.filter { $0.serviceId == serviceId }
 }

 // MARK: - Get Application Count

 func getApplicationCount(for serviceId: String) -> Int {
  return receivedApplications.filter { $0.serviceId == serviceId }.count
 }

 // MARK: - Fetch User Applications (for AppliedJobsView)

 func fetchUserApplications(userId: String) async -> [JobApplication] {
  // Return applications submitted by this user from the real-time listener
  // Filter out withdrawn applications
  let active = myApplications.filter { $0.status != .withdrawn }
  return active.sorted { $0.appliedAt > $1.appliedAt }
 }

 // MARK: - Retry Logic

 func retryLoadingApplications() async {
  guard let userId = currentUserId else { return }
  do {
   try await setupListeners(userId: userId)
   print("✅ Applications retry succeeded")
  } catch {
   applicationsError = AppError.from(error)
   print("❌ Applications retry failed: \(error)")
  }
 }
}
