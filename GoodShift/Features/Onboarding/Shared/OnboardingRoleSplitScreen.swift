//
//  OnboardingRoleSplitScreen.swift
//  GoodShift
//

import SwiftUI

struct OnboardingRoleSplitScreen: View {
    let onSelect: (OnboardingRole) -> Void

    private func select(_ role: OnboardingRole) {
        let roleName = role == .jobSeeker ? "job_seeker" : "provider"
        AnalyticsService.shared.track(.onboardingRoleSelected(role: roleName))
        onSelect(role)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Text("What brings you\nto GoodShift?")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)

                Text("We'll set things up for you.")
                    .font(.system(size: 16))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 48)

            // Role cards — tapping immediately navigates
            VStack(spacing: 16) {
                RoleCard(
                    icon: "briefcase.fill",
                    title: "I'm looking for work",
                    subtitle: "Browse shifts and earn money on your schedule",
                    accentColor: Color.accentColor
                ) {
                    select(.jobSeeker)
                }

                RoleCard(
                    icon: "building.2.fill",
                    title: "I'm looking to hire",
                    subtitle: "Post shifts and find reliable staff fast",
                    accentColor: Colors.swiftUIColor(.primaryDark)
                ) {
                    select(.provider)
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

// MARK: - Role Card

private struct RoleCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.swiftUIColor(.cardBackground))
                    .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = true } }
                .onEnded   { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = false } }
        )
    }
}

#Preview {
    OnboardingRoleSplitScreen { _ in }
        .background(Colors.swiftUIColor(.appBackground))
}
