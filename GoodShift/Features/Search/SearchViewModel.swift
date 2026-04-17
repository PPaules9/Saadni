//
//  SearchViewModel.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class SearchViewModel {
    // MARK: - Dependencies
    @ObservationIgnored var servicesStore: ServicesStore?

    // MARK: - Search State
    var searchText = ""
    var selectedCategory: ServiceCategoryType?
    var selectedPriceRange: ClosedRange<Double> = 0...10000
    var sortBy: SortOption = .newest
    var isSearching = false

    // MARK: - Computed Results
    var filteredServices: [JobService] {
        guard let allServices = servicesStore?.services else { return [] }

        var results = allServices

        // Filter by search text
        if !searchText.isEmpty {
            results = results.filter { service in
                service.title.localizedCaseInsensitiveContains(searchText) ||
                service.description.localizedCaseInsensitiveContains(searchText) ||
                service.location.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by category
        if let category = selectedCategory {
            results = results.filter { $0.category == category }
        }

        // Filter by price range
        results = results.filter { service in
            service.price >= selectedPriceRange.lowerBound &&
            service.price <= selectedPriceRange.upperBound
        }

        // Sort results
        results = sortResults(results)

        return results
    }

    var resultsCount: Int {
        return filteredServices.count
    }

    // MARK: - Sort Option
    enum SortOption: String, CaseIterable {
        case newest = "Newest"
        case cheapest = "Cheapest"
        case mostExpensive = "Most Expensive"
        case highestRated = "Highest Rated"
        case closestDistance = "Closest Distance"
    }

    // MARK: - Methods
    private func sortResults(_ services: [JobService]) -> [JobService] {
        switch sortBy {
        case .newest:
            return services.sorted { $0.createdAt > $1.createdAt }
        case .cheapest:
            return services.sorted { $0.price < $1.price }
        case .mostExpensive:
            return services.sorted { $0.price > $1.price }
        case .highestRated:
            return services
        case .closestDistance:
            // Distance sorting would require user location
            // For now, just return as-is
            return services
        }
    }

    /// Clears all search filters and returns to default view
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedPriceRange = 0...10000
        sortBy = .newest
    }

    /// Sets the search text and triggers filter update
    func search(text: String) {
        searchText = text
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        AnalyticsService.shared.track(.searchPerformed(
            query: text,
            resultsCount: resultsCount,
            category: selectedCategory?.rawValue
        ))
    }

    /// Filters by category
    func filterByCategory(_ category: ServiceCategoryType?) {
        selectedCategory = category
    }

    /// Filters by price range
    func filterByPrice(_ range: ClosedRange<Double>) {
        selectedPriceRange = range
    }

    /// Changes sort order
    func setSortBy(_ option: SortOption) {
        sortBy = option
    }
}
