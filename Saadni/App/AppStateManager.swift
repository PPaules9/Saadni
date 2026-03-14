//
//  AppStateManager.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//


import Foundation

@Observable
class AppStateManager {
    private(set) var hasSeenOnboarding: Bool = false
    private(set) var hasSelectedRole: Bool = false

    init() {
        loadState()
    }

    private func loadState() {
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: StateKeys.hasSeenOnboarding.key)
        hasSelectedRole = UserDefaults.standard.bool(forKey: StateKeys.hasSelectedRole.key)
        print("✅ AppState loaded - OnboardingSeen: \(hasSeenOnboarding), RoleSelected: \(hasSelectedRole)")
    }

    func completeOnboarding() async throws {
        hasSeenOnboarding = true
        try await saveState()
        print("✅ Onboarding completed")
    }

    func resetOnboarding() async throws {
        hasSeenOnboarding = false
        try await saveState()
    }

    func completeRoleSelection() async throws {
        hasSelectedRole = true
        try await saveState()
        print("✅ Role selection completed")
    }

    func resetRoleSelection() async throws {
        hasSelectedRole = false
        try await saveState()
    }

    /// Reset all state when user signs out
    /// This ensures new login flow shows Onboarding → Auth → RoleSelection
    func resetAllState() async throws {
        hasSeenOnboarding = false
        hasSelectedRole = false
        try await saveState()
        print("🔄 AppState reset on sign out")
    }

    private func saveState() async throws {
        UserDefaults.standard.set(hasSeenOnboarding, forKey: StateKeys.hasSeenOnboarding.key)
        UserDefaults.standard.set(hasSelectedRole, forKey: StateKeys.hasSelectedRole.key)
        print("💾 AppState persisted")
    }
}
