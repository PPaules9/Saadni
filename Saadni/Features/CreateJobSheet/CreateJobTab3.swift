//
//  CreateJobTab3.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab3: View {
    @Bindable var viewModel: CreateJobViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Does this job need any special tools?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 8) {
                    ForEach(ToolsNeeded.allCases, id: \.self) { option in
                        Button(action: { viewModel.toolsNeeded = option }) {
                            HStack {
                                Image(systemName: viewModel.toolsNeeded == option ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(viewModel.toolsNeeded == option ? Color.accent : Color.gray)

                                Text(option.rawValue)
                                    .foregroundStyle(Colors.swiftUIColor(.textMain))

                                Spacer()
                            }
                            .padding(12)
                            .background(viewModel.toolsNeeded == option ? Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                            .cornerRadius(12)
                        }
                    }
                }

                if viewModel.toolsNeeded == .yes {
                    VStack(spacing: 8) {
                        Text("State the tools needed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        BrandTextEditor(
                            hasTitle: false,
                            title: "Tools",
                            placeholder: "List all tools needed for this job...",
                            text: $viewModel.toolsDescription
                        )
                    }
                    .transition(.opacity)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab3(viewModel: CreateJobViewModel())
}
