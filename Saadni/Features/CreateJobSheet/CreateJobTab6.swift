//
//  CreateJobTab6.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab6: View {
    @Bindable var viewModel: CreateJobViewModel
    var onPublish: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Text("Your Company Information")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("This information will be associated with your shift postings to help students verify employers.")
                    .font(.caption)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Company Name
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Company/Brand Name")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., McDonald's, Zara", text: $viewModel.companyName)
                }

                // Industry
                VStack(alignment: .leading, spacing: 8) {
                    Text("Industry Category (Optional)")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Fast Food, Retail", text: $viewModel.industryCategory)
                }

                // Contact Name
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Contact Person Name")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "Name", text: $viewModel.contactPersonName)
                }

                // Contact Phone
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Contact Phone")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "Phone Number", text: $viewModel.contactPersonPhone)
                }

                Button(action: {
                    if viewModel.isTab6Valid {
                        viewModel.showValidationError = false
                        onPublish()
                    } else {
                        viewModel.showValidationError = true
                    }
                }) {
                    Text("Review Shift(s)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accent)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 16)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab6(viewModel: CreateJobViewModel(), onPublish: {})
}
