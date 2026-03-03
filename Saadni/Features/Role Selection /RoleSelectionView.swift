//
//  RoleSelectionView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct RoleSelectionView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(AppStateManager.self) var appStateManager
    @State private var isUpdating = false
    @State private var showError = false
    @State private var errorMessage = ""

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

                    Text("Choose how you want to use Saadni")
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
                        subtitle: "Find services and hire professionals",
                        iconColor: .blue
                    ) {
                        selectRole(isJobSeeker: true)
                    }

                    RoleOptionCard(
                        icon: "briefcase.circle.fill",
                        title: "Need work and earn some cash",
                        subtitle: "Offer your skills and get hired",
                        iconColor: .green
                    ) {
                        selectRole(isJobSeeker: false)
                    }
                }

                Spacer()
            }
            .padding(24)
            .disabled(isUpdating)

            if isUpdating {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.accent)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func selectRole(isJobSeeker: Bool) {
        guard let currentUser = authManager.currentUser else { return }

        isUpdating = true

        Task {
            do {
                // Create updated user with role selection
                var updatedUser = currentUser
                updatedUser.isJobSeeker = isJobSeeker
                updatedUser.isServiceProvider = !isJobSeeker

                // Save to Firestore
                try await FirestoreService.shared.saveUser(updatedUser)

                // Update local auth state and complete role selection
                await MainActor.run {
                    authManager.authState = .authenticated(updatedUser)
                    appStateManager.completeRoleSelection()
                    isUpdating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isUpdating = false
                }
            }
        }
    }
}

struct RoleOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(iconColor)
                    .frame(width: 60, height: 60)
                    .background(iconColor.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .multilineTextAlignment(.leading)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.accent)
            }
            .padding(20)
            .background(Colors.swiftUIColor(.appBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RoleSelectionView()
        .environment(AuthenticationManager())
        .environment(AppStateManager())
}
