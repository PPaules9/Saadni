//
//  AppStateManager.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//


import Foundation

@Observable
class AppStateManager {
	/// Track if user has ever seen onboarding (first-time UX only)
	/// Role selection state comes from User object, not flags
	private(set) var hasSeenOnboarding: Bool = false
	
	init() {
		loadState()
	}
	
	private func loadState() {
		hasSeenOnboarding = UserDefaults.standard.bool(forKey: StateKeys.hasSeenOnboarding.key)
		print("📂 [AppStateManager] LOADED from UserDefaults:")
		print("   • hasSeenOnboarding: \(hasSeenOnboarding)")
	}
	
	/// Mark onboarding as complete (shows once per app install)
	func completeOnboarding() async throws {
		hasSeenOnboarding = true
		try await saveState()
		print("✅ Onboarding completed")
	}
	
	/// Reset onboarding flag when new user logs in
	func resetForNextUser() async throws {
		hasSeenOnboarding = false
		try await saveState()
		print("🔄 AppState reset for next user")
	}
	
	private func saveState() async throws {
		UserDefaults.standard.set(hasSeenOnboarding, forKey: StateKeys.hasSeenOnboarding.key)
		print("💾 AppState persisted")
	}
}






/*
 Future Enhancment:
 tutorial completion, feature announcements
 */
