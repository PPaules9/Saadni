//
//  AppliedServiceCard.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct AppliedServiceCard: View {
    let service: JobService
    let application: JobApplication

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and status
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.headline)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .lineLimit(2)

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

                ApplicationStatusBadge(status: application.status)
            }

            Divider()

            // Details row
            HStack(spacing: 16) {
                // Category
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

                Spacer()

                // Price
                Text(service.formattedPrice)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.green)
            }

            HStack(spacing: 16) {
                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                    Text(service.location.name)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                Spacer()

                // Applied date
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(formatDate(application.appliedAt))
                        .font(.caption)
                }
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }

            // Cover message if available
            if let message = application.coverMessage, !message.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Divider()

                    HStack(spacing: 4) {
                        Image(systemName: "text.quote")
                            .font(.caption2)
                            .foregroundStyle(.accent)
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .lineLimit(2)
                    }
                }
            }
        }
        .padding()
        .background(Colors.swiftUIColor(.surfaceWhite))
        .cornerRadius(14)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    AppliedServiceCard(
        service: JobService.sampleData[0],
        application: JobApplication(
            serviceId: "service-1",
            providerId: "provider-1",
            applicantId: "user-1",
            applicantName: "John Doe",
            applicantPhotoURL: nil,
            coverMessage: "I'm interested in this job!"
        )
    )
}
