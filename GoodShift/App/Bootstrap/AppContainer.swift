//
//  AppContainer.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

@Observable
class AppContainer {
	// MARK: - Session Task (for cancellation)
	@ObservationIgnored
	private var sessionTask: Task<Void, Never>?
	let userCache: UserCache
	let authManager: AuthenticationManager
	let appStateManager: AppStateManager
	
	let servicesStore: ServicesStore
	let applicationsStore: ApplicationsStore
	let messagesStore: MessagesStore
	let conversationsStore: ConversationsStore
	let notificationsStore: NotificationsStore
	let reviewsStore: ReviewsStore
	let walletStore: WalletStore
	let dashboardViewModel: DashboardViewModel

	let errorHandler: ErrorHandler
	
	
	
	func setupUserSession(userId: String) {
		// Cancel any in-progress setup (e.g. double login edge case)
		sessionTask?.cancel()

		sessionTask = Task {
			let startTime = Date()
			print("🚀 [AppContainer] Starting session setup for user: \(userId)")

			NotificationService.shared.setCurrentUser(userId)

			await withTaskGroup(of: (String, Error?).self) { group in
				group.addTask {
					do {
						try await self.applicationsStore.setupListeners(userId: userId)
						return ("ApplicationsStore", nil)
					} catch { return ("ApplicationsStore", error) }
				}
				group.addTask {
					do {
						try await self.reviewsStore.setupListeners(userId: userId)
						return ("ReviewsStore", nil)
					} catch { return ("ReviewsStore", error) }
				}
				group.addTask {
					do {
						try await self.walletStore.setupListeners(userId: userId)
						return ("WalletStore", nil)
					} catch { return ("WalletStore", error) }
				}
				group.addTask {
					await self.conversationsStore.setupListeners(userId: userId)
					return ("ConversationsStore", nil)
				}
				group.addTask {
					await self.notificationsStore.setupListeners(userId: userId)
					return ("NotificationsStore", nil)
				}
				group.addTask {
					await self.servicesStore.fetchServicesPage(reset: true)
					return ("ServicesStore", nil)
				}

				var allSucceeded = true
				for await (storeName, error) in group {
					if let error = error {
						print("❌ \(storeName) setup failed: \(error)")
						self.errorHandler.handle(AppError.from(error))
						allSucceeded = false
					} else {
						print("✅ \(storeName) ready")
					}
				}

				let duration = Date().timeIntervalSince(startTime)
				print(allSucceeded ? "✨ Session ready in \(String(format: "%.2f", duration))s" : "⚠️ Some stores failed (check errors above)")
			}
		}
	}

	func clearUserSession() {
		// Cancel any in-flight setup task first
		sessionTask?.cancel()
		sessionTask = nil

		// Stop all Firestore listeners and clear store state
		applicationsStore.removeAllListeners()
		reviewsStore.removeAllListeners()
		walletStore.removeAllListeners()
		conversationsStore.removeAllListeners()
		notificationsStore.removeAllListeners()
		servicesStore.removeAllListeners()
	}

	init() {
		// Initialize in correct order (dependencies first)
		let cache = UserCache()
		let appState = AppStateManager()
		let authManager = AuthenticationManager(userCache: cache, appStateManager: appState)
		let errorHandler = ErrorHandler()
		
		self.userCache = cache
		self.authManager = authManager
		self.servicesStore = ServicesStore()
		self.applicationsStore = ApplicationsStore()
		self.appStateManager = appState
		self.messagesStore = MessagesStore()
		self.conversationsStore = ConversationsStore()
		self.notificationsStore = NotificationsStore()
		self.errorHandler = errorHandler
		self.reviewsStore = ReviewsStore()
		self.walletStore = WalletStore()
		self.dashboardViewModel = DashboardViewModel()
	}
}



/*
 Developer Notes:
 the initilization of the 4 properties of cache, appState, authManager,.. are here in init() at top to illustrate clearly what will be initilized first
 */
