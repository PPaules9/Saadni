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
									NavigationLink(destination: ServiceDetailView(service: service)) {
										AppliedServiceCard(
											service: service,
											application: application
										)
									}
									.buttonStyle(.plain)
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
	}
	
}

#Preview {
	AppliedJobsView()
		.environment(AuthenticationManager(userCache: UserCache()))
		.environment(ApplicationsStore())
		.environment(ServicesStore())
}
