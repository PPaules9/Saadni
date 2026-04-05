//
//  RoleSelectionView.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

private struct RoleChoice: Identifiable {
    let isJobSeeker: Bool
    var id: Bool { isJobSeeker }
}

struct RoleSelectionView: View {
    let user: User
    @State private var roleChoice: RoleChoice? = nil

    var body: some View {
        ZStack {
            Color(Colors.swiftUIColor(.appBackground))
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(.accent)

                    Text("What brings you here?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text("Choose how you want to use \(AppInfo.name)")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)

                Spacer()

                // Role options
                VStack(spacing: 16) {
                    RoleOptionCard(
                        icon: "magnifyingglass.circle.fill",
                        title: "Need help with something",
                        iconColor: .accent
                    ) {
                        roleChoice = RoleChoice(isJobSeeker: true)
                    }

                    RoleOptionCard(
                        icon: "briefcase.circle.fill",
                        title: "Need work and earn some cash",
                        iconColor: .accent
                    ) {
                        roleChoice = RoleChoice(isJobSeeker: false)
                    }
                }

                Spacer()
            }
            .padding(24)
        }
        .fullScreenCover(item: $roleChoice) { choice in
            ProfileSetupView(user: user, isJobSeeker: choice.isJobSeeker)
        }
    }
}
