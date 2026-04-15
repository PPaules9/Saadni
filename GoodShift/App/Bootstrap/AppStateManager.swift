//
//  AppStateManager.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//


import Foundation

@Observable
class AppStateManager {
	
	private(set) var hasSeenOnboarding: Bool = false
	
	init() {
		loadState()
	}
	
	private func loadState() {
		hasSeenOnboarding = UserDefaults.standard.bool(forKey: AppConstants.Storage.hasSeenOnboarding)
//		print("📂 [AppStateManager] LOADED from UserDefaults:")
//		print("   • hasSeenOnboarding: \(hasSeenOnboarding)")
	}
	
	func completeOnboarding() async throws {
		hasSeenOnboarding = true
		try await saveState()
//		print("✅ Onboarding completed")
	}
	
	/// Reset onboarding flag when new user logs in
	func resetForNextUser() async throws {
		hasSeenOnboarding = false
		try await saveState()
//		print("🔄 AppState reset for next user")
	}
	
	private func saveState() async throws {
		UserDefaults.standard.set(hasSeenOnboarding, forKey: AppConstants.Storage.hasSeenOnboarding)
//		print("💾 AppState persisted")
	}
}






/*
 Future Enhancment:
 tutorial completion, feature announcements
 */
