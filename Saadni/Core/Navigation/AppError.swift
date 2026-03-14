//
//  AppError.swift
//  Saadni
//
//  Created by Claude Code on 13/03/2026.
//

import Foundation

enum AppError: Identifiable {
    case authentication(String)
    case network(String)
    case firestore(String)
    case generic(String)

    var id: String {
        switch self {
        case .authentication(let msg): return "auth_\(msg)"
        case .network(let msg): return "network_\(msg)"
        case .firestore(let msg): return "firestore_\(msg)"
        case .generic(let msg): return "generic_\(msg)"
        }
    }

    var title: String {
        switch self {
        case .authentication: return "Authentication Error"
        case .network: return "Network Error"
        case .firestore: return "Data Error"
        case .generic: return "Error"
        }
    }

    var message: String {
        switch self {
        case .authentication(let msg),
             .network(let msg),
             .firestore(let msg),
             .generic(let msg):
            return msg
        }
    }
}

struct ErrorAlert: Identifiable {
    let id = UUID()
    let error: AppError
}
