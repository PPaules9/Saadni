//
//  ProfileViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation
import SwiftUI

@Observable
class ProfileViewModel {
    var isAnimating = false
    var showError = false
    var errorMessage = ""
    var isSwitching = false

    private let authManager: AuthenticationManager
    private let userCache: UserCache
    private let appCoordinator: AppCoordinator
    private let appStateManager: AppStateManager

    init(
        authManager: AuthenticationManager,
        userCache: UserCache,
        appCoordinator: AppCoordinator,
        appStateManager: AppStateManager
    ) {
        self.authManager = authManager
        self.userCache = userCache
        self.appCoordinator = appCoordinator
        self.appStateManager = appStateManager
    }

    // MARK: - Computed Properties

    var currentUserTypeLabel: String {
        if let user = authManager.currentUser {
            if user.isJobSeeker {
                return "Need Help With Something"
            } else if user.isServiceProvider {
                return "Earn Some Cash"
            }
        }
        return "Unknown"
    }

    var currentUserTypeIcon: String {
        if let user = authManager.currentUser {
            if user.isJobSeeker {
                return "magnifyingglass.circle.fill"
            } else if user.isServiceProvider {
                return "briefcase.circle.fill"
            }
        }
        return "questionmark.circle"
    }

    // MARK: - Methods

    func switchUserType() {
        guard let currentUser = authManager.currentUser else { return }

        isSwitching = true

        // Trigger animation
        withAnimation(.easeInOut(duration: 0.6)) {
            isAnimating = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
        }

        Task {
            // Create updated user with switched role
            var updatedUser = currentUser
            updatedUser.isJobSeeker = !updatedUser.isJobSeeker
            updatedUser.isServiceProvider = !updatedUser.isServiceProvider

            // Use UserCache for optimistic update + Firestore sync
            await self.userCache.updateUser(updatedUser)

            // Trigger coordinator to switch role (will recreate fresh coordinator)
            self.appCoordinator.switchUserRole()

            // Update UI state
            await MainActor.run {
                self.isSwitching = false
            }
        }
    }

    func logout() async throws {
        // signOut() now handles all cleanup: auth logout + AppState reset
        try await authManager.signOut()
    }
    
    func deleteAccount() async throws {
        try await authManager.deleteAccount()
    }
}
