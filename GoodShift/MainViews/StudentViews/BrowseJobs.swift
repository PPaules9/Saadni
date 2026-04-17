//
//  BrowseJobs.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct BrowseJobsView: View {
	@State private var searchText = ""
	@State private var searchTask: Task<Void, Never>?
	@State private var calendarSelection: Date = Date()
	
	@Environment(ServicesStore.self) var servicesStore
	@Environment(ServiceProviderCoordinator.self) var coordinator
	
	// MARK: - This Week inline cards (client-side filtered from loaded services)
	private var thisWeekServices: [JobService] {
		guard let range = ServiceTimeFilter.thisWeek.dateRange else { return [] }
		return servicesStore.services.filter { service in
			guard let date = service.serviceDate else { return false }
			return range.contains(date)
		}
	}
	
	private var jobDates: Set<DateComponents> {
		Set(servicesStore.services.compactMap { service in
			guard let d = service.serviceDate else { return nil }
			return Calendar.current.dateComponents([.year, .month, .day], from: d)
		})
	}
	
	private var isSearchActive: Bool {
		!searchText.trimmingCharacters(in: .whitespaces).isEmpty
	}
	
	// MARK: - Service icon entries
	private struct ServiceIconEntry {
		let image: String
		let tag: ServiceTagOption
	}
	
	private let serviceIcons: [ServiceIconEntry] = [
		.init(image: "cleaning",  tag: .cleaning),
		.init(image: "cashier",   tag: .cashier),
		.init(image: "moving",    tag: .moving),
		.init(image: "barista",   tag: .barista),
		.init(image: "delivery",  tag: .delivery),
		.init(image: "fixing",    tag: .fixing),
		.init(image: "furniture", tag: .furniture),
	]
	
	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()
			
			if isSearchActive {
				searchResultsView
			} else {
				discoveryScrollView
			}
		}
		.searchable(text: $searchText, prompt: "Search services...")
		.onChange(of: searchText) { _, newValue in
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
		.task {
			if servicesStore.services.isEmpty {
				await servicesStore.fetchServicesPage(reset: true)
			}
		}
	}
	
	// MARK: - Discovery hub (5 sections)
	
	private var discoveryScrollView: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: 24) {
				
				// ── Section 1: Service Type Icons ──────────────────────
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 20) {
						ForEach(serviceIcons, id: \.tag) { entry in
							Button {
								coordinator.presentSheet(
									.filteredServices(filter: .byTag(entry.tag.rawValue))
								)
							} label: {
								CircularService(
									serviceImage: entry.image,
									serviceName: LocalizedStringResource(stringLiteral: entry.tag.rawValue)
								)
							}
							.buttonStyle(.plain)
						}
					}
					.padding(.horizontal)
				}
				.padding(.bottom, 4)
				
				// ── Section 2: This Week ───────────────────────────────
				VStack(alignment: .leading, spacing: 12) {
					SectionHeader(
						title: "This Week",
						showViewAll: true,
						onViewAllTap: { coordinator.navigate(to: .filteredServices(filter: .thisWeek)) }
					)
					.padding(.horizontal)
					
					if servicesStore.isLoadingServices && thisWeekServices.isEmpty {
						// Shimmer placeholders while loading
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 12) {
								ForEach(0..<3, id: \.self) { _ in
									ServiceCardSkeleton()
										.frame(width: 300)
								}
							}
							.padding(.horizontal)
						}
					} else if thisWeekServices.isEmpty {
						Text("No shifts this week")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							.padding(.horizontal)
					} else {
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 12) {
								ForEach(thisWeekServices, id: \.id) { service in
									Button {
										coordinator.navigate(to: .serviceDetail(service))
									} label: {
										ServiceCard(service: service)
											.frame(width: 300)
									}
									.buttonStyle(.plain)
								}
							}
							.padding(.horizontal)
						}
					}
				}
				
				// ── Section 3: 2×2 Time Grid ──────────────────────────
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
					TimeGridButton(title: "Tomorrow", icon: "sunrise.fill", color: .orange) {
						coordinator.presentSheet(.filteredServices(filter: .tomorrow))
					}
					TimeGridButton(title: "Next Two Weeks", icon: "calendar", color: .blue) {
						coordinator.presentSheet(.filteredServices(filter: .nextTwoWeeks))
					}
					TimeGridButton(title: "This Month", icon: "calendar.badge.clock", color: .green) {
						coordinator.presentSheet(.filteredServices(filter: .thisMonth))
					}
					TimeGridButton(title: "Next Month", icon: "calendar.badge.plus", color: .purple) {
						coordinator.presentSheet(.filteredServices(filter: .nextMonth))
					}
				}
				.padding(.horizontal)
				
				// ── Section 4: Calendar ───────────────────────────────
				VStack(alignment: .leading, spacing: 12) {
					SectionHeader(title: "Pick a Date")
						.padding(.horizontal)
					
					CustomCalendarWithJobIndicators(
						selectedDate: $calendarSelection,
						jobDates: jobDates,
						onDateSelected: { date in
							coordinator.presentSheet(
								.filteredServices(filter: .byDate(date))
							)
						}
					)
					.padding(.horizontal)
				}
				
				// ── Section 5: All Services ───────────────────────────
				Button {
					coordinator.presentSheet(.filteredServices(filter: .all))
				} label: {
					HStack {
						Image(systemName: "list.bullet.below.rectangle")
						Text("All Services")
							.fontWeight(.semibold)
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 14)
					.background(Colors.swiftUIColor(.cardBackground))
					.foregroundStyle(Color.accent)
					.cornerRadius(14)
				}
				.buttonStyle(.plain)
				.padding(.horizontal)
				.padding(.bottom, 24)
			}
			.padding(.top, 8)
		}
		.refreshable {
			await servicesStore.fetchServicesPage(reset: true)
		}
	}
	
	// MARK: - Search Results overlay
	
	private var searchResultsView: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 14) {
				if servicesStore.isSearching {
					ProgressView()
						.padding(.top, 40)
				} else if servicesStore.searchResults.isEmpty {
					VStack(spacing: 16) {
						Image(systemName: "magnifyingglass")
							.font(.system(size: 48))
							.foregroundStyle(.gray)
						Text("No results for \"\(searchText)\"")
							.font(.headline)
							.foregroundStyle(.gray)
					}
					.frame(maxWidth: .infinity)
					.padding(.top, 60)
				} else {
					ForEach(servicesStore.searchResults, id: \.id) { service in
						Button {
							coordinator.navigate(to: .serviceDetail(service))
						} label: {
							ServiceCard(service: service)
						}
						.buttonStyle(.plain)
					}
				}
			}
			.padding()
		}
	}
}

// MARK: - Time Grid Button

private struct TimeGridButton: View {
	let title: String
	let icon: String
	let color: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(alignment: .leading, spacing: 10) {
				Image(systemName: icon)
					.font(.system(size: 22, weight: .semibold))
					.foregroundStyle(color)
				Spacer()
				Text(title)
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.primary)
					.multilineTextAlignment(.leading)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(16)
			.frame(height: 100)
			.background(Colors.swiftUIColor(.cardBackground))
			.cornerRadius(14)
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	let userCache = UserCache()
	return BrowseJobsView()
		.environment(ServicesStore())
		.environment(AuthenticationManager(userCache: userCache))
		.environment(userCache)
		.environment(ServiceProviderCoordinator())
}
