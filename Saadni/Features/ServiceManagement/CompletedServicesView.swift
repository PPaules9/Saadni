//
//  CompletedServicesView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct CompletedServicesView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ServicesStore.self) var servicesStore
    @Environment(ReviewsStore.self) var reviewsStore

    @State private var completedServices: [JobService] = []
    @State private var isLoading: Bool = true
    @State private var showingReviewSheet: Bool = false
    @State private var selectedServiceForReview: JobService?
    @State private var revieweeInfo: (id: String, name: String, role: ReviewerRole)?

    var body: some View {
        ScrollView {
            if isLoading {
                VStack {
                    ProgressView()
                        .tint(.white)
                    Text("Loading completed services...")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else if completedServices.isEmpty {
                ContentUnavailableView(
                    "No Completed Services",
                    systemImage: "checkmark.circle",
                    description: Text("Your completed services will appear here")
                )
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(completedServices) { service in
                        CompletedServiceCard(
                            service: service,
                            canReview: reviewsStore.canReviewService(service, userId: authManager.currentUserId ?? ""),
                            onReview: {
                                prepareReview(for: service)
                            },
                            onArchive: {
                                Task {
                                    await archiveService(service)
                                }
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Completed Services")
        .background(Color(.systemGray6).opacity(0.1))
        .task {
            await loadCompletedServices()
        }
        .sheet(isPresented: $showingReviewSheet) {
            if let service = selectedServiceForReview,
               let reviewee = revieweeInfo {
                SubmitReviewSheet(
                    service: service,
                    revieweeId: reviewee.id,
                    revieweeName: reviewee.name,
                    reviewerRole: reviewee.role
                )
                .onDisappear {
                    // Reload after review submission
                    Task {
                        await loadCompletedServices()
                    }
                }
            }
        }
    }

    private func loadCompletedServices() async {
        isLoading = true
        guard let userId = authManager.currentUserId else {
            isLoading = false
            return
        }
        completedServices = await servicesStore.fetchCompletedServices(userId: userId)
        isLoading = false
    }

    private func prepareReview(for service: JobService) {
        guard let userId = authManager.currentUserId else { return }

        // Determine who to review
        if service.providerId == userId {
            // I'm the provider, review the hired applicant
            if let applicantId = service.hiredApplicantId {
                revieweeInfo = (applicantId, "Worker", .provider)
                selectedServiceForReview = service
                showingReviewSheet = true
            }
        } else {
            // I'm the applicant, review the provider
            revieweeInfo = (service.providerId, service.providerName ?? "Provider", .seeker)
            selectedServiceForReview = service
            showingReviewSheet = true
        }
    }

    private func archiveService(_ service: JobService) async {
        do {
            try await servicesStore.archiveService(serviceId: service.id)
            await loadCompletedServices()
        } catch {
            print("❌ Error archiving service: \(error)")
        }
    }
}

// MARK: - CompletedServiceCard

struct CompletedServiceCard: View {
    let service: JobService
    let canReview: Bool
    let onReview: () -> Void
    let onArchive: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Service header
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    if let completedAt = service.completedAt {
                        Text("Completed \(formatDate(completedAt))")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }

                Spacer()

                Text(service.formattedPrice)
                    .font(.headline)
                    .foregroundStyle(.green)
            }

            Divider()
                .background(Color.gray.opacity(0.3))

            // Action buttons
            HStack(spacing: 12) {
                if canReview {
                    Button(action: onReview) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                            Text("Review")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.yellow.opacity(0.2))
                        .foregroundStyle(.yellow)
                        .cornerRadius(8)
                    }
                }

                Button(action: onArchive) {
                    HStack(spacing: 4) {
                        Image(systemName: "archivebox.fill")
                        Text("Archive")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(.gray)
                    .cornerRadius(8)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    CompletedServicesView()
        .environment(AuthenticationManager(userCache: UserCache()))
        .environment(ServicesStore())
        .environment(ReviewsStore())
}
