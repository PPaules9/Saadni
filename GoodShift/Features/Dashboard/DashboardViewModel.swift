//
//  DashboardViewModel.swift
//  GoodShift
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
        guard !(reviewsStore?.reviewsIReceived.isEmpty ?? true) else { return 0 }
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
        return "\(Currency.current.symbol) \(String(format: "%.2f", walletBalance))"
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

    // MARK: - Recent Activity (Student / JobSeeker)

    /// Derives displayable activities by joining the student's applications with
    /// their associated services. No Firestore writes — pure derivation from
    /// already-live real-time data. Returns at most `limit` items, newest first.
    func recentActivities(
        applications: [JobApplication],
        services: [JobService],
        limit: Int? = 5
    ) -> [ServiceActivity] {
        let sorted = applications.sorted { $0.appliedAt > $1.appliedAt }
        let scanned = limit.map { sorted.prefix($0 * 3) }.map(Array.init) ?? sorted
        let matched = scanned.compactMap { application -> ServiceActivity? in
            guard let service = services.first(where: { $0.id == application.serviceId }) else {
                return nil
            }
            return ServiceActivity(application: application, service: service)
        }
        if let limit {
            return Array(matched.prefix(limit))
        }
        return matched
    }
}
