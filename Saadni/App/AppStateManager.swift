import Foundation
import Observation

@Observable
class AppStateManager {
    private(set) var hasSeenOnboarding: Bool = false
    private(set) var hasSelectedRole: Bool = false

    init() {
        loadState()
    }

    // MARK: - Load State from Disk
    private func loadState() {
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        hasSelectedRole = UserDefaults.standard.bool(forKey: "hasSelectedRole")
    }

    // MARK: - Onboarding
    func completeOnboarding() {
        hasSeenOnboarding = true
        saveState()
    }

    func resetOnboarding() {
        hasSeenOnboarding = false
        saveState()
    }

    // MARK: - Role Selection
    func completeRoleSelection() {
        hasSelectedRole = true
        saveState()
    }

    func resetRoleSelection() {
        hasSelectedRole = false
        saveState()
    }

    // MARK: - Save State to Disk
    private func saveState() {
        UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        UserDefaults.standard.set(hasSelectedRole, forKey: "hasSelectedRole")
    }
}
