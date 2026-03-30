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
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    if let name = service.providerName {
                        Text(name)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }

                Spacer()

                ApplicationStatusBadge(status: application.status)
            }

            Divider()
                .background(Color.gray.opacity(0.3))

            // Details row
            HStack(spacing: 16) {
                // Price
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(service.formattedPrice)
                        .font(.headline)
                        .foregroundStyle(.green)
                }

                Spacer()

                // Applied date
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Applied")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(formatDate(application.appliedAt))
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }

            // Cover message if available
            if let message = application.coverMessage, !message.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Divider()
                        .background(Color.gray.opacity(0.3))

                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                }
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
