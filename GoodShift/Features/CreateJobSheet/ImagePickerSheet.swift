//
//  ImagePickerSheet.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI
import PhotosUI

struct ImagePickerSheet: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Choose Photo")
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
            }
            .padding()

            PhotosPicker(
                selection: $photosPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                VStack(spacing: 12) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.accent)

                    Text("Select from Library")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .onChange(of: photosPickerItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            selectedImage = uiImage
                            dismiss()
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
    }
}

#Preview {
    ImagePickerSheet(selectedImage: .constant(nil))
}
