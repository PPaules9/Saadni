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
                        // Resize to max 1024px before storing — modern iPhone photos can be
                        // 12MB+ which causes memory spikes before compression later in the upload flow.
                        let resized = uiImage.resizedToMaxDimension(1024)
                        await MainActor.run {
                            selectedImage = resized
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

// MARK: - UIImage Resize Helper

extension UIImage {
    /// Scales the image down so its longest side is at most `maxDimension` points.
    /// If the image is already smaller, it is returned unchanged.
    func resizedToMaxDimension(_ maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        guard longestSide > maxDimension else { return self }
        let scale = maxDimension / longestSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
