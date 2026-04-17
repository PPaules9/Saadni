//
//  MainView.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct MainView: View {
	@Environment(AppContainer.self) var container
	@State private var appCoordinator: AppCoordinator?
	
	var body: some View {
		Group {
			switch container.authManager.authState {
			case .authenticating:                    //1
				LaunchScreen()
				
			case .unauthenticated:                   //2
				OnboardingView()
				
			case .authenticated:                    //3
				if let user = container.authManager.currentUser {
					// Source of truth: User object (not flags)
					// Check if user has selected a role
					let hasSelectedRole = user.isJobSeeker || user.isServiceProvider
					
					if hasSelectedRole {
						if let appCoordinator = appCoordinator {
							authenticatedContent(for: user)
								.environment(appCoordinator)
						} else {
							ProgressView().tint(.accent)
						}
					} else {
						// User is authenticated but hasn't selected a role yet
						RoleSelectionView(user: user)
					}
				} else {
					// Authenticated but user data not loaded yet
					LaunchScreen()
				}
			}
		}
		.environment(container.appStateManager)
		.environment(container.userCache)
		.environment(container.authManager)
		.environment(container.errorHandler)
		.environment(container.conversationsStore)
		.environment(container.applicationsStore)
		.environment(container.servicesStore)
		.environment(container.messagesStore)
		.environment(container.reviewsStore)
		.environment(container.walletStore)
		.alert("Error", isPresented: Binding(
			get: { container.errorHandler.isPresented },
			set: { newValue in
				if !newValue {
					container.errorHandler.dismiss()
				}
			}
		)) {
			Button("Dismiss") {
				container.errorHandler.dismiss()
			}
			if container.errorHandler.retryAction != nil {
				Button("Retry") {
					container.errorHandler.retry()
				}
			}
		} message: {
			if let error = container.errorHandler.currentError {
				VStack(alignment: .leading, spacing: 8) {
					Text(error.errorDescription ?? "Unknown error")
						.font(.body)
					if let suggestion = error.recoverySuggestion {
						Text(suggestion)
							.font(.caption)
							.foregroundStyle(.secondary)
					}
				}
			}
		}
		.task {
			// Initialize app coordinator on first load
			if appCoordinator == nil, let user = container.authManager.currentUser {
				let coordinator = AppCoordinator(
					authManager: container.authManager,
					userCache: container.userCache
				)
				appCoordinator = coordinator
				coordinator.setupCoordinator(for: user)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .openChat)) { notification in
			if let conversationId = notification.object as? String {
				appCoordinator?.handleChatDeepLink(conversationId: conversationId, conversationsStore: container.conversationsStore)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .openJobDetail)) { notification in
			if let jobId = notification.object as? String {
				appCoordinator?.handleJobDetailDeepLink(jobId: jobId)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .openJobApplications)) { notification in
			if let jobId = notification.object as? String {
				appCoordinator?.handleJobApplicationsDeepLink(jobId: jobId)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .openApplicationDetail)) { notification in
			if let applicationId = notification.object as? String {
				appCoordinator?.handleApplicationDetailDeepLink(applicationId: applicationId)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .openReview)) { _ in
			appCoordinator?.handleReviewDeepLink()
		}
		.onReceive(NotificationCenter.default.publisher(for: .openTransaction)) { _ in
			appCoordinator?.handleWalletDeepLink()
		}
		.onReceive(NotificationCenter.default.publisher(for: .openWallet)) { _ in
			appCoordinator?.handleWalletDeepLink()
		}
		.onReceive(NotificationCenter.default.publisher(for: .openProfile)) { _ in
			appCoordinator?.handleProfileDeepLink()
		}
		.onChange(of: container.authManager.currentUser) { oldUser, newUser in
			// When user changes (login or role switch), setup coordinator
			if let user = newUser {
				if appCoordinator == nil {
					// First login - create coordinator
					let coordinator = AppCoordinator(
						authManager: container.authManager,
						userCache: container.userCache
					)
					appCoordinator = coordinator
				}
				// Setup/update coordinator for current user role
				appCoordinator?.setupCoordinator(for: user)
			}
		}
	}
	
	@ViewBuilder
	private func authenticatedContent(for user: User) -> some View {
		if user.isJobSeeker {
			WantToWork()
		} else if user.isServiceProvider {
			WantToHire()
		}
	}
}

#Preview {
	MainView()
		.environment(AppContainer())
}
