//
//  FirestoreService.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseFirestore

/// Handles all Firestore operations
class FirestoreService: FirestoreProvider {
 static let shared = FirestoreService()
 private let db = Firestore.firestore()

 private init() {}

 // MARK: - Thread Safety
 // All methods are nonisolated async, can be called from any thread
 // Firestore SDK handles thread safety internally
 
 // MARK: - Collections
 private var usersCollection: CollectionReference {
  db.collection(AppConstants.Firestore.users)
 }
 
 private var servicesCollection: CollectionReference {
  db.collection(AppConstants.Firestore.services)
 }
 
 private var applicationsCollection: CollectionReference {
  db.collection(AppConstants.Firestore.applications)
 }

 private var reviewsCollection: CollectionReference {
  db.collection(AppConstants.Firestore.reviews)
 }

 private var transactionsCollection: CollectionReference {
  db.collection(AppConstants.Firestore.transactions)
 }

 // MARK: - User Operations
 
 func deleteUserData(userId: String) async throws {
  // ── Phase A: Collect Storage paths BEFORE Firestore docs are removed ──────

  // A1. Gather image URLs from services this user posted
  var serviceImageURLs: [String] = []
  var postedServiceQuery: Query = servicesCollection.whereField("providerId", isEqualTo: userId)
  var collectingMore = true
  while collectingMore {
   let snap = try await postedServiceQuery.limit(to: 500).getDocuments()
   guard !snap.documents.isEmpty else { break }
   for doc in snap.documents {
    if let imageMap = doc.data()["image"] as? [String: Any],
       let url = imageMap["remoteURL"] as? String {
     serviceImageURLs.append(url)
    }
   }
   collectingMore = snap.documents.count == 500
  }

  // A2. Gather serviceIds where this user was hired (for completion proof photos)
  var hiredServiceIds: [String] = []
  var hiredQuery: Query = servicesCollection.whereField("hiredApplicantId", isEqualTo: userId)
  var collectingHired = true
  while collectingHired {
   let snap = try await hiredQuery.limit(to: 500).getDocuments()
   guard !snap.documents.isEmpty else { break }
   hiredServiceIds.append(contentsOf: snap.documents.map { $0.documentID })
   collectingHired = snap.documents.count == 500
  }

  // ── Phase B: Firestore cleanup ────────────────────────────────────────────

  // B1. Delete all applications submitted TO the user's services
  //     (other users applied to jobs this user posted — clean those up before
  //     the service documents themselves are removed, avoiding orphaned applications)
  try await deleteInBatches(
   query: applicationsCollection.whereField("providerId", isEqualTo: userId)
  )

  // B2. Reset services where this user was the hired applicant back to published
  //     so the provider's job re-enters the open market instead of freezing forever.
  //     Only touch in-progress statuses; completed jobs are left as historical records.
  let inProgressStatuses: Set<String> = ["active", "pending_completion", "disputed"]
  var hasMore = true
  while hasMore {
   let snapshot = try await servicesCollection
    .whereField("hiredApplicantId", isEqualTo: userId)
    .limit(to: 500).getDocuments()
   guard !snapshot.documents.isEmpty else { break }
   let batch = db.batch()
   for doc in snapshot.documents {
    let status = doc.data()["status"] as? String ?? ""
    if inProgressStatuses.contains(status) {
     batch.updateData([
      "status": "published",
      "hiredApplicantId": FieldValue.delete()
     ], forDocument: doc.reference)
    }
   }
   try await batch.commit()
   hasMore = snapshot.documents.count == 500
  }

  // B3. Delete user's own posted services
  try await deleteInBatches(
   query: servicesCollection.whereField("providerId", isEqualTo: userId)
  )

  // B4. Delete applications the user submitted as a worker
  try await deleteInBatches(
   query: applicationsCollection.whereField("applicantId", isEqualTo: userId)
  )

  // B5. Delete reviews received by and submitted by the user
  try await deleteInBatches(
   query: reviewsCollection.whereField("revieweeId", isEqualTo: userId)
  )
  try await deleteInBatches(
   query: reviewsCollection.whereField("reviewerId", isEqualTo: userId)
  )

  // B6. Delete user's transactions
  try await deleteInBatches(
   query: transactionsCollection.whereField("userId", isEqualTo: userId)
  )

  // B7. Delete conversations the user participated in
  try await deleteInBatches(
   query: db.collection(AppConstants.Firestore.conversations).whereField("participantIds", arrayContains: userId)
  )

  // B8. Delete user document
  try await usersCollection.document(userId).delete()
  print("✅ All Firestore data deleted for: \(userId)")

  // ── Phase C: Storage cleanup ──────────────────────────────────────────────
  await StorageService.shared.deleteUserFiles(
   userId: userId,
   serviceImageURLs: serviceImageURLs,
   hiredServiceIds: hiredServiceIds
  )
 }

 /// Deletes all documents matching a query in batches of 500.
 /// Prevents loading thousands of document references into memory at once.
 private func deleteInBatches(query: Query) async throws {
  var hasMore = true
  while hasMore {
   let snapshot = try await query.limit(to: 500).getDocuments()
   guard !snapshot.documents.isEmpty else { break }
   let batch = db.batch()
   snapshot.documents.forEach { batch.deleteDocument($0.reference) }
   try await batch.commit()
   hasMore = snapshot.documents.count == 500
  }
 }
 
