//
//  ApplicationsStore.swift
//  GoodShift
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

 /// Clear all listeners and reset local data
 func removeAllListeners() {
  print("🧹 [ApplicationsStore] Clearing all listeners and resetting state...")

  // Remove Firestore listeners
  activeListeners.values.forEach { $0.remove() }
  activeListeners.removeAll()
  listenerSetupState.removeAll()

  // Clear local data for next session
  myApplications = []
  receivedApplications = []
  isLoadingApplications = false
  applicationsError = nil
  currentUserId = nil
  
  print("🧹 [ApplicationsStore] State cleared")
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
   .limit(to: 50)
   .addSnapshotListener { [weak self] snapshot, error in
    Task { @MainActor [weak self] in
     guard let self else { return }

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
  let listenerId = "receivedApplications"

  guard !isListenerActive(id: listenerId) else {
   print("⚠️ Listener already active for received applications")
   return
  }

  // Single query using denormalized providerId field — no chunking needed
  let listener = db.collection("applications")
   .whereField("providerId", isEqualTo: userId)
   .order(by: "appliedAt", descending: true)
   .limit(to: 50)
   .addSnapshotListener { [weak self] snapshot, error in
    Task { @MainActor [weak self] in
     guard let self else { return }

     if let error = error {
      self.applicationsError = AppError.from(error)
      self.isLoadingApplications = false
      print("❌ Error fetching received applications: \(error)")
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

     self.receivedApplications = decoded
     print("✅ Loaded \(decoded.count) received applications")
    }
   }

  addListener(id: listenerId, listener: listener)
  print("✅ Set up received applications listener for provider: \(userId)")
 }

 // MARK: - Submit Application

 func submitApplication(
  serviceId: String,
  providerId: String,
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

  // Create application (providerId stored for efficient server-side querying)
  let application = JobApplication(
   serviceId: serviceId,
   providerId: providerId,
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

  let totalApplicants = receivedApplications.filter { $0.serviceId == serviceId }.count
  AnalyticsService.shared.track(.applicationAccepted(jobId: serviceId, numApplicants: totalApplicants))
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

 // MARK: - Request Completion (Student marks job as done)

 func requestCompletion(serviceId: String, note: String? = nil) async throws {
  var updateData: [String: Any] = [
   "status": ServiceStatus.pendingCompletion.rawValue,
   "completionRequestedAt": Timestamp(date: Date())
  ]
  if let note = note, !note.isEmpty {
   updateData["completionNote"] = note
  }
  try await db.collection("services").document(serviceId).updateData(updateData)
  print("✅ Completion requested for service: \(serviceId)")
 }

 // MARK: - Confirm Completion (Provider confirms job is done)

 func confirmCompletion(serviceId: String, applicationId: String) async throws {
  // Mark service as completed
  try await db.collection("services").document(serviceId).updateData([
   "status": ServiceStatus.completed.rawValue,
   "completedAt": Timestamp(date: Date())
  ])

  // Mark application as completed
  try await db.collection("applications").document(applicationId).updateData([
   "status": JobApplicationStatus.completed.rawValue,
   "respondedAt": Timestamp(date: Date())
  ])

  print("✅ Job confirmed as completed: \(serviceId)")
 }

 // MARK: - Dispute Completion (Provider disputes student's claim)

 func disputeCompletion(serviceId: String, reason: String? = nil) async throws {
  var updateData: [String: Any] = [
   "status": ServiceStatus.active.rawValue,
   "completionRequestedAt": NSNull(),
   "completionNote": NSNull()
  ]
  if let reason = reason, !reason.isEmpty {
   updateData["disputeReason"] = reason
  }
  try await db.collection("services").document(serviceId).updateData(updateData)
  print("✅ Completion disputed, job reverted to active: \(serviceId)")
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
