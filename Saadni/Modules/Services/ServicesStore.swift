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
 private let db = Firestore.firestore()
 
 // MARK: - Initialization
 init() {
  setupListeners()
 }
 
 deinit {
  servicesListener?.remove()
 }
 
 // MARK: - Real-time Listeners
 
 private func setupListeners() {
  // Listen to all services (both flexible jobs and shifts)
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
     try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
    }
    
    print("✅ Loaded \(self.services.count) services from Firestore")
   }
 }
 
 // MARK: - Add Services (with Image Upload)
 
 func addService(_ service: JobService, image: UIImage?) async throws {
  var updatedService = service
  
  // Upload image first, fail if it fails
  if let image = image {
   let imageURL = try await StorageService.shared.uploadServiceImage(image, serviceId: service.id)
   // We don't need to manually update here - Firestore listener will pick up the change
   print("✅ Image uploaded for service: \(service.id)")
  }
  
  // Then save service to Firestore
  try await FirestoreService.shared.saveService(updatedService)
 }
 
 // MARK: - Get Services (from memory, populated by listeners)
 
 func getAllServices() -> [JobService] {
  return services
 }
 
 func getFlexibleJobs() -> [JobService] {
  return services.filter { $0.jobType == .flexibleJobs }
 }
 
 func getShifts() -> [JobService] {
  return services.filter { $0.jobType == .shift }
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
    try? JobService.fromFirestore(id: doc.documentID, data: doc.data())
   }
  } catch {
   print("❌ Error fetching user services: \(error)")
  }
  
  return userServices
 }
}
