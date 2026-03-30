//
//  ReviewsStore.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

@Observable
class ReviewsStore: ListenerManaging {
    // MARK: - State

    var reviewsIReceived: [Review] = []      // Reviews about me
    var reviewsISubmitted: [Review] = []     // Reviews I wrote
    var serviceReviews: [String: [Review]] = [:]  // Reviews by service ID

    // MARK: - Error States
    var isLoadingReviews: Bool = false
    var reviewsError: AppError? = nil

    // MARK: - Listener Management (from ListenerManaging protocol)
    var activeListeners: [String: ListenerRegistration] = [:]
    var listenerSetupState: [String: Bool] = [:]

    private var currentUserId: String?

    private var db: Firestore {
        Firestore.firestore()
    }

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

    // MARK: - Setup & Teardown

    /// Sets up real-time listeners for user reviews (received and submitted)
    /// - Parameter userId: The user ID to listen for reviews
    /// - Throws: Firestore errors during listener setup
    func setupListeners(userId: String) async throws {
        removeAllListeners()

        currentUserId = userId
        isLoadingReviews = true
        reviewsError = nil

        // Setup received reviews listener
        let receivedListenerId = "receivedReviews"
        guard !isListenerActive(id: receivedListenerId) else {
            print("⚠️ Listener already active for received reviews")
            return
        }

        let receivedListener = db.collection("reviews")
            .whereField("revieweeId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.reviewsError = AppError.from(error)
                    self.isLoadingReviews = false
                    print("❌ Error fetching received reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let decoded = documents.compactMap { doc in
                    do {
                        return try Review.fromFirestore(id: doc.documentID, data: doc.data())
                    } catch {
                        print("⚠️ Failed to decode received review \(doc.documentID): \(error)")
                        return nil
                    }
                }

                Task { @MainActor in
                    self.reviewsIReceived = decoded
                    print("✅ Loaded \(self.reviewsIReceived.count) reviews received")
                }
            }

        addListener(id: receivedListenerId, listener: receivedListener)

        // Setup submitted reviews listener
        let submittedListenerId = "submittedReviews"
        guard !isListenerActive(id: submittedListenerId) else {
            print("⚠️ Listener already active for submitted reviews")
            return
        }

        let submittedListener = db.collection("reviews")
            .whereField("reviewerId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.reviewsError = AppError.from(error)
                    self.isLoadingReviews = false
                    print("❌ Error fetching submitted reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let decoded = documents.compactMap { doc in
                    do {
                        return try Review.fromFirestore(id: doc.documentID, data: doc.data())
                    } catch {
                        print("⚠️ Failed to decode submitted review \(doc.documentID): \(error)")
                        return nil
                    }
                }

                Task { @MainActor in
                    self.reviewsISubmitted = decoded
                    self.reviewsError = nil
                    self.isLoadingReviews = false
                    print("✅ Loaded \(self.reviewsISubmitted.count) reviews submitted")
                }
            }

        addListener(id: submittedListenerId, listener: submittedListener)

        print("🔄 [ReviewsStore] Listeners setup for user: \(userId)")
    }

    // MARK: - Submit Review

    func submitReview(_ review: Review) async throws {
        // Save to Firestore. The onReviewCreated Cloud Function will
        // atomically update the reviewee's rating in the background.
        try await FirestoreService.shared.saveReview(review)
        print("✅ Review submitted")
    }

    // MARK: - Review Eligibility

    func canReviewService(_ service: JobService, userId: String) -> Bool {
        // Must be completed
        guard service.status == .completed else {
            print("❌ Cannot review: service not completed")
            return false
        }

        // Must be provider or hired applicant
        let isProvider = service.providerId == userId
        let isHiredApplicant = service.hiredApplicantId == userId
        guard isProvider || isHiredApplicant else {
            print("❌ Cannot review: user not involved in this service")
            return false
        }

        // Must not have already reviewed
        let existingReview = reviewsISubmitted.first {
            $0.serviceId == service.id
        }

        if existingReview != nil {
            print("❌ Cannot review: already reviewed this service")
            return false
        }

        return true
    }

    func hasReviewedService(_ serviceId: String) -> Bool {
        return reviewsISubmitted.contains { $0.serviceId == serviceId }
    }

    // MARK: - Fetch Reviews for Service

    func fetchReviewsForService(_ serviceId: String) async throws -> [Review] {
        let snapshot = try await db.collection("reviews")
            .whereField("serviceId", isEqualTo: serviceId)
            .getDocuments()

        let reviews = snapshot.documents.compactMap { doc -> Review? in
            do {
                return try Review.fromFirestore(id: doc.documentID, data: doc.data())
            } catch {
                print("⚠️ Failed to decode review for service \(doc.documentID): \(error)")
                return nil
            }
        }

        print("✅ Fetched \(reviews.count) reviews for service: \(serviceId)")
        return reviews
    }

    // MARK: - Get Reviews for User

    func getReviewsReceivedBy(userId: String) -> [Review] {
        return reviewsIReceived.filter { $0.revieweeId == userId }
    }

    func getReviewsSubmittedBy(userId: String) -> [Review] {
        return reviewsISubmitted.filter { $0.reviewerId == userId }
    }

    // MARK: - Calculate User Statistics

    func getAverageRatingForUser(userId: String) -> Double? {
        let reviews = getReviewsReceivedBy(userId: userId)
        guard !reviews.isEmpty else { return nil }

        let sum = reviews.reduce(0) { $0 + Double($1.rating) }
        return sum / Double(reviews.count)
    }

    func getTotalReviewsForUser(userId: String) -> Int {
        return getReviewsReceivedBy(userId: userId).count
    }

    // MARK: - Delete Review

    func deleteReview(_ reviewId: String) async throws {
        try await FirestoreService.shared.deleteReview(id: reviewId)
        print("✅ Review deleted: \(reviewId)")
    }

    // MARK: - Retry Logic

    func retryLoadingReviews() async {
        guard let userId = currentUserId else { return }
        do {
            try await setupListeners(userId: userId)
            print("✅ Reviews retry succeeded")
        } catch {
            reviewsError = AppError.from(error)
            print("❌ Reviews retry failed: \(error)")
        }
    }
}
