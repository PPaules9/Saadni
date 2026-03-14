//
//  AppError.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

enum AppError: Error, LocalizedError {
    case network(String)
    case firestore(String)
    case validation(String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
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

    /// Converts a generic Error into AppError
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }

        let nsError = error as NSError

        // Detect error type by domain
        if nsError.domain == NSURLErrorDomain {
            return .network(nsError.localizedDescription)
        }

        if nsError.domain.contains("Firestore") || nsError.domain.contains("Firebase") {
            return .firestore(nsError.localizedDescription)
        }

        return .unknown(error)
    }
}
