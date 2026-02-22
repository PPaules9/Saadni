//
//  ServiceCard.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ServiceCard: View {
    let service: Service
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            Group {
                if service.isSystemImage {
                    ZStack {
                        Color(.systemGray6)
                        Image(systemName: service.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(40)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                } else {
                    Image(service.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            
            // Overlay Gradient
            LinearGradient(
                colors: [.black.opacity(0.8), .transparent],
                startPoint: .bottom,
                endPoint: .center
            )
            
            // Content
            HStack(alignment: .bottom) {
                Text(service.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(service.price)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

extension Color {
    static let transparent = Color.black.opacity(0)
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            ServiceCard(service: Service.mocks[0])
                .padding()
        }
    }
}
