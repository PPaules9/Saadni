//
//  ProfileViewModel.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation
import SwiftUI

@Observable
final class ProfileViewModel {
    var isAnimating = false
    var showError = false
    var errorMessage = ""
    var isSwitching = false

    // Closure called after role switch completes — wired by the View to the coordinator.
    // ViewModels must never hold a reference to a Coordinator directly.
    var onRoleSwitched: ((User) -> Void)?

    private let authManager: AuthenticationManager
    private let userCache: UserCache
    private let appStateManager: AppStateManager

    init(
        authManager: AuthenticationManager,
        userCache: UserCache,
        appStateManager: AppStateManager
    ) {
        self.authManager = authManager
        self.userCache = userCache
        self.appStateManager = appStateManager
    }

    // MARK: - Computed Properties

    var currentUserTypeLabel: String {
        guard let user = authManager.currentUser else { return "Unknown" }
        return user.isJobSeeker ? "Need Help With Something" : "Earn Some Cash"
    }

    var currentUserTypeIcon: String {
        guard let user = authManager.currentUser else { return "questionmark.circle" }
        return user.isJobSeeker ? "magnifyingglass.circle.fill" : "briefcase.circle.fill"
    }

    // MARK: - Actions

    func switchUserType() {
        guard let currentUser = authManager.currentUser else { return }
        isSwitching = true

        withAnimation(.easeInOut(duration: 0.6)) { isAnimating = true }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            isAnimating = false
        }

        Task { @MainActor in
            var updatedUser = currentUser
            updatedUser.isJobSeeker.toggle()
            updatedUser.isServiceProvider.toggle()

            await userCache.updateUser(updatedUser)

            let newRole = updatedUser.isJobSeeker ? "job_seeker" : "service_provider"
            AnalyticsService.shared.track(.roleSwitched(to: newRole))
            AnalyticsService.shared.setUserProperties(role: newRole)

            // Notify the coordinator through the closure — no direct dependency
            onRoleSwitched?(updatedUser)
            isSwitching = false
        }
    }

    func logout() async throws {
        try authManager.signOut()
    }
}
