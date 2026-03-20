//
//  CreateJobTab5.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab5: View {
    @Bindable var viewModel: CreateJobViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("What will the worker do? (Optional)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Briefly describe the tasks...", text: $viewModel.otherDetails, axis: .vertical)
                        .lineLimit(4...8)
                        .padding()
                        .background(Colors.swiftUIColor(.textPrimary))
                        .cornerRadius(12)
                }
                
                // What to bring
                VStack(alignment: .leading, spacing: 8) {
                    Text("What to bring? (Optional)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Your own apron, clear criminal record...", text: $viewModel.whatToBring)
                }

                // Picture (moved here from previous picture tab!)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cover Photo (Optional)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.selectedImage != nil ? Colors.swiftUIColor(.textPrimary) : Colors.swiftUIColor(.textPrimary))
                            .strokeBorder(Color.clear, lineWidth: 2)

                        if let image = viewModel.selectedImage {
                            VStack(alignment: .trailing) {
                                HStack {
                                    Spacer()
                                    Button(action: { viewModel.selectedImage = nil }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundStyle(.gray)
                                            .padding(8)
                                    }
                                }
                                Spacer()
                                Image(uiImage: image)
                                  .resizable()
                                  .scaledToFill()
                                  .frame(maxWidth: .infinity, maxHeight: 160)
                                  .clipped()
                            }
                        } else {
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                Text("Tap to add a photo")
                                    .font(.caption)
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            }
                        }
                    }
                    .frame(height: 160)
                    .onTapGesture {
                        if viewModel.selectedImage == nil {
                            viewModel.showImagePicker = true
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
    CreateJobTab5(viewModel: CreateJobViewModel())
}
