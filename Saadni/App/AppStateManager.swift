import Foundation
import Observation
import os

@Observable
class AppStateManager {
    private(set) var hasSeenOnboarding: Bool = false
    private(set) var hasSelectedRole: Bool = false

    // Dependency injection
    private let persistence: PersistenceProvider

    // For debugging
    private let logger: Logger

    init(
        persistence: PersistenceProvider = UserDefaultsProvider(),
        logger: Logger = Logger(subsystem: "com.saadni.app", category: "AppState")
    ) {
        self.persistence = persistence
        self.logger = logger
        loadState()
    }

    private func loadState() {
        do {
            hasSeenOnboarding = persistence.load(StateKeys.hasSeenOnboarding)
            hasSelectedRole = persistence.load(StateKeys.hasSelectedRole)
            logger.log("✅ State loaded successfully")
        } catch {
            logger.error("❌ Failed to load state: \(error, privacy: .public)")
            // Graceful fallback: use defaults (already set above)
        }
    }

    func completeOnboarding() async throws {
        hasSeenOnboarding = true
        try await saveState()
        logger.info("👤 Onboarding completed")
    }

    func resetOnboarding() async throws {
        hasSeenOnboarding = false
        try await saveState()
    }

    func completeRoleSelection() async throws {
        hasSelectedRole = true
        try await saveState()
    }

    func resetRoleSelection() async throws {
        hasSelectedRole = false
        try await saveState()
    }

    private func saveState() async throws {
        try await persistence.save(hasSeenOnboarding, for: StateKeys.hasSeenOnboarding)
        try await persistence.save(hasSelectedRole, for: StateKeys.hasSelectedRole)
        logger.debug("💾 State persisted")
    }
}
