//
//  TypingIndicatorView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 4) {
            // Three animated dots
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Colors.swiftUIColor(.textSecondary))
                    .frame(width: 8, height: 8)
                    .offset(y: isAnimating ? -6 : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .padding(12)
        .background(Colors.swiftUIColor(.surfaceWhite))
        .cornerRadius(16)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        Text("Typing Indicator Animation")
            .font(.headline)
            .padding()

        TypingIndicatorView()
            .frame(width: 60)

        Spacer()
    }
    .padding()
    .background(Colors.swiftUIColor(.appBackground))
}
