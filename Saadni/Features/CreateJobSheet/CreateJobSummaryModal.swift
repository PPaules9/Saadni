//
//  CreateJobSummaryModal.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct CreateJobSummaryModal: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: CreateJobViewModel
    let onPublish: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Review Your Job")
                    .font(.headline)
                    .fontWeight(.semibold)

                Text("Please review all details before publishing")
                    .font(.caption)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Colors.swiftUIColor(.textPrimary))

            // Summary Content
            ScrollView {
                VStack(spacing: 16) {
                    // Job Image
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .cornerRadius(12)
                            .clipped()
                    }

                    // Summary Sections
                    SummarySection(title: "Job Details") {
                        SummaryRow(label: "Job Name", value: viewModel.jobName)
                        SummaryRow(label: "Category", value: viewModel.jobName)
                        SummaryRow(label: "Description", value: viewModel.otherDetails.isEmpty ? "No description" : viewModel.otherDetails)
                    }

                    SummarySection(title: "Location") {
                        SummaryRow(label: "City", value: viewModel.city)
                        SummaryRow(label: "Address", value: viewModel.address)
                        if !viewModel.floor.isEmpty {
                            SummaryRow(label: "Floor", value: viewModel.floor)
                        }
                        if !viewModel.unit.isEmpty {
                            SummaryRow(label: "Unit", value: viewModel.unit)
                        }
                    }

                    SummarySection(title: "Budget & Timeline") {
                        SummaryRow(label: "Budget", value: "\(viewModel.price) EGP")
                        SummaryRow(label: "Timeline", value: viewModel.serviceTimeline.rawValue)
                        if viewModel.serviceTimeline == .specificDate {
                            SummaryRow(label: "Date", value: viewModel.specificDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        SummaryRow(label: "Duration", value: viewModel.durationOption.rawValue)
                    }

                    SummarySection(title: "Requirements") {
                        SummaryRow(label: "Someone Around", value: viewModel.aroundOption.rawValue)
                        SummaryRow(label: "Tools Needed", value: viewModel.toolsNeeded.rawValue)
                        if viewModel.toolsNeeded == .yes && !viewModel.toolsDescription.isEmpty {
                            SummaryRow(label: "Tools Description", value: viewModel.toolsDescription)
                        }
                    }
                }
                .padding()
            }

            // Progress UI during upload
            if case .compressing = viewModel.uploadState {
                VStack(spacing: 8) {
                    ProgressView()
                        .tint(.accent)
                    Text("Compressing image...")
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accent.opacity(0.1))
                .cornerRadius(8)
                .padding()
            } else if case .uploading(let progress) = viewModel.uploadState {
                VStack(spacing: 8) {
                    ProgressView(value: progress)
                        .tint(.accent)
                    Text("Uploading image... \(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accent.opacity(0.1))
                .cornerRadius(8)
                .padding()
            } else if case .saving = viewModel.uploadState {
                VStack(spacing: 8) {
                    ProgressView()
                        .tint(.accent)
                    Text("Saving job details...")
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accent.opacity(0.1))
                .cornerRadius(8)
                .padding()
            }

            // Action Buttons
            HStack(spacing: 12) {
                BrandButton(
                    "Cancel",
                    isDisabled: viewModel.isPublishing,
                    hasIcon: false,
                    icon: "",
                    secondary: true
                ) {
                    dismiss()
                }

                BrandButton(
                    viewModel.isPublishing ? "Publishing..." : "Publish",
                    isDisabled: viewModel.isPublishing,
                    hasIcon: true,
                    icon: "paperplane.fill",
                    secondary: false
                ) {
                    onPublish()
                }
            }
            .padding()
            .background(Colors.swiftUIColor(.textPrimary))
        }
        .background(Colors.swiftUIColor(.appBackground))
    }
}

// MARK: - Helper Components

struct SummarySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accent)

            VStack(alignment: .leading, spacing: 0) {
                content
            }
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Colors.swiftUIColor(.appBackground))
        .cornerRadius(8)
    }
}

#Preview {
    CreateJobSummaryModal(viewModel: CreateJobViewModel(), onPublish: {})
}
