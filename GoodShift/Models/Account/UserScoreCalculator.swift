//
//  UserScoreCalculator.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Business Logic (Score Calculation)

struct UserScoreCalculator {
    /// Calculate provider score for ranking service providers (0-100)
    static func calculateProviderScore(for user: User) -> Int {
        var score = 0

        // Rating (40 points)
        if let rating = user.rating {
            score += Int((rating / 5.0) * 40)
        }

        // Completion rate (30 points)
        if let completionRate = user.completionRate {
            score += Int((completionRate / 100.0) * 30)
        }

        // Verification level (20 points)
        switch user.verificationLevel {
        case .unverified:
            score += 0
        case .bronze:
            score += 5
        case .silver:
            score += 10
        case .gold:
            score += 20
        }

        // Reviews (10 points)
        if user.totalReviews >= 10 {
            score += 10
        } else if user.totalReviews > 0 {
            score += (user.totalReviews / 10) * 10
        }

        return min(score, 100)
    }
}