 func saveUser(_ user: User) async throws {
  let encoder = Firestore.Encoder()
  let data = try encoder.encode(user)
  try await usersCollection.document(user.id).setData(data, merge: true)
  print("✅ User saved to Firestore: \(user.id)")
 }
 
 func fetchUser(id: String) async throws -> User? {
  let snapshot = try await usersCollection.document(id).getDocument()
  guard snapshot.exists else { return nil }
  
  let decoder = Firestore.Decoder()
  return try decoder.decode(User.self, from: snapshot.data() ?? [:])
 }
 
 // MARK: - Service Operations
 
 func saveService(_ service: JobService) async throws {
  try await servicesCollection.document(service.id).setData(service.toFirestore())
  print("✅ Service saved: \(service.id)")
 }
 
 func updateService(_ service: JobService) async throws {
  try await servicesCollection.document(service.id).updateData(service.toFirestore())
  print("✅ Service updated: \(service.id)")
 }
 
 func deleteService(id: String) async throws {
  try await servicesCollection.document(id).delete()
  print("✅ Service deleted: \(id)")
 }
 
 // MARK: - Application Operations (to be implemented in Phase 4)
 
 func saveApplication(_ application: JobApplication) async throws {
  let encoder = Firestore.Encoder()
  let data = try encoder.encode(application)
  try await applicationsCollection.document(application.id).setData(data)
  print("✅ Application saved: \(application.id)")
 }
 
 func updateApplication(_ application: JobApplication) async throws {
  let encoder = Firestore.Encoder()
  let data = try encoder.encode(application)
  try await applicationsCollection.document(application.id).updateData(data as [AnyHashable: Any])
  print("✅ Application updated: \(application.id)")
 }

 // MARK: - Review Operations

 func saveReview(_ review: Review) async throws {
  try await reviewsCollection.document(review.id).setData(review.toFirestore())
  print("✅ Review saved: \(review.id)")
 }

 func updateReview(_ review: Review) async throws {
  try await reviewsCollection.document(review.id).updateData(review.toFirestore())
  print("✅ Review updated: \(review.id)")
 }

 func deleteReview(id: String) async throws {
  try await reviewsCollection.document(id).delete()
  print("✅ Review deleted: \(id)")
 }

 // MARK: - Transaction Operations

 func saveTransaction(_ transaction: Transaction) async throws {
  try await transactionsCollection.document(transaction.id).setData(transaction.toFirestore())
  print("✅ Transaction saved: \(transaction.id)")
 }

 func updateTransaction(_ transaction: Transaction) async throws {
  try await transactionsCollection.document(transaction.id).updateData(transaction.toFirestore())
  print("✅ Transaction updated: \(transaction.id)")
 }

 func deleteTransaction(id: String) async throws {
  try await transactionsCollection.document(id).delete()
  print("✅ Transaction deleted: \(id)")
 }

 // MARK: - Real-Time Listeners
 /// Creates a listener for all published services (for browse/home views)
 func listenToServices() -> ListenerRegistration {
  return servicesCollection
   .whereField("status", in: ["published", "active"])
   .order(by: "createdAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to services: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ Services listener updated: \(count) services")
    }
   }
 }

 /// Creates a listener for user's submitted applications
 func listenToMyApplications(userId: String) -> ListenerRegistration {
  return applicationsCollection
   .whereField("applicantId", isEqualTo: userId)
   .order(by: "appliedAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to my applications: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ My applications listener updated: \(count) applications")
    }
   }
 }

 /// Creates a listener for received applications (on user's services)
 func listenToReceivedApplications(serviceIds: [String]) -> ListenerRegistration {
  return applicationsCollection
   .whereField("serviceId", in: serviceIds)
   .order(by: "appliedAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to received applications: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ Received applications listener updated: \(count) applications")
    }
   }
 }

 /// Creates a listener for reviews received by user
 func listenToReceivedReviews(userId: String) -> ListenerRegistration {
  return reviewsCollection
   .whereField("revieweeId", isEqualTo: userId)
   .order(by: "createdAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to received reviews: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ Received reviews listener updated: \(count) reviews")
    }
   }
 }

 /// Creates a listener for reviews submitted by user
 func listenToSubmittedReviews(userId: String) -> ListenerRegistration {
  return reviewsCollection
   .whereField("reviewerId", isEqualTo: userId)
   .order(by: "createdAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to submitted reviews: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ Submitted reviews listener updated: \(count) reviews")
    }
   }
 }

 /// Creates a listener for user's transactions (wallet)
 func listenToTransactions(userId: String) -> ListenerRegistration {
  return transactionsCollection
   .whereField("userId", isEqualTo: userId)
   .order(by: "createdAt", descending: true)
   .addSnapshotListener { snapshot, error in
    if let error = error {
     print("❌ Error listening to transactions: \(error)")
    } else if let count = snapshot?.documents.count {
     print("✅ Transactions listener updated: \(count) transactions")
    }
   }
 }
}
