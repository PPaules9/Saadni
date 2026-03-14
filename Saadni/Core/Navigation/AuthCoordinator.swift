//
//  AuthCoordinator.swift
//  Saadni
//
//  Created by Claude Code on 13/03/2026.
//

import SwiftUI

enum AuthFlowStep: Equatable {
    case onboarding
    case authentication
    case roleSelection
}

@Observable
final class AuthCoordinator {
    var currentStep: AuthFlowStep = .onboarding

    // Dependencies
    private let appStateManager: AppStateManager

    init(appStateManager: AppStateManager) {
        self.appStateManager = appStateManager

        // Determine initial step based on state
        if !appStateManager.hasSeenOnboarding {
            currentStep = .onboarding
        } else {
            currentStep = .authentication
        }
    }

    // MARK: - Flow Navigation

    func completeOnboarding() async throws {
        try await appStateManager.completeOnboarding()
        currentStep = .authentication
    }

    func completeAuthentication() {
        currentStep = .roleSelection
    }

    func completeRoleSelection() {
        // Role selection is handled by User object now (isJobSeeker/isServiceProvider)
        // MainView will automatically show app content when user.isJobSeeker is set
        print("✅ Role selection complete - MainView will update automatically")
    }

    func skipToAuthentication() {
        currentStep = .authentication
    }
}
