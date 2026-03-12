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
    @State private var showTagPicker = false
    @State private var showOtherInput = false
    @State private var customTag = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Category Display - Tap to open menu picker
                HStack {
                    Text("Service Category")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    Spacer()
                    Button(action: { showTagPicker = true }) {
                        HStack(spacing: 8) {
                            Text(selectedCategory)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accent)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundStyle(Color.accent)
                        }
                    }
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
        .sheet(isPresented: $showTagPicker) {
            VStack(spacing: 16) {
                HStack {
                    Text("Link Related Services")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                    Spacer()
                    Button(action: { showTagPicker = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                }
                .padding()
                .background(Colors.swiftUIColor(.appBackground))

                ScrollView {
                    VStack(spacing: 10) {
                        // Available categories
                        ForEach(getAllCategories(), id: \.self) { category in
                            Button(action: {
                                if viewModel.selectedCategoryTags.contains(category) {
                                    viewModel.selectedCategoryTags.remove(category)
                                } else {
                                    viewModel.selectedCategoryTags.insert(category)
                                }
                            }) {
                                HStack {
                                    Image(systemName: viewModel.selectedCategoryTags.contains(category) ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(Color.accent)
                                        .font(.system(size: 18))

                                    Text(category)
                                        .font(.subheadline)
                                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                                    Spacer()
                                }
                                .padding(12)
                                .background(Colors.swiftUIColor(.textPrimary))
                                .cornerRadius(10)
                            }
                        }

                        Divider()
                            .padding(.vertical, 8)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.5))

                        // Other option
                        Button(action: { showOtherInput = true }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(Color.accent)
                                    .font(.system(size: 18))

                                Text("Add Custom Category")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.accent)

                                Spacer()
                            }
                            .padding(12)
                            .background(Colors.swiftUIColor(.textPrimary))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                Spacer()

                Button(action: { showTagPicker = false }) {
                    Text("Done")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.accent)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Colors.swiftUIColor(.appBackground))
            .presentationDetents([.fraction(0.7)])
            .presentationDragIndicator(.visible)
        }
        .alert("Add Custom Category", isPresented: $showOtherInput) {
            TextField("Enter service category", text: $customTag)
            Button("Add") {
                if !customTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.selectedCategoryTags.insert(customTag)
                    customTag = ""
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func getAllCategories() -> [String] {
        return ServiceCategoryType.allCases
            .map { $0.rawValue }
            .filter { $0 != selectedCategory }
            .sorted()
    }
}

#Preview {
    CreateJobTab1(
        viewModel: CreateJobViewModel(),
        selectedCategory: "TV Mounting"
    )
}
