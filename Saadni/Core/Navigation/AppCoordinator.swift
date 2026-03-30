import SwiftUI

// MARK: - App Coordinator (Root Navigation Hub)
// Routes between JobSeekerCoordinator and ServiceProviderCoordinator based on user role
// Also handles deep linking and global error presentation

@Observable
final class AppCoordinator {
    // Child coordinators (one active at a time)
    var providerCoordinator: ProviderCoordinator?
    var studentCoordinator: StudentCoordinator?

    // Dependencies
    private let authManager: AuthenticationManager
    private let userCache: UserCache

    init(authManager: AuthenticationManager, userCache: UserCache) {
        self.authManager = authManager
        self.userCache = userCache
    }

    // MARK: - Role Management

    func setupCoordinator(for user: User) {
        // Create new coordinator based on role only if it doesn't exist
        // to prevent dropping navigation state when user model updates
        if user.isServiceProvider {
            if studentCoordinator == nil {
                studentCoordinator = StudentCoordinator()
                providerCoordinator = nil
            }
        } else if user.isJobSeeker {
            if providerCoordinator == nil {
                providerCoordinator = ProviderCoordinator()
                studentCoordinator = nil
            }
        } else {
            // Default fallback
            if providerCoordinator == nil {
                providerCoordinator = ProviderCoordinator()
                studentCoordinator = nil
            }
        }
    }

    func switchUserRole() {
        guard let currentUser = authManager.currentUser else { return }

        // Wait for userCache to update, then recreate coordinator
        Task { @MainActor in
            // Give userCache a moment to update
            try? await Task.sleep(for: .milliseconds(100))

            // Fetch updated user
            if let updatedUser = userCache.currentUser {
                setupCoordinator(for: updatedUser)
            }
        }
    }

    // MARK: - Deep Linking

    func handleChatDeepLink(conversationId: String, conversationsStore: ConversationsStore) {
        // Determine which coordinator is active
        if let coordinator = providerCoordinator {
            coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
        } else if let coordinator = studentCoordinator {
            coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
        }
    }
}
