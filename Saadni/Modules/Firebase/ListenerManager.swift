//
//  ListenerManager.swift
//  Saadni
//
//  Created by Claude Code on 15/03/2026.
//
//  Centralized listener management to prevent memory leaks and duplicate subscriptions.
//  All stores should use this pattern instead of managing listeners directly.
//

import Foundation
import FirebaseFirestore

/// Protocol for consistent listener management across all stores
protocol ListenerManaging {
    /// Store all active listeners with their IDs for cleanup
    var activeListeners: [String: ListenerRegistration] { get set }

    /// Track listener setup state to prevent duplicates
    var listenerSetupState: [String: Bool] { get set }

    /// Check if a listener is already active
    func isListenerActive(id: String) -> Bool

    /// Register a new listener
    func addListener(id: String, listener: ListenerRegistration)

    /// Remove a specific listener
    func removeListener(id: String)

    /// Remove all listeners
    func removeAllListeners()
}

// MARK: - Default Implementation (for protocol extension)

extension ListenerManaging {
    func isListenerActive(id: String) -> Bool {
        return activeListeners[id] != nil
    }
}
