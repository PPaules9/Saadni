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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
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
                
                // Job Title
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Job Title")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(
                        hasTitle: false,
                        title: "",
                        placeholder: "e.g., Barista Shift",
                        text: $viewModel.jobName
                    )
                }
                
                // Dates Selection
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Select Shift Date(s)")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    MultiDatePicker("Dates", selection: $viewModel.selectedDates, in: Date()...)
                        .padding()
                        .background(Colors.swiftUIColor(.textPrimary))
                        .cornerRadius(12)
                }

                // Times
                VStack(alignment: .leading, spacing: 8) {
                    Text("Shift Timing")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    
                    HStack {
                        DatePicker("Start", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        Spacer()
                        Text("to")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Spacer()
                        DatePicker("End", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    .background(Colors.swiftUIColor(.textPrimary))
                    .cornerRadius(12)
                }
                
                // Break Duration & Workers
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Break (Optional)")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        BrandTextField(
                            hasTitle: false,
                            title: "",
                            placeholder: "e.g. 30 mins",
                            text: $viewModel.breakDuration
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Text("Workers Needed")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Text("*").foregroundStyle(.red)
                        }
                        BrandTextField(
                            hasTitle: false,
                            title: "",
                            placeholder: "1",
                            text: $viewModel.numberOfWorkersNeeded
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab1(
        viewModel: CreateJobViewModel(),
        selectedCategory: "Food & Beverage"
    )
}
