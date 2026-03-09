//
//  CreateJobTab1.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab1: View {
    @Bindable var viewModel: CreateJobViewModel
    let selectedCategory: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Category Display
                HStack {
                    Text("Service Category")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    Spacer()
                    Text(selectedCategory)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                }
                .padding()
                .background(Colors.swiftUIColor(.textPrimary))
                .cornerRadius(12)

                // Job Name
                BrandTextField(
                    hasTitle: true,
                    title: "Give it a name?",
                    placeholder: "e.g., Mount my 55-inch TV",
                    text: $viewModel.jobName
                )

                // Location Header
                Text("What is the Service Location?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Address Fields
                BrandTextField(
                    hasTitle: true,
                    title: "Address",
                    placeholder: "Street address",
                    text: $viewModel.address
                )

                HStack(spacing: 12) {
                    BrandTextField(
                        hasTitle: true,
                        title: "Floor",
                        placeholder: "Floor",
                        text: $viewModel.floor
                    )
                    .frame(maxWidth: .infinity)

                    BrandTextField(
                        hasTitle: true,
                        title: "Unit",
                        placeholder: "Unit",
                        text: $viewModel.unit
                    )
                    .frame(maxWidth: .infinity)
                }

                BrandTextField(
                    hasTitle: true,
                    title: "City",
                    placeholder: "City",
                    text: $viewModel.city
                )

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab1(
        viewModel: CreateJobViewModel(),
        selectedCategory: "TV Mounting"
    )
}
