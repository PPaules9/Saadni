//
//  ServiceListCard.swift
//  Saadni
//
//  Created by Pavly Paules on 30/03/2026.
//

import SwiftUI

struct ServiceListCard: View {
    let service: JobService
    @Environment(AuthenticationManager.self) var authManager
    @Environment(AppCoordinator.self) var appCoordinator

    private var isOwnService: Bool {
        guard let currentUserId = authManager.currentUserId else { return false }
        return service.providerId == currentUserId
    }

    private var userIsJobSeeker: Bool {
        authManager.currentUser?.isJobSeeker ?? false
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: Top Row — Category + Price
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    // Category badge
                    if service.category != nil {
                        HStack(spacing: 4) {
                            Image(systemName: "tag.fill")
                                .font(.caption2)
                            Text(service.categoryDisplayName)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accent.opacity(0.12))
                        .cornerRadius(6)
                    }

                    // Title
                    Text(service.title)
                        .font(.headline)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .lineLimit(2)

                    // Provider name
                    if let name = service.providerName {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.caption2)
                            Text(name)
                                .font(.caption)
                        }
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    // Price
                    Text(service.formattedPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.green)

                    // Application badge for own services
                    if isOwnService && service.applicationCount > 0 {
                        ApplicationBadge(count: service.applicationCount, size: .small)
                    }
                }
            }

            Divider()

            // MARK: Bottom Row — Location + Date
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                    Text(service.location.name)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                if let date = service.serviceDate {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(date.formatted(.dateTime.day().month(.abbreviated)))
                            .font(.caption)
                            .fontDesign(.monospaced)
                    }
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
            }

            // MARK: Description snippet
            if !service.description.isEmpty {
                Text(service.description)
                    .font(.caption)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .lineLimit(2)
            }
        }
        .padding(14)
        .background(Colors.swiftUIColor(.surfaceWhite))
        .cornerRadius(14)
    }

    var body: some View {
        if #available(iOS 26, *) {
            if userIsJobSeeker {
                NavigationLink(value: JobSeekerDestination.serviceDetail(service)) {
                    cardContent
                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 14))
                }
            } else {
                NavigationLink(value: ServiceProviderDestination.serviceDetail(service)) {
                    cardContent
                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 14))
                }
            }
        } else {
            Button(action: navigateToDetail) {
                cardContent
            }
            .buttonStyle(.plain)
        }
    }

    private func navigateToDetail() {
        if let coordinator = appCoordinator.providerCoordinator {
            coordinator.navigate(to: .serviceDetail(service))
        } else if let coordinator = appCoordinator.studentCoordinator {
            coordinator.navigate(to: .serviceDetail(service))
        }
    }
}
