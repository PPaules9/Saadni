//
//  CreateJobTab4.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab4: View {
    @Bindable var viewModel: CreateJobViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("How much are you willing to pay for this job?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    Text("Price")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    Text("*")
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    BrandTextField(
                        hasTitle: false,
                        title: "",
                        placeholder: "Enter amount",
                        text: $viewModel.price
                    )
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity)

                    VStack {
                        Text("")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text("EGP")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                    }
                    .frame(width: 60)
                }

                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(Color.accent)
                            .font(.subheadline)

                        Text("This is the maximum amount you're willing to pay for this service")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                    .padding(12)
                    .background(Color.accent.opacity(0.1))
                    .cornerRadius(12)
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
