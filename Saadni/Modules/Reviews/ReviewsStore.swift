//
//  ReviewsStore.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

@Observable
class ReviewsStore {
    // MARK: - State

    var reviewsIReceived: [Review] = []      // Reviews about me
    var reviewsISubmitted: [Review] = []     // Reviews I wrote
    var serviceReviews: [String: [Review]] = [:]  // Reviews by service ID

    private var receivedReviewsListener: ListenerRegistration?
    private var submittedReviewsListener: ListenerRegistration?

    private var db: Firestore {
        Firestore.firestore()
    }

    deinit {
        stopListening()
    }

    // MARK: - Setup & Teardown

    func setupListeners(userId: String) {
        stopListening()

        // Listen to reviews I received
        receivedReviewsListener = db.collection("reviews")
            .whereField("revieweeId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching received reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.reviewsIReceived = documents.compactMap { doc in
                    try? Review.fromFirestore(id: doc.documentID, data: doc.data())
                }

                print("✅ Loaded \(self.reviewsIReceived.count) reviews received")
            }

        // Listen to reviews I submitted
        submittedReviewsListener = db.collection("reviews")
            .whereField("reviewerId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching submitted reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.reviewsISubmitted = documents.compactMap { doc in
                    try? Review.fromFirestore(id: doc.documentID, data: doc.data())
                }

                print("✅ Loaded \(self.reviewsISubmitted.count) reviews submitted")
            }
    }

    func stopListening() {
        receivedReviewsListener?.remove()
        submittedReviewsListener?.remove()
    }

    // MARK: - Submit Review

    func submitReview(_ review: Review) async throws {
        // Save to Firestore
        try await FirestoreService.shared.saveReview(review)

        // Update reviewee's rating
        try await updateUserRating(userId: review.revieweeId, newRating: review.rating)

        print("✅ Review submitted and user rating updated")
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
            try? Review.fromFirestore(id: doc.documentID, data: doc.data())
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

    // MARK: - Update User Rating

    private func updateUserRating(userId: String, newRating: Int) async throws {
        let userRef = db.collection("users").document(userId)

        do {
            let snapshot = try await userRef.getDocument()
            guard let data = snapshot.data() else {
                // First review for this user
                try await userRef.updateData([
                    "rating": Double(newRating),
                    "totalReviews": 1
                ])
                return
            }

            let currentRating = data["rating"] as? Double
            let totalReviews = data["totalReviews"] as? Int ?? 0

            // Calculate new average
            let oldTotal = (currentRating ?? 0.0) * Double(totalReviews)
            let newTotal = oldTotal + Double(newRating)
            let newAverage = newTotal / Double(totalReviews + 1)

            try await userRef.updateData([
                "rating": newAverage,
                "totalReviews": totalReviews + 1
            ])

            print("✅ User rating updated: \(String(format: "%.1f", newAverage))")
        } catch {
            print("❌ Error updating user rating: \(error)")
            throw error
        }
    }

    // MARK: - Delete Review

    func deleteReview(_ reviewId: String) async throws {
        try await FirestoreService.shared.deleteReview(id: reviewId)
        print("✅ Review deleted: \(reviewId)")
    }
}
