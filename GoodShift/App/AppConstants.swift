//
//  AppConstants.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import Foundation

// MARK: - AppConstants
// Static compile-time constants for the entire app.
// Use these instead of inline string literals to catch typos at build time.

enum AppConstants {
	
	// MARK: App Info
	enum App {
		static let name: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "GoodShift"
	}
	
	// MARK: UserDefaults / AppStorage Keys
	// Always use these constants instead of inline string literals.
	// A typo in a string key silently reads a nil value; a typo here is a build error.
	enum Storage {
		static let appCurrency       = "appCurrency"
		static let appLanguage       = "appLanguage"
		static let hasSeenOnboarding = "hasSeenOnboarding"
	}
	
	// MARK: Image Cache Configuration
	enum Cache {
		static let memoryLimitBytes: Int = 100 * 1024 * 1024  // 100 MB
		static let diskLimitBytes: UInt  = 500 * 1024 * 1024  // 500 MB
		static let expirationDays: Int   = 7
	}
	
	// MARK: Firestore Collection Names
	// Always reference collections through these constants — never inline "users", "services", etc.
	// A typo here is a build error; a typo inline is a silent runtime failure.
	enum Firestore {
		static let users                   = "users"
		static let services                = "services"
		static let applications            = "applications"
		static let reviews                 = "reviews"
		static let transactions            = "transactions"
		static let messages                = "messages"
		static let conversations           = "conversations"
		static let notifications           = "notifications"
		static let typing                  = "typing"
		static let deviceTokens            = "deviceTokens"
		static let fcmTokens               = "fcmTokens"
		static let notificationPreferences = "notificationPreferences"
	}
}

// MARK: - AppInfo (backward-compat alias)
// Kept so any existing code referencing AppInfo.name continues to compile.
typealias AppInfo = AppConstants.App
