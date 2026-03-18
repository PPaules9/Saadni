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

    @State private var applications: [JobApplication] = []
    @State private var serviceMap: [String: JobService] = [:]
    @State private var isLoading: Bool = true

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
        .task {
            await loadApplications()
        }
    }

    private func loadApplications() async {
        isLoading = true
        guard let userId = authManager.currentUserId else {
            isLoading = false
            return
        }

        // Fetch applications for this user
        applications = await applicationsStore.fetchUserApplications(userId: userId)

        // Extract unique service IDs
        let serviceIds = Array(Set(applications.map { $0.serviceId }))

        // Fetch services by IDs
        let services = await servicesStore.fetchServicesByIds(serviceIds)

        // Build service map for quick lookup
        serviceMap = Dictionary(uniqueKeysWithValues: services.map { ($0.id, $0) })

        // Sort applications by creation date (newest first)
        applications.sort { (app1: JobApplication, app2: JobApplication) in
            app1.appliedAt > app2.appliedAt
        }

        isLoading = false
    }
}

#Preview {
    AppliedJobsView()
        .environment(AuthenticationManager(userCache: UserCache()))
        .environment(ApplicationsStore())
        .environment(ServicesStore())
}
