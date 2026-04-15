//
//  GoodShiftApp.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Kingfisher

@main
struct GoodShiftApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@State private var container: AppContainer
	@AppStorage(AppConstants.Storage.appLanguage) private var appLanguage = "en"
	
	init() {
		
		FirebaseApp.configure()
		// AnalyticsService is initialized inside AppContainer — no need to touch .shared here
		
		// Configure Kingfisher image cache, the actual loading happens wherever you use something like KFImage(URL(string: ...)) in your views.
		let cache = ImageCache.default
		cache.memoryStorage.config.totalCostLimit = AppConstants.Cache.memoryLimitBytes
		cache.diskStorage.config.sizeLimit = AppConstants.Cache.diskLimitBytes
		cache.diskStorage.config.expiration = .days(AppConstants.Cache.expirationDays)
		
		// Initialize container after Firebase is configured
		_container = State(initialValue: AppContainer())
	}
	
	var body: some Scene {
		WindowGroup {
			MainView()
				.environment(container)
				.environment(container.userFetchCache)
				.environment(\.notificationsStore, container.notificationsStore)
				.environment(\.locale, Locale(identifier: appLanguage))
				.environment(\.layoutDirection, appLanguage == "ar" ? .rightToLeft : .leftToRight)
				.onAppear {
					setupNotificationDelegates()
				}
				.onChange(of: container.appStateManager.hasSeenOnboarding) { _, hasSeen in
					if hasSeen {
						requestPushNotificationPermission()
					}
				}
				.onChange(of: container.authManager.currentUserId) { _, newValue in
					if let userId = newValue {
						container.setupUserSession(userId: userId)
					} else {
						container.clearUserSession()
					}
				}
		}
	}
	
	private func setupNotificationDelegates() {
		UNUserNotificationCenter.current().delegate = delegate
		Messaging.messaging().delegate = delegate
	}
	
	private func requestPushNotificationPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
				print("✅ Push notification permission granted")
			} else if let error = error {
				print("❌ Push notification permission error: \(error.localizedDescription)")
			}
		}
	}
}





/*
 Developer Notes:
 .environment(\.notificationsStore, container.notificationsStore)
 it doesn’t need to know about AppContainer at all. It only depends on “I can get a NotificationsStore from the environment.”
 Why that can be useful:
 Some features might only need NotificationsStore, not the whole container.
 You can swap just the notificationsStore in previews/tests by overriding the environment key, without touching AppContainer.
 It keeps those views less tightly coupled to your DI container type.
 if you overuse a giant container, @Environment(AppContainer.self) might cause more parts of your tree to react to changes than necessary, while a focused notificationsStore environment key keeps updates scoped to views that actually care. That’s more about render scope than pure speed.
 So:
 .environment(container) = inject big “service locator” object.
 .environment(\.notificationsStore, ...) = inject a single, focused dependency via a specific key.
 
 */
