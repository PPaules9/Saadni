//
//  DashboardViewModel.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class DashboardViewModel {
    // MARK: - Dependencies
    @ObservationIgnored var reviewsStore: ReviewsStore?
    @ObservationIgnored var walletStore: WalletStore?
    @ObservationIgnored var servicesStore: ServicesStore?

    // MARK: - Computed Statistics
    var averageRating: Double {
        guard !reviewsStore?.reviewsIReceived.isEmpty ?? true else { return 0 }
        let reviews = reviewsStore?.reviewsIReceived ?? []
        let sum = reviews.reduce(0) { $0 + Double($1.rating) }
        return sum / Double(max(reviews.count, 1))
    }

    var totalReviews: Int {
        return reviewsStore?.reviewsIReceived.count ?? 0
    }

    var walletBalance: Double {
        return walletStore?.walletBalance ?? 0
    }

    var totalServices: Int {
        return servicesStore?.services.count ?? 0
    }

    var activeServices: Int {
        guard let services = servicesStore?.services else { return 0 }
        return services.filter { $0.status == .active || $0.status == .published }.count
    }

    var completedServices: Int {
        guard let services = servicesStore?.services else { return 0 }
        return services.filter { $0.status == .completed }.count
    }

    // MARK: - Formatted Properties
    var formattedBalance: String {
        return String(format: "EGP %.2f", walletBalance)
    }

    var formattedRating: String {
        return String(format: "%.1f", averageRating)
    }

    var ratingDescription: String {
        let rating = averageRating
        switch rating {
        case 4.5...5.0: return "Excellent"
        case 4.0..<4.5: return "Very Good"
        case 3.5..<4.0: return "Good"
        case 3.0..<3.5: return "Fair"
        default: return "No ratings yet"
        }
    }

    // MARK: - Methods
    /// Gets recent transactions for dashboard display
    func getRecentTransactions(limit: Int = 5) -> [Transaction] {
        guard let transactions = walletStore?.transactions else { return [] }
        return Array(transactions.prefix(limit))
    }

    /// Gets recent reviews for dashboard display
    func getRecentReviews(limit: Int = 3) -> [Review] {
        guard let reviews = reviewsStore?.reviewsIReceived else { return [] }
        return Array(reviews.prefix(limit))
    }
}
