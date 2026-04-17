//
//  RoleSwitcherView.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct RoleSwitcherView: View {
    let currentRoleLabel: String
    let currentRoleIcon: String
    let isAnimating: Bool
    let isSwitching: Bool
    let onSwitch: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("User Type")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .padding(.horizontal, 20)

            Button(action: onSwitch) {
                HStack(spacing: 12) {
                    Image(systemName: currentRoleIcon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.accent)
                        .frame(width: 24)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Role")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text(currentRoleLabel)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                    }

                    Spacer()

                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.accent)
                        .scaleEffect(isAnimating ? 0.8 : 1.0)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Colors.swiftUIColor(.appBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.2), lineWidth: 1)
                )
            }
            .disabled(isSwitching)
            .opacity(isSwitching ? 0.6 : 1.0)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    RoleSwitcherView(
        currentRoleLabel: "Earn Some Cash",
        currentRoleIcon: "briefcase.circle.fill",
        isAnimating: false,
        isSwitching: false,
        onSwitch: {}
    )
}
