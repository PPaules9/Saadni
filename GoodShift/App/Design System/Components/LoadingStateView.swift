//
//  LoadingStateView.swift
//  GoodShift
//

import SwiftUI

/// A reusable loading indicator with an optional message.
/// Use this instead of inline ProgressView + Text blocks across the app.
struct LoadingStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .tint(.accent)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
}

#Preview {
    LoadingStateView(message: "Loading your jobs...")
}
