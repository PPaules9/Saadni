//
//  AuthProvider.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

/// Protocol for authentication operations
/// Enables dependency injection and testing with mock implementations
protocol AuthProvider {
    // MARK: - State Properties
    var currentUserId: String? { get }
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }

    // MARK: - Auth Operations
    func signUp(
        email: String,
        password: String,
        fullName: String
    ) async throws

    func signIn(
        email: String,
        password: String
    ) async throws

    func signInAnonymously() async throws

    func signOut() throws
}
