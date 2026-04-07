//
//  AppError.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import Foundation

// MARK: - AppError
// Single canonical error type for the entire app.
// Conforms to LocalizedError for user-facing messages and
// Identifiable (UUID-based) for SwiftUI .alert(item:) usage.

enum AppError: Error, LocalizedError, Identifiable {
    case authentication(String)
    case network(String)
    case firestore(String)
    case validation(String)
    case unknown(Error)

    // Stable identity derived from the error's content.
    // Using a computed var is safe here because the value is deterministic
    // for a given case+message — SwiftUI .alert(item:) can track it correctly.
    var id: String {
        switch self {
        case .authentication(let m): return "auth:\(m)"
        case .network(let m):        return "net:\(m)"
        case .firestore(let m):      return "db:\(m)"
        case .validation(let m):     return "val:\(m)"
        case .unknown(let e):        return "unk:\(e.localizedDescription)"
        }
    }

    // MARK: LocalizedError

    var errorDescription: String? {
        switch self {
        case .authentication(let message):
            return "Authentication Error: \(message)"
        case .network(let message):
            return "Network Error: \(message)"
        case .firestore(let message):
            return "Database Error: \(message)"
        case .validation(let message):
            return "Invalid Input: \(message)"
        case .unknown(let error):
            return "Unexpected Error: \(error.localizedDescription)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .authentication:
            return "Please sign in again and try."
        case .network:
            return "Check your internet connection and try again."
        case .firestore:
            return "There's an issue with our database. Please try again later."
        case .validation:
            return "Please check your input and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }

    // MARK: Factory

    /// Converts any Error into the appropriate AppError case.
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError { return appError }

        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            return .network(nsError.localizedDescription)
        }
        if nsError.domain.contains("Firestore") || nsError.domain.contains("Firebase") {
            return .firestore(nsError.localizedDescription)
        }
        return .unknown(error)
    }
}

// MARK: - ErrorAlert
// Wraps AppError with a stable UUID for use with SwiftUI's .alert(item:).

struct ErrorAlert: Identifiable {
    let id = UUID()
    let error: AppError
}
