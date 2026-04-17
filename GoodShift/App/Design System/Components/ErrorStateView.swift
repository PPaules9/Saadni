//
//  ErrorStateView.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/03/2026.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: (() async -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)
                .accessibilityHidden(true)

            Text(message)
                .font(.headline)
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let retryAction = retryAction {
                Button(action: {
                    Task { await retryAction() }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Retry")
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Colors.swiftUIColor(.primary))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(
        message: "Failed to load services. Please check your connection.",
        retryAction: {
            print("Retry tapped")
        }
    )
}
