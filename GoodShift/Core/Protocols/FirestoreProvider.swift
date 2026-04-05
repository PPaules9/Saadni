//
//  FirestoreProvider.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

/// Protocol for Firestore data operations
/// Enables dependency injection and testing with mock implementations
protocol FirestoreProvider {
    // MARK: - User Operations
    func saveUser(_ user: User) async throws
    func fetchUser(id: String) async throws -> User?

    // MARK: - Service Operations
    func saveService(_ service: JobService) async throws
    func updateService(_ service: JobService) async throws
    func deleteService(id: String) async throws

    // MARK: - Application Operations
    func saveApplication(_ application: JobApplication) async throws
    func updateApplication(_ application: JobApplication) async throws

    // MARK: - Review Operations
    func saveReview(_ review: Review) async throws
    func updateReview(_ review: Review) async throws
    func deleteReview(id: String) async throws

    // MARK: - Transaction Operations
    func saveTransaction(_ transaction: Transaction) async throws
    func updateTransaction(_ transaction: Transaction) async throws
    func deleteTransaction(id: String) async throws
}
