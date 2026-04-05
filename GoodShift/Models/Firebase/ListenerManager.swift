//
//  ListenerManager.swift
//  GoodShift
//
//  Created by Claude Code on 15/03/2026.
//
//  Centralized listener management to prevent memory leaks and duplicate subscriptions.
//  All stores should use this pattern instead of managing listeners directly.
//

import Foundation
import FirebaseFirestore

/// Protocol for consistent listener management across all stores
protocol ListenerManaging: AnyObject {
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

    /// Default implementation for adding a listener (replaces existing if any)
    func addListener(id: String, listener: ListenerRegistration) {
        removeListener(id: id)
        activeListeners[id] = listener
        print("📡 [Listener] Added: \(id) (total active: \(activeListeners.count))")
    }

    /// Default implementation for removing a specific listener
    func removeListener(id: String) {
        if let listener = activeListeners.removeValue(forKey: id) {
            listener.remove()
            print("🧹 [Listener] Removed: \(id) (total active: \(activeListeners.count))")
        }
    }

    /// Default implementation for removing all listeners
    func removeAllListeners() {
        print("🧹 [Listener] Removing all \(activeListeners.count) listeners...")
        activeListeners.values.forEach { $0.remove() }
        activeListeners.removeAll()
        listenerSetupState.removeAll()
        print("🧹 [Listener] All listeners removed")
    }
}
