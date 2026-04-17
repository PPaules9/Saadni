import SwiftUI

// MARK: - App Coordinator (Root Navigation Hub)
// Routes between JobSeekerCoordinator and ServiceJobSeekerCoordinator based on user role
// Also handles deep linking and global error presentation

@Observable
final class AppCoordinator {
    // Child coordinators (one active at a time)
    var jobSeekerCoordinator: JobSeekerCoordinator?
    var serviceProviderCoordinator: ServiceProviderCoordinator?

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
        if user.isJobSeeker {
            if serviceProviderCoordinator == nil {
                serviceProviderCoordinator = ServiceProviderCoordinator()
                jobSeekerCoordinator = nil
            }
        } else if user.isServiceProvider {
            if jobSeekerCoordinator == nil {
                jobSeekerCoordinator = JobSeekerCoordinator()
                serviceProviderCoordinator = nil
            }
        } else {
            // Default fallback
            if serviceProviderCoordinator == nil {
                serviceProviderCoordinator = ServiceProviderCoordinator()
                jobSeekerCoordinator = nil
            }
        }
    }

    /// Call this with the already-updated User after the cache has been written.
    /// Receives the user directly to avoid any timing race between the cache write
    /// and reading it back (previously required a fragile Task.sleep workaround).
    func switchUserRole(to updatedUser: User) {
        setupCoordinator(for: updatedUser)
    }

    // MARK: - Convenience Navigation (cross-role passthrough)

    func navigateToChat(conversationId: String) {
        if let c = jobSeekerCoordinator {
            c.navigate(to: JobSeekerDestination.chatDetail(conversationId: conversationId))
        } else if let c = serviceProviderCoordinator {
            c.navigate(to: ServiceProviderDestination.chatDetail(conversationId: conversationId))
        }
    }

    func navigateToServiceDetail(_ service: JobService) {
        if let c = jobSeekerCoordinator {
            c.navigate(to: JobSeekerDestination.serviceDetail(service))
        } else if let c = serviceProviderCoordinator {
            c.navigate(to: ServiceProviderDestination.serviceDetail(service))
        }
    }

    func navigateToPerformance() {
        if let c = jobSeekerCoordinator {
            c.selectTab(.profile)
            Task { @MainActor in
                c.navigate(to: ServiceProviderDestination.performance)
            }
        } else if let c = serviceProviderCoordinator {
            c.selectTabAndNavigate(to: .profile, destination: .performance)
        }
    }

    func presentSheet(_ sheet: SheetDestination) {
        jobSeekerCoordinator?.presentSheet(sheet)
        serviceProviderCoordinator?.presentSheet(sheet)
    }

    func dismissSheet() {
        jobSeekerCoordinator?.dismissSheet()
        serviceProviderCoordinator?.dismissSheet()
    }

    // MARK: - Deep Linking

    func handleChatDeepLink(conversationId: String, conversationsStore: ConversationsStore) {
        // Determine which coordinator is active
        if let coordinator = jobSeekerCoordinator {
            coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
        } else if let coordinator = serviceProviderCoordinator {
            coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
        }
    }

    func handleJobDetailDeepLink(jobId: String) {
        jobSeekerCoordinator?.selectTab(.myJobs)
        serviceProviderCoordinator?.selectTab(.myJobs)
    }

    func handleJobApplicationsDeepLink(jobId: String) {
        if let coordinator = serviceProviderCoordinator {
            coordinator.selectTabAndNavigate(to: .myJobs, destination: .applicationsList(serviceId: jobId, serviceTitle: ""))
        } else {
            jobSeekerCoordinator?.selectTab(.myJobs)
        }
    }

    func handleApplicationDetailDeepLink(applicationId: String) {
        jobSeekerCoordinator?.selectTab(.myJobs)
        serviceProviderCoordinator?.selectTab(.myJobs)
    }

    func handleReviewDeepLink() {
        if let coordinator = serviceProviderCoordinator {
            coordinator.selectTabAndNavigate(to: .profile, destination: .performance)
        } else {
            jobSeekerCoordinator?.selectTab(.profile)
        }
    }

    func handleWalletDeepLink() {
        presentSheet(.walletSheet)
    }

    func handleProfileDeepLink() {
        jobSeekerCoordinator?.selectTab(.profile)
        serviceProviderCoordinator?.selectTab(.profile)
    }

    // MARK: - Notification Navigation

    func handleNotificationNavigation(_ notification: Notification) {
        if let coordinator = jobSeekerCoordinator {
            handleJobSeekerNavigation(notification, coordinator: coordinator)
        } else if let coordinator = serviceProviderCoordinator {
            handleServiceProviderNavigation(notification, coordinator: coordinator)
        }
    }

    private func handleJobSeekerNavigation(_ notification: Notification, coordinator: JobSeekerCoordinator) {
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
            Task { @MainActor in
                coordinator.navigate(to: ServiceProviderDestination.performance)
            }
        case .earningReceived, .topupSuccess, .withdrawalProcessed, .matchingJob:
            coordinator.selectTab(.dashboard)
        default:
            break
        }
    }

    private func handleServiceProviderNavigation(_ notification: Notification, coordinator: ServiceProviderCoordinator) {
        switch notification.type {
        case .newMessageFromSeeker:
            if let conversationId = notification.payload?.conversationId {
                coordinator.selectTabAndNavigate(to: .chat, destination: .chatDetail(conversationId: conversationId))
            } else {
                coordinator.selectTab(.chat)
            }
        case .newApplicationReceived:
            if let serviceId = notification.payload?.serviceId,
               let serviceName = notification.payload?.serviceName {
                coordinator.selectTabAndNavigate(to: .myJobs, destination: .applicationsList(serviceId: serviceId, serviceTitle: serviceName))
            } else {
                coordinator.selectTab(.myJobs)
            }
        case .applicationAcceptedBySeeker, .applicationWithdrawnBySeeker, .jobStartsSoon, .jobExpiringSoon:
            coordinator.selectTab(.myJobs)
        case .paymentReceived, .withdrawalPending:
            coordinator.selectTab(.home)
        case .reviewPostedBySeeker, .lowRatingAlert:
            coordinator.selectTabAndNavigate(to: .profile, destination: .performance)
        default:
            break
        }
    }
}
