//
//  CreateJobTab5.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab5: View {
    @Bindable var viewModel: CreateJobViewModel
    let onPublish: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Any other details you want to add?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                BrandTextEditor(
                    hasTitle: true,
                    title: "Additional Details",
                    placeholder: "Share any additional information about the job...",
                    text: $viewModel.otherDetails
                )

                // Summary
                VStack(spacing: 12) {
                    Divider()

                    VStack(spacing: 8) {
                        HStack {
                            Text("Job Name:")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Spacer()
                            Text(viewModel.jobName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }

                        HStack {
                            Text("Location:")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Spacer()
                            Text(viewModel.city)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }

                        HStack {
                            Text("Budget:")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Spacer()
                            Text("\(viewModel.price) EGP")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(12)
                    .background(Colors.swiftUIColor(.textPrimary))
                    .cornerRadius(12)
                }

                VStack(spacing: 12) {
                    BrandButton(
                        "Publish the Job",
                        hasIcon: true,
                        icon: "paperplane.fill",
                        secondary: false
                    ) {
                        onPublish()
                    }
                    .disabled(!viewModel.canPublish())
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab5(viewModel: CreateJobViewModel(), onPublish: {})
}
