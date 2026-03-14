//
//  JobPublishedSuccessModal.swift
//  Saadni
//
//  Created by Claude on 14/03/2026.
//

import SwiftUI

struct JobPublishedSuccessModal: View {
    let jobTitle: String
    let jobPrice: String
    let jobImage: UIImage?
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Semi-transparent background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // Content card
            VStack(spacing: 24) {
                // Success checkmark icon
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.green)

                // Job preview section
                VStack(spacing: 12) {
                    if let image = jobImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Text(jobTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.label))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Text(jobPrice)
                        .font(.headline)
                        .foregroundStyle(.green)
                }

                // Success message
                Text("Your job has been published!")
                    .font(.headline)
                    .foregroundStyle(Color(UIColor.label))

                // Cool button
                BrandButton("Cool", hasIcon: false, icon: "", secondary: false) {
                    onComplete()
                }
                .frame(width: 200)
            }
            .padding(32)
            .background(Colors.swiftUIColor(.textPrimary))
            .cornerRadius(20)
            .padding()
        }
    }
}

#Preview {
    JobPublishedSuccessModal(
        jobTitle: "Professional House Cleaning",
        jobPrice: "EGP 500",
        jobImage: nil,
        onComplete: {}
    )
}
