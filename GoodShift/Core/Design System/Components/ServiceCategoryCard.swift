//
//  ServiceCategoryCard.swift
//  GoodShift
//
//  A horizontal card displaying a service category with an image from assets
//  The service name is positioned at bottom-right with a dark gradient overlay
//

import SwiftUI

struct ServiceCategoryCard: View {
    let serviceName: String
    let imageAssetName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Background Image
                Image(imageAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

                // Dark Gradient Overlay at bottom
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.4),
                        Color.black.opacity(0)
                    ]),
                    startPoint: .bottom,
                    endPoint: .center
                )

                // Service Name at bottom-right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(serviceName)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .padding(12)
                    }
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ServiceCategoryCard(
        serviceName: "Home Cleaning",
        imageAssetName: "homeCleaning"
    ) {
        print("Tapped")
    }
    .padding()
}
