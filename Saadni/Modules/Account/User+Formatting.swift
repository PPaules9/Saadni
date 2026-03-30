//
//  User+Formatting.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

// MARK: - Display & Formatting

extension User {
    /// User's initials for avatar display
    var initials: String {
        if let name = displayName {
            let components = name.components(separatedBy: " ")
            let initials = components.compactMap { $0.first }.prefix(2)
            return String(initials).uppercased()
        }
        return String(email.prefix(2)).uppercased()
    }

    /// Rating display with stars (e.g., "4.8 ⭐")
    var ratingDisplayAsProvider: String {
        guard let rating = rating else { return "No ratings yet" }
        let stars = String(repeating: "⭐", count: Int(rating.rounded()))
        return String(format: "%.1f", rating) + " " + stars
    }

    var ratingDisplayAsJobSeeker: String {
        guard let rating = rating else { return "No ratings yet" }
        let stars = String(repeating: "⭐", count: Int(rating.rounded()))
        return String(format: "%.1f", rating) + " " + stars
    }

    /// Verification badge color
    var verificationBadgeColor: String {
        switch verificationLevel {
        case .unverified:
            return "gray"
        case .bronze:
            return "orange"
        case .silver:
            return "blue"
        case .gold:
            return "yellow"
        }
    }

    /// Account age in days
    var accountAgeDays: Int {
        return Int(Date().timeIntervalSince(createdAt) / 86400) /* secondsPerDay */
    }

    /// Human-readable last login time
    var lastLoginFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: lastLoginAt, relativeTo: Date())
    }

    /// Profile completion status for a given percentage
    func profileCompletionStatus(for percentage: Int) -> String {
        switch percentage {
        case 0...33:
            return "Incomplete"
        case 34...66:
            return "Partial"
        case 67...99:
            return "Nearly Complete"
        default:
            return "Complete"
        }
    }

    /// Premium status display
    var premiumStatusDisplay: String {
        if !isPremiumMember {
            return "Free Member"
        }
        if isPremiumActive {
            if let days = daysUntilPremiumExpires {
                return "Premium - \(days) days left"
            }
            return "Premium Member"
        }
        return "Premium Expired"
    }

    /// Formatted wallet balance
    var walletBalanceFormatted: String {
        guard let balance = walletBalance else { return "N/A" }
        return String(format: "$%.2f", balance)
    }

    /// Formatted total earnings
    var totalEarningsFormatted: String {
        guard let earnings = totalEarnings else { return "$0.00" }
        return String(format: "$%.2f", earnings)
    }

    /// Formatted hourly rate
    var avgHourlyRateFormatted: String {
        guard let rate = avgHourlyRate else { return "Not set" }
        return String(format: "$%.2f/hr", rate)
    }

    /// Primary contact method display
    var contactMethodDisplay: String {
        switch preferredContactMethod {
        case "email":
            return "📧 Email"
        case "phone":
            return "📱 Phone"
        case "whatsapp":
            return "💬 WhatsApp"
        default:
            return "Not specified"
        }
    }
}
