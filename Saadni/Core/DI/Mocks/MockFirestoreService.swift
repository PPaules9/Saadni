//
//  MockFirestoreService.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

/// Mock Firestore service for testing
/// Allows unit tests to run without Firebase dependency
class MockFirestoreService: FirestoreProvider {
    // MARK: - Mock Data Storage
    var savedUsers: [String: User] = [:]
    var savedServices: [String: JobService] = [:]
    var savedApplications: [String: JobApplication] = [:]
    var savedReviews: [String: Review] = [:]
    var savedTransactions: [String: Transaction] = [:]

    // MARK: - Error Configuration for Testing
    var shouldFailUserSave = false
    var shouldFailServiceSave = false
    var shouldFailApplicationSave = false
    var shouldFailReviewSave = false
    var shouldFailTransactionSave = false

    // MARK: - User Operations
    func saveUser(_ user: User) async throws {
        if shouldFailUserSave {
            throw AppError.firestore("Mock: User save failed")
        }
        savedUsers[user.id] = user
        print("✅ [Mock] User saved: \(user.id)")
    }

    func fetchUser(id: String) async throws -> User? {
        return savedUsers[id]
    }

    // MARK: - Service Operations
    func saveService(_ service: JobService) async throws {
        if shouldFailServiceSave {
            throw AppError.firestore("Mock: Service save failed")
        }
        savedServices[service.id] = service
        print("✅ [Mock] Service saved: \(service.id)")
    }

    func updateService(_ service: JobService) async throws {
        if shouldFailServiceSave {
            throw AppError.firestore("Mock: Service update failed")
        }
        savedServices[service.id] = service
        print("✅ [Mock] Service updated: \(service.id)")
    }

    func deleteService(id: String) async throws {
        savedServices.removeValue(forKey: id)
        print("✅ [Mock] Service deleted: \(id)")
    }

    // MARK: - Application Operations
    func saveApplication(_ application: JobApplication) async throws {
        if shouldFailApplicationSave {
            throw AppError.firestore("Mock: Application save failed")
        }
        savedApplications[application.id] = application
        print("✅ [Mock] Application saved: \(application.id)")
    }

    func updateApplication(_ application: JobApplication) async throws {
        if shouldFailApplicationSave {
            throw AppError.firestore("Mock: Application update failed")
        }
        savedApplications[application.id] = application
        print("✅ [Mock] Application updated: \(application.id)")
    }

    // MARK: - Review Operations
    func saveReview(_ review: Review) async throws {
        if shouldFailReviewSave {
            throw AppError.firestore("Mock: Review save failed")
        }
        savedReviews[review.id] = review
        print("✅ [Mock] Review saved: \(review.id)")
    }

    func updateReview(_ review: Review) async throws {
        if shouldFailReviewSave {
            throw AppError.firestore("Mock: Review update failed")
        }
        savedReviews[review.id] = review
        print("✅ [Mock] Review updated: \(review.id)")
    }

    func deleteReview(id: String) async throws {
        savedReviews.removeValue(forKey: id)
        print("✅ [Mock] Review deleted: \(id)")
    }

    // MARK: - Transaction Operations
    func saveTransaction(_ transaction: Transaction) async throws {
        if shouldFailTransactionSave {
            throw AppError.firestore("Mock: Transaction save failed")
        }
        savedTransactions[transaction.id] = transaction
        print("✅ [Mock] Transaction saved: \(transaction.id)")
    }

    func updateTransaction(_ transaction: Transaction) async throws {
        if shouldFailTransactionSave {
            throw AppError.firestore("Mock: Transaction update failed")
        }
        savedTransactions[transaction.id] = transaction
        print("✅ [Mock] Transaction updated: \(transaction.id)")
    }

    func deleteTransaction(id: String) async throws {
        savedTransactions.removeValue(forKey: id)
        print("✅ [Mock] Transaction deleted: \(id)")
    }

    // MARK: - Testing Utilities
    func reset() {
        savedUsers.removeAll()
        savedServices.removeAll()
        savedApplications.removeAll()
        savedReviews.removeAll()
        savedTransactions.removeAll()
        shouldFailUserSave = false
        shouldFailServiceSave = false
        shouldFailApplicationSave = false
        shouldFailReviewSave = false
        shouldFailTransactionSave = false
    }
}
