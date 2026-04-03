//
//  User+Permissions.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Permissions & Status Checks

extension User {
    /// Whether user can post services (service provider)
    var canPostServices: Bool {
        return isServiceProvider && accountStatus == .active
    }

    /// Whether user can apply to jobs (job seeker)
    var canApplyToJobs: Bool {
        return isJobSeeker && accountStatus == .active
    }

    /// Account is in good standing
    var accountInGoodStanding: Bool {
        return accountStatus == .active && verificationLevel != .unverified
    }

    /// Is account fully verified
    var isFullyVerified: Bool {
        return verificationLevel == .gold && isEmailVerified && isPhoneVerified
    }

    /// Provider score for ranking (0-100)
    var providerScore: Int {
        return UserScoreCalculator.calculateProviderScore(for: self)
    }

    /// Whether premium membership is active
    var isPremiumActive: Bool {
        guard isPremiumMember else { return false }
        guard let expiresAt = premiumExpiresAt else { return true }
        return expiresAt > Date()
    }

    /// Days until premium expires
    var daysUntilPremiumExpires: Int? {
        guard let expiresAt = premiumExpiresAt else { return nil }
        return Int(expiresAt.timeIntervalSince(Date()) / 86400) /* secondsPerDay */
    }

    /// Whether user has auto-reply enabled
    var hasAutoReply: Bool {
        guard let message = responseMessage else { return false }
        return !message.isEmpty
    }
}
