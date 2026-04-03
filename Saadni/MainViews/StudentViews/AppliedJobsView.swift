//
//  AppliedJobsView.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct AppliedJobsView: View {
	@Environment(AuthenticationManager.self) var authManager
	@Environment(ApplicationsStore.self) var applicationsStore
	@Environment(ServicesStore.self) var servicesStore
	@Environment(ReviewsStore.self) var reviewsStore
	@Environment(ConversationsStore.self) var conversationsStore

	@State private var markDoneService: JobService?
	@State private var reviewService: JobService?
	
	var applications: [JobApplication] {
		applicationsStore.myApplications
			.filter { $0.status != .withdrawn }
			.sorted { $0.appliedAt > $1.appliedAt }
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
		NavigationStack {
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
						LazyVStack(spacing: 12) {
							ForEach(applications) { application in
								if let service = serviceMap[application.serviceId] {
									VStack(spacing: 0) {
										NavigationLink(destination: ServiceDetailView(service: service)) {
											AppliedServiceCard(
												service: service,
												application: application
											)
										}
										.buttonStyle(.plain)

										// Quick action for hired student
										if application.status == .accepted {
											if service.status == .active {
												Button {
													markDoneService = service
												} label: {
													HStack(spacing: 8) {
														Image(systemName: "checkmark.circle.fill")
														Text("Mark as Done")
															.fontWeight(.semibold)
													}
													.font(.subheadline)
													.frame(maxWidth: .infinity)
													.padding(.vertical, 12)
													.background(Color.green)
													.foregroundColor(.white)
													.cornerRadius(10)
													.padding([.horizontal, .bottom], 12)
												}
												.buttonStyle(.plain)
											} else if service.status == .pendingCompletion {
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
		}
		.sheet(item: $markDoneService) { service in
			MarkJobDoneView(service: service)
				.environment(applicationsStore)
				.environment(conversationsStore)
		}
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
	
}

#Preview {
	AppliedJobsView()
		.environment(AuthenticationManager(userCache: UserCache()))
		.environment(ApplicationsStore())
		.environment(ServicesStore())
}
