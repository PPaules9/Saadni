//
//  ApplicantCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 28/03/2026.
//

import SwiftUI

struct ApplicantCard: View {
    let application: JobApplication
    let service: JobService
    let applicant: User?

    var body: some View {
        HStack(spacing: 12) {
            // Applicant Info Column
            VStack(alignment: .leading, spacing: 8) {
                // Photo + Name
                HStack(spacing: 12) {
                    if let photoURL = applicant?.photoURL, let url = URL(string: photoURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 50)
                            .overlay(Text("👤").font(.system(size: 20)))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(applicant?.displayName ?? "Applicant")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        // Rating
                        if let rating = applicant?.rating {
                            HStack(spacing: 2) {
                                ForEach(0..<5, id: \.self) { index in
                                    Image(systemName: index < Int(rating) ? "star.fill" : "star")
                                        .font(.system(size: 10))
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }

                // Age • Gender
                if let age = applicant?.age, let gender = applicant?.gender {
                    HStack(spacing: 4) {
                        Text("\(age)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(genderDisplay(gender))
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }

                // Status Badge
                applicationStatusBadge
            }

            Spacer()

            // Service Image
            if let imageURL = service.image.remoteURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                }
                placeholder: {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                }
            } else if let localImage = service.image.localImage {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(Text("🖼️").font(.system(size: 24)))
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    var applicationStatusBadge: some View {
        let statusText: String
        let statusColor: Color

        switch application.status {
        case .pending:
            statusText = "Pending"
            statusColor = Color(.systemOrange)
        case .accepted:
            statusText = "Accepted"
            statusColor = Color(.systemGreen)
        case .rejected:
            statusText = "Rejected"
            statusColor = Color(.systemRed)
        case .withdrawn:
            statusText = "Withdrawn"
            statusColor = Color(.systemGray)
        case .completed:
            statusText = "Completed"
            statusColor = Color(.systemPurple)
        }

        return Text(statusText)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(6)
    }

    private func genderDisplay(_ gender: String) -> String {
        switch gender {
        case "male":
            return "Male"
        case "female":
            return "Female"
        case "prefer_not_to_say":
            return "Other"
        default:
            return gender
        }
    }
}

#Preview {
    let mockApplication = JobApplication(
        id: "app-1",
        serviceId: "service-1",
        providerId: "provider-1",
        applicantId: "user-1",
        applicantName: "John Doe",
        applicantPhotoURL: nil,
        status: .pending,
        appliedAt: Date(),
        coverMessage: "I'm interested in this job",
        proposedPrice: nil,
        responseMessage: nil,
        respondedAt: nil
    )

    let mockService = JobService(
        id: "service-1",
        title: "House Cleaning",
        price: 500,
        location: ServiceLocation(name: "Cairo", latitude: 30.0444, longitude: 31.2357),
        description: "Professional cleaning service",
        image: ServiceImage(),
        createdAt: Date(),
        providerId: "provider-1",
        providerName: "Ali's Services",
        providerImageURL: nil,
        status: .published,
        isFeatured: false,
        category: .cleaningAndMaintenance
    )

    let mockUser = User(
        id: "user-1",
        email: "john@example.com",
        displayName: "John Doe",
        age: 28,
        gender: "male",
        rating: 4.5,
        totalReviews: 12,
        createdAt: Date(),
        lastLoginAt: Date()
    )

    ApplicantCard(
        application: mockApplication,
        service: mockService,
        applicant: mockUser
    )
}
