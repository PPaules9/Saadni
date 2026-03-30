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
        return Dictionary(uniqueKeysWithValues: relevantServices.map { ($0.id, $0) })
    }

    var isLoading: Bool {
        applicationsStore.isLoadingApplications || servicesStore.isLoadingServices
    }

    var body: some View {
        NavigationStack {
            if let error = applicationsStore.applicationsError {
                ErrorStateView(
                    message: error.errorDescription ?? "Failed to load applications",
                    retryAction: { await applicationsStore.retryLoadingApplications() }
                )
            } else if applicationsStore.isLoadingApplications || isLoading {
                VStack {
                    ProgressView()
                        .tint(.white)
                    Text("Loading applications...")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if applications.isEmpty {
                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundStyle(.accent.opacity(0.3))

                    VStack(spacing: 8) {
                        Text("Find your next job!")
                            .font(.headline)
                        Text("You currently have no open applications")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(applications) { application in
                            if let service = serviceMap[application.serviceId] {
                                AppliedServiceCard(
                                    service: service,
                                    application: application
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("My Jobs")
        .background(Color(.systemGray6).opacity(0.1))
        .refreshable {
            // Manual refresh: listeners update data automatically, but users can pull-to-refresh
            try? await Task.sleep(nanoseconds: 500_000_000) // Brief pause for UX
        }
    }

}

#Preview {
    AppliedJobsView()
        .environment(AuthenticationManager(userCache: UserCache()))
        .environment(ApplicationsStore())
        .environment(ServicesStore())
}
