//
//  FirestoreService.swift
//  Saadni
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation
import FirebaseFirestore

/// Handles all Firestore operations
class FirestoreService {
 static let shared = FirestoreService()
 private let db = Firestore.firestore()

 private init() {}

 // MARK: - Thread Safety
 // All methods are nonisolated async, can be called from any thread
 // Firestore SDK handles thread safety internally
 
 // MARK: - Collections
 private var usersCollection: CollectionReference {
  db.collection("users")
 }
 
 private var servicesCollection: CollectionReference {
  db.collection("services")
 }
 
 private var applicationsCollection: CollectionReference {
  db.collection("applications")
 }
 
 // MARK: - User Operations
 
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
}
