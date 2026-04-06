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
        guard authManager.currentUser != nil else { return }

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

    // MARK: - Convenience Navigation (cross-role passthrough)

    func navigateToChat(conversationId: String) {
        if let c = providerCoordinator {
            c.navigate(to: JobSeekerDestination.chatDetail(conversationId: conversationId))
        } else if let c = studentCoordinator {
            c.navigate(to: ServiceProviderDestination.chatDetail(conversationId: conversationId))
        }
    }

    func navigateToServiceDetail(_ service: JobService) {
        if let c = providerCoordinator {
            c.navigate(to: JobSeekerDestination.serviceDetail(service))
        } else if let c = studentCoordinator {
            c.navigate(to: ServiceProviderDestination.serviceDetail(service))
        }
    }

    func navigateToPerformance() {
        if let c = providerCoordinator {
            c.navigate(to: ServiceProviderDestination.performance)
        } else if let c = studentCoordinator {
            c.navigate(to: ServiceProviderDestination.performance)
        }
    }

    func presentSheet(_ sheet: SheetDestination) {
        providerCoordinator?.presentSheet(sheet)
        studentCoordinator?.presentSheet(sheet)
    }

    func dismissSheet() {
        providerCoordinator?.dismissSheet()
        studentCoordinator?.dismissSheet()
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

    // MARK: - Notification Navigation

    func handleNotificationNavigation(_ notification: Notification) {
        if let coordinator = providerCoordinator {
            handleJobSeekerNavigation(notification, coordinator: coordinator)
        } else if let coordinator = studentCoordinator {
            handleServiceProviderNavigation(notification, coordinator: coordinator)
        }
    }

    private func handleJobSeekerNavigation(_ notification: Notification, coordinator: ProviderCoordinator) {
        switch notification.type {
        case .newMessageFromProvider:
            if let conversationId = notification.payload?.conversationId {
                coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
            } else {
                coordinator.selectTab(.chat)
            }
        case .applicationStatus, .applicationWithdrawnAck, .jobReminder, .jobCancelledByProvider:
            coordinator.selectTab(.myJobs)
        case .reviewPostedByProvider:
            coordinator.selectTab(.profile)
        case .earningReceived, .topupSuccess, .withdrawalProcessed, .matchingJob:
            coordinator.selectTab(.dashboard)
        default:
            break
        }
    }

    private func handleServiceProviderNavigation(_ notification: Notification, coordinator: StudentCoordinator) {
        switch notification.type {
        case .newMessageFromSeeker:
            if let conversationId = notification.payload?.conversationId {
                coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
            } else {
                coordinator.selectTab(.chat)
            }
        case .newApplicationReceived:
            coordinator.selectTab(.myJobs)
            if let serviceId = notification.payload?.serviceId,
               let serviceName = notification.payload?.serviceName {
                Task { @MainActor in
                    coordinator.presentSheet(.applicationsList(serviceId: serviceId, serviceTitle: serviceName))
                }
            }
        case .applicationAcceptedBySeeker, .applicationWithdrawnBySeeker, .jobStartsSoon, .jobExpiringSoon:
            coordinator.selectTab(.myJobs)
        case .paymentReceived, .withdrawalPending:
            coordinator.selectTab(.home)
        case .reviewPostedBySeeker, .lowRatingAlert:
            coordinator.selectTab(.profile)
        default:
            break
        }
    }
}
