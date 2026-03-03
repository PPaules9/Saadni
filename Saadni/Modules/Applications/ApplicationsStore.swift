import Foundation
import FirebaseFirestore
import Observation

@Observable
class ApplicationsStore {
    // MARK: - State
    var myApplications: [JobApplication] = []       // Applications I submitted
    var receivedApplications: [JobApplication] = [] // Applications to my services

    private var myApplicationsListener: ListenerRegistration?
    private var receivedApplicationsListener: ListenerRegistration?
    private var db: Firestore {
        return Firestore.firestore()
    }

    // MARK: - Initialization
    init() {}

    deinit {
        stopListening()
    }

    // MARK: - Setup Listeners

    func setupListeners(userId: String) {
        stopListening()

        // Listen to applications I submitted
        myApplicationsListener = db.collection("applications")
            .whereField("applicantId", isEqualTo: userId)
            .order(by: "appliedAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching my applications: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let decoder = Firestore.Decoder()
                self.myApplications = documents.compactMap { doc in
                    try? decoder.decode(JobApplication.self, from: doc.data())
                }

                print("✅ Loaded \(self.myApplications.count) my applications")
            }

        // Listen to applications received on my services
        Task {
            await self.setupReceivedApplicationsListener(userId: userId)
        }
    }

    private func setupReceivedApplicationsListener(userId: String) async {
        // Get all service IDs created by this user
        do {
            let servicesSnapshot = try await db.collection("services")
                .whereField("providerId", isEqualTo: userId)
                .getDocuments()

            let serviceIds = servicesSnapshot.documents.map { $0.documentID }

            if serviceIds.isEmpty {
                print("📝 User has no services, no applications to receive")
                return
            }

            // Listen to applications for these services
            // Note: Firestore "in" queries support max 10 items
            // For production, you'd need to handle pagination
            let limitedServiceIds = Array(serviceIds.prefix(10))

            receivedApplicationsListener = db.collection("applications")
                .whereField("serviceId", in: limitedServiceIds)
                .order(by: "appliedAt", descending: true)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("❌ Error fetching received applications: \(error)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    let decoder = Firestore.Decoder()
                    self.receivedApplications = documents.compactMap { doc in
                        try? decoder.decode(JobApplication.self, from: doc.data())
                    }

                    print("✅ Loaded \(self.receivedApplications.count) received applications")
                }
        } catch {
            print("❌ Error setting up received applications listener: \(error)")
        }
    }

    func stopListening() {
        myApplicationsListener?.remove()
        receivedApplicationsListener?.remove()
    }

    // MARK: - Submit Application

    func submitApplication(
        serviceId: String,
        applicantId: String,
        applicantName: String,
        applicantPhotoURL: String?,
        coverMessage: String? = nil
    ) async throws {
        // Check if already applied
        let existingApplication = myApplications.first { $0.serviceId == serviceId }
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

        let encoder = Firestore.Encoder()
        let data = try encoder.encode(application)

        // Save to Firestore
        try await db.collection("applications").document(application.id).setData(data)

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
}
