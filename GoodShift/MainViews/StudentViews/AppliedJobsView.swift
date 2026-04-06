//
//  AppliedJobsView.swift
//  GoodShift
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct AppliedJobsView: View {
	@Environment(AuthenticationManager.self) var authManager
	@Environment(ApplicationsStore.self) var applicationsStore
	@Environment(ServicesStore.self) var servicesStore
	@Environment(ReviewsStore.self) var reviewsStore
	@Environment(AppCoordinator.self) var appCoordinator

	@State private var reviewService: JobService?

	var applications: [JobApplication] {
		applicationsStore.myApplications
			.filter { $0.status != .withdrawn }
			.sorted { $0.appliedAt > $1.appliedAt }
	}

	/// Accepted applications where the service is active or pending completion
	var activeApplications: [JobApplication] {
		applications.filter {
			$0.status == .accepted &&
			(serviceMap[$0.serviceId]?.status == .active ||
			 serviceMap[$0.serviceId]?.status == .pendingCompletion)
		}
	}

	/// All other applications (pending, rejected, completed, or non-active accepted)
	var otherApplications: [JobApplication] {
		let activeIds = Set(activeApplications.map { $0.id })
		return applications.filter { !activeIds.contains($0.id) }
	}

	var serviceMap: [String: JobService] {
		let serviceIds = Set(applications.map { $0.serviceId })
		let relevantServices = servicesStore.services.filter { serviceIds.contains($0.id) }
		return Dictionary(relevantServices.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
	}

	var isLoading: Bool {
		applicationsStore.isLoadingApplications || servicesStore.isLoadingServices
	}

	var body: some View {
		Group {
			if let error = applicationsStore.applicationsError {
				ErrorStateView(
					message: error.errorDescription ?? "Failed to load applications",
					retryAction: { await applicationsStore.retryLoadingApplications() }
				)
			} else if applicationsStore.isLoadingApplications || isLoading {
				VStack(spacing: 12) {
					ProgressView()
						.tint(.accent)
					Text("Loading applications...")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else if applications.isEmpty {
				VStack(spacing: 24) {
					Spacer()

					Image(systemName: "bag")
						.font(.system(size: 60))
						.foregroundStyle(.accent.opacity(0.3))

					VStack(spacing: 8) {
						Text("Find your next job!")
							.font(.headline)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						Text("You currently have no open applications")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}

					Spacer()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				ScrollView {
					LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {

						// MARK: Active / Hired Jobs
						if !activeApplications.isEmpty {
							Section {
								ForEach(activeApplications) { application in
									if let service = serviceMap[application.serviceId] {
										applicationRow(application: application, service: service)
									}
								}
							} header: {
								sectionHeader(title: "Active Jobs", systemImage: "briefcase.fill", color: .green)
							}
						}

						// MARK: Other Applications
						if !otherApplications.isEmpty {
							Section {
								ForEach(otherApplications) { application in
									if let service = serviceMap[application.serviceId] {
										applicationRow(application: application, service: service)
									}
								}
							} header: {
								sectionHeader(title: "Applications", systemImage: "tray.full.fill", color: .accent)
							}
						}
					}
					.padding()
				}
				.refreshable {
					try? await Task.sleep(nanoseconds: 500_000_000)
				}
			}
		}
		.navigationTitle("My Jobs")
		.background(Colors.swiftUIColor(.appBackground))
		.sheet(item: $reviewService) { service in
			PostJobReviewSheet(
				service: service,
				revieweeId: service.providerId,
				revieweeName: service.providerName ?? "Provider",
				reviewerRole: .seeker
			)
			.environment(authManager)
			.environment(reviewsStore)
		}
	}

	// MARK: - Section Header

	@ViewBuilder
	private func sectionHeader(title: String, systemImage: String, color: Color) -> some View {
		HStack(spacing: 6) {
			Image(systemName: systemImage)
				.font(.caption)
			Text(title)
				.font(.subheadline)
				.fontWeight(.semibold)
		}
		.foregroundStyle(color)
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical, 4)
		.background(Colors.swiftUIColor(.appBackground))
	}

	// MARK: - Application Row

	@ViewBuilder
	private func applicationRow(application: JobApplication, service: JobService) -> some View {
		VStack(spacing: 0) {
			Button {
				appCoordinator.navigateToServiceDetail(service)
			} label: {
				AppliedServiceCard(service: service, application: application)
			}
			.buttonStyle(.plain)

			if application.status == .accepted {
				if service.status == .pendingCompletion {
					HStack(spacing: 8) {
						Image(systemName: "clock.badge.checkmark.fill")
							.foregroundStyle(.purple)
						Text("Awaiting Confirmation")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.purple)
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 12)
					.background(Color.purple.opacity(0.08))
					.cornerRadius(10)
					.padding([.horizontal, .bottom], 12)
				}
			}

			if application.status == .completed || service.status == .completed {
				Button {
					reviewService = service
				} label: {
					HStack(spacing: 8) {
						Image(systemName: "star.fill")
						Text("Leave a Review")
							.fontWeight(.semibold)
					}
					.font(.subheadline)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 12)
					.background(Color.yellow.opacity(0.15))
					.foregroundColor(.orange)
					.cornerRadius(10)
					.padding([.horizontal, .bottom], 12)
				}
				.buttonStyle(.plain)
			}
		}
	}

}

#Preview {
	AppliedJobsView()
		.environment(AuthenticationManager(userCache: UserCache()))
		.environment(ApplicationsStore())
		.environment(ServicesStore())
}
