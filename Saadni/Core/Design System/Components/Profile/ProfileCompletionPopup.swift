//
//  ProfileCompletionPopup.swift
//  Saadni
//
//  Created by Pavly Paules on 28/03/2026.
//

import SwiftUI

struct ProfileCompletionPopup: View {
    let completionPercentage: Int
    let onComplete: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 8)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: CGFloat(completionPercentage) / 100)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    Text("\(completionPercentage)%")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)
                }

                VStack(spacing: 8) {
                    Text("Complete Your Profile to Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Fill in your profile details to post jobs or apply")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 12) {
                Button(action: onComplete) {
                    Text("Complete Profile")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }

                Button(action: onDismiss) {
                    Text("Maybe Later")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
            }

            Spacer()
        }
        .padding(32)
        .background(Colors.swiftUIColor(.appBackground))
        .presentationDetents([.medium])
    }
}

#Preview {
    ProfileCompletionPopup(
        completionPercentage: 66,
        onComplete: {},
        onDismiss: {}
    )
}
