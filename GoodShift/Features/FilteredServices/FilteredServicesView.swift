//
//  FilteredServicesView.swift
//  GoodShift
//

import SwiftUI

/// Shows services filtered by time period, tag, or date.
/// `wrapInNavigationStack: true` when presented as a sheet (self-contained).
/// `wrapInNavigationStack: false` when pushed by an existing NavigationStack.
struct FilteredServicesView: View {
    let filter: ServiceTimeFilter
    var wrapInNavigationStack: Bool = true

    @State private var searchText = ""
    @State private var sortOption: SortOption = .none
    @State private var viewMode: ViewMode = .grid
    @State private var searchTask: Task<Void, Never>?

    @Environment(ServicesStore.self) var servicesStore

    enum SortOption { case none, price, alphabetical }
    enum ViewMode { case grid, list }

    var displayedServices: [JobService] {
        switch sortOption {
        case .none:         return servicesStore.services
        case .price:        return servicesStore.services.sorted { $0.price < $1.price }
        case .alphabetical: return servicesStore.services.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }

    var sortedSearchResults: [JobService] {
        switch sortOption {
        case .none:         return servicesStore.searchResults
        case .price:        return servicesStore.searchResults.sorted { $0.price < $1.price }
        case .alphabetical: return servicesStore.searchResults.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }

    private var isSearchActive: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        if wrapInNavigationStack {
            NavigationStack {
                innerContent
                    .navigationDestination(for: ServiceProviderDestination.self) { destination in
                        if case .serviceDetail(let service) = destination {
                            ServiceDetailView(service: service)
                        }
                    }
                    .navigationDestination(for: JobSeekerDestination.self) { destination in
                        if case .serviceDetail(let service) = destination {
                            ServiceDetailView(service: service)
                        }
                    }
            }
            .task { await loadServices() }
            .onChange(of: searchText) { _, newValue in handleSearchChange(newValue) }
            .onAppear { trackFilter() }
        } else {
            innerContent
                .task { await loadServices() }
                .onChange(of: searchText) { _, newValue in handleSearchChange(newValue) }
                .onAppear { trackFilter() }
        }
    }

    // MARK: - Inner content (toolbar, search bar, list)

    private var innerContent: some View {
        ZStack {
            Color(Colors.swiftUIColor(.appBackground))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                searchBar
                serviceScrollView
            }
        }
        .navigationTitle(filter.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewMode = viewMode == .grid ? .list : .grid
                    }
                } label: {
                    Image(systemName: viewMode == .grid ? "list.bullet" : "square.grid.2x2.fill")
                        .font(.system(size: 16))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { sortOption = .none }) {
                        Label("No Sort", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    Button(action: { sortOption = .price }) {
                        Label("Sort by Price", systemImage: "dollarsign.circle")
                    }
                    Button(action: { sortOption = .alphabetical }) {
                        Label("Sort A-Z", systemImage: "abc")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 16))
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            TextField("Search services...", text: $searchText)
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Colors.swiftUIColor(.textPrimary))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var serviceScrollView: some View {
        ScrollView {
            VStack(spacing: 14) {
                if isSearchActive {
                    if servicesStore.isSearching {
                        ProgressView().padding(.top, 40)
                    } else if sortedSearchResults.isEmpty {
                        emptyState(message: "No results for \"\(searchText)\"")
                    } else {
                        serviceList(sortedSearchResults)
                    }
                } else {
                    if displayedServices.isEmpty && !servicesStore.isLoadingServices {
                        emptyState(message: "No services found")
                    } else {
                        serviceList(displayedServices)
                        if servicesStore.hasMoreServices {
                            ProgressView()
                                .padding()
                                .onAppear {
                                    Task {
                                        await servicesStore.fetchServicesFiltered(
                                            tag: filter.tag,
                                            dateRange: filter.dateRange
                                        )
                                    }
                                }
                        }
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await servicesStore.fetchServicesFiltered(
                tag: filter.tag,
                dateRange: filter.dateRange,
                reset: true
            )
        }
    }

    // MARK: - Helpers

    private func trackFilter() {
        let type: String
        let value: String
        switch filter {
        case .thisWeek:          type = "time"; value = "this_week"
        case .tomorrow:          type = "time"; value = "tomorrow"
        case .nextTwoWeeks:      type = "time"; value = "next_two_weeks"
        case .thisMonth:         type = "time"; value = "this_month"
        case .nextMonth:         type = "time"; value = "next_month"
        case .byDate(let d):     type = "date"; value = d.formatted(date: .abbreviated, time: .omitted)
        case .byTag(let tag):    type = "tag";  value = tag
        case .all:               type = "all";  value = "all"
        }
        AnalyticsService.shared.track(.filterApplied(type: type, value: value))
    }

    private func loadServices() async {
        await servicesStore.fetchServicesFiltered(
            tag: filter.tag,
            dateRange: filter.dateRange,
            reset: true
        )
    }

    private func handleSearchChange(_ newValue: String) { // called from onChange
        searchTask?.cancel()
        if newValue.trimmingCharacters(in: .whitespaces).isEmpty {
            servicesStore.searchResults = []
            return
        }
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            await servicesStore.searchServices(query: newValue)
        }
    }

    @ViewBuilder
    private func serviceList(_ services: [JobService]) -> some View {
        ForEach(services, id: \.id) { service in
            Group {
                switch viewMode {
                case .grid: ServiceCard(service: service)
                case .list: ServiceListCard(service: service)
                }
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func emptyState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "briefcase")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text(message)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}


#Preview {
    FilteredServicesView(filter: .all)
        .environment(ServicesStore())
}
