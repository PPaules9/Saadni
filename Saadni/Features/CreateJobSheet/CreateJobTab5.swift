//
//  CreateJobTab5.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct CreateJobTab5: View {
    @Bindable var viewModel: CreateJobViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // When Section
                VStack(spacing: 12) {
                    Text("When do you need this done?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 8) {
                        ForEach(ServiceTimeline.allCases, id: \.self) { option in
                            Button(action: { viewModel.serviceTimeline = option }) {
                                HStack {
                                    Image(systemName: viewModel.serviceTimeline == option ?
                                        "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(viewModel.serviceTimeline == option ?
                                            Color.accent : Color.gray)

                                    Text(option.rawValue)
                                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                                    Spacer()
                                }
                                .padding(12)
                                .background(viewModel.serviceTimeline == option ?
                                    Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                                .cornerRadius(12)
                            }
                        }
                    }

                    // Specific Date Picker (conditional)
                    if viewModel.serviceTimeline == .specificDate {
                        VStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Text("Select Date")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("*")
                                    .foregroundStyle(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            DatePicker(
                                "Service Date",
                                selection: $viewModel.specificDate,
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                            .padding(12)
                            .background(Colors.swiftUIColor(.textPrimary))
                            .cornerRadius(12)
                        }
                        .transition(.opacity)
                    }
                }

                Divider()

                // Duration Section
                VStack(spacing: 12) {
                    Text("How long will this service take?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 8) {
                        ForEach(DurationOption.allCases, id: \.self) { option in
                            Button(action: { viewModel.durationOption = option }) {
                                HStack {
                                    Image(systemName: viewModel.durationOption == option ?
                                        "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(viewModel.durationOption == option ?
                                            Color.accent : Color.gray)

                                    Text(option.rawValue)
                                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                                    Spacer()
                                }
                                .padding(12)
                                .background(viewModel.durationOption == option ?
                                    Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                                .cornerRadius(12)
                            }
                        }
                    }

                    // Custom Duration Input (conditional)
                    if viewModel.durationOption == .custom {
                        VStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Text("Enter hours")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("*")
                                    .foregroundStyle(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            BrandTextField(
                                hasTitle: false,
                                title: "",
                                placeholder: "e.g., 2.5",
                                text: $viewModel.customDurationHours
                            )
                            .keyboardType(.decimalPad)
                        }
                        .transition(.opacity)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab5(viewModel: CreateJobViewModel())
}
