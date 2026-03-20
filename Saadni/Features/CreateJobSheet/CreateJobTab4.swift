//
//  CreateJobTab4.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab4: View {
    @Bindable var viewModel: CreateJobViewModel
    
    let genderOptions = ["Any", "Male Only", "Female Only"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Text("All fields here are optional. Provide details if your shift requires them.")
                    .font(.caption)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Dress Code
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dress Code")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Black t-shirt & dark jeans", text: $viewModel.dressCode)
                }

                // Min Age
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minimum Age")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., 18", text: $viewModel.minimumAge)
                }

                // Gender
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gender Preference")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    HStack {
                        ForEach(genderOptions, id: \.self) { gender in
                            Button(action: { viewModel.genderPreference = gender }) {
                                Text(gender)
                                    .font(.caption)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewModel.genderPreference == gender ? Color.accent : Colors.swiftUIColor(.textPrimary))
                                    .foregroundStyle(viewModel.genderPreference == gender ? .white : Colors.swiftUIColor(.textMain))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                // Physical reqs
                VStack(alignment: .leading, spacing: 8) {
                    Text("Physical Requirements")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Ability to lift 10kg", text: $viewModel.physicalRequirements)
                }

                // Language
                VStack(alignment: .leading, spacing: 8) {
                    Text("Language Needed")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., English, Arabic", text: $viewModel.languageNeeded)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab4(viewModel: CreateJobViewModel())
}
