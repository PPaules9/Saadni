//
//  ServiceCardSkeleton.swift
//  GoodShift
//

import SwiftUI

/// Shimmer placeholder matching the dimensions of ServiceCard.
/// Used while services are loading from Firestore.
struct ServiceCardSkeleton: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background block
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray5))
                .frame(height: 190)

            // Shimmer sweep
            RoundedRectangle(cornerRadius: 15)
                .fill(shimmerGradient)
                .frame(height: 190)

            // Bottom text placeholders
            VStack(alignment: .leading, spacing: 8) {
                // Title placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(width: 140, height: 14)
                // Price placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(width: 70, height: 14)
            }
            .padding(14)

            // Top row placeholder (date + location)
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray4))
                        .frame(width: 80, height: 10)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray4))
                        .frame(width: 60, height: 10)
                }
                .padding(14)
                Spacer()
            }
        }
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1
            }
        }
    }

    private var shimmerGradient: LinearGradient {
        let lower = min(phase - 0.3, phase, phase + 0.3)
        let middle = phase
        let upper = max(phase - 0.3, phase, phase + 0.3)
        let stops = [
            Gradient.Stop(color: .clear, location: lower),
            Gradient.Stop(color: Color.white.opacity(0.25), location: middle),
            Gradient.Stop(color: .clear, location: upper)
        ].sorted { $0.location < $1.location }
        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { _ in
                ServiceCardSkeleton()
                    .frame(width: 300)
            }
        }
        .padding(.horizontal)
    }
    .padding(.vertical)
}
