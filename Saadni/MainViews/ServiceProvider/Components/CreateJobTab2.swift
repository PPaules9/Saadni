//
//  CreateJobTab2.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab2: View {
    @Bindable var viewModel: CreateJobViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Picture Section
                VStack(spacing: 12) {
                    Text("Post a Picture (if any)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Colors.swiftUIColor(.textPrimary))

                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                          .resizable()
                          .scaledToFill()
                          .frame(maxWidth: .infinity, maxHeight: 200)
                          .clipped()
                          .clipShape(RoundedRectangle(cornerRadius: 24))
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                Text("Tap to add a photo")
                                    .font(.subheadline)
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            }
                        }
                    }
                    .frame(height: 200)
                    .onTapGesture {
                        viewModel.showImagePicker = true
                    }
                }

                Divider()

                // Around Section
                VStack(spacing: 12) {
                    Text("Will there be someone around?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 8) {
                        ForEach(AroundOption.allCases, id: \.self) { option in
                            Button(action: { viewModel.aroundOption = option }) {
                                HStack {
                                    Image(systemName: viewModel.aroundOption == option ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(viewModel.aroundOption == option ? Color.accent : Color.gray)

                                    Text(option.rawValue)
                                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                                    Spacer()
                                }
                                .padding(12)
                                .background(viewModel.aroundOption == option ? Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                                .cornerRadius(12)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab2(viewModel: CreateJobViewModel())
}
