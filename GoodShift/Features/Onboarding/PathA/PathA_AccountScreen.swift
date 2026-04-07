//
//  PathA_AccountScreen.swift
//  GoodShift
//
//  Final onboarding screen — create account to save the shift list.
//  Signing up triggers auth state change, which causes MainView to
//  transition to the authenticated app automatically.
//

import SwiftUI

struct PathA_AccountScreen: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(AuthenticationManager.self) var authManager

    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = true
    @State private var isLoading = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                // Header
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accentColor)

                    Text(isSignUp ? "Save your shifts —\ncreate your free account" : "Welcome back")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .multilineTextAlignment(.center)

                    if isSignUp {
                        Text("Your shift list is waiting for you.")
                            .font(.system(size: 15))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 28)

                // What you get (sign-up only)
                if isSignUp {
                    VStack(alignment: .leading, spacing: 12) {
                        benefitRow(icon: "list.bullet.clipboard", text: "Your personal shift history and earnings record")
                        benefitRow(icon: "star.fill", text: "A rating profile that helps you get hired faster")
                        benefitRow(icon: "lock.shield.fill", text: "Secure in-app wallet — no cash chasing")
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Colors.swiftUIColor(.cardBackground))
                    )
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 24)
                }

                // Form
                VStack(spacing: 14) {
                    if isSignUp {
                        BrandTextField(hasTitle: false, title: "", placeholder: "Full name", text: $displayName)
                    }

                    BrandTextField(hasTitle: false, title: "", placeholder: "Email address", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    BrandPasswordField(hasTitle: false, title: "", placeholder: "Password", text: $password)
                }
                .padding(.horizontal, 24)

                // Error message
                if let error = authManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.borderError))
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                Spacer().frame(height: 20)

                // Submit
                BrandButton(
                    isSignUp ? "Create Free Account" : "Sign In",
                    size: .large,
                    isDisabled: !isFormValid || isLoading,
                    hasIcon: false,
                    icon: "",
                    secondary: false
                ) {
                    Task { await handleAuth() }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 16)

                // Toggle sign up / sign in
                Button {
                    isSignUp.toggle()
                    authManager.errorMessage = nil
                } label: {
                    HStack(spacing: 4) {
                        Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text(isSignUp ? "Sign In" : "Sign Up")
                            .foregroundStyle(Color.accentColor)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }

                // TODO: Add Apple / Google Sign-In buttons here when configured

                Spacer().frame(height: 40)
            }
        }
    }

    // MARK: - Helpers

    private var isFormValid: Bool {
        if isSignUp {
            return !displayName.isEmpty && !email.isEmpty && password.count >= 6
        }
        return !email.isEmpty && !password.isEmpty
    }

    private func handleAuth() async {
        isLoading = true
        do {
            if isSignUp {
                try await authManager.signUp(email: email, password: password, fullName: displayName)
            } else {
                try await authManager.signIn(email: email, password: password)
            }
            // Mark onboarding complete so returning users see AuthenticationView
            try await appStateManager.completeOnboarding()
            // MainView detects auth state change and navigates to authenticated app
        } catch {
            print("Auth error: \(error)")
        }
        isLoading = false
    }

    @ViewBuilder
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
        }
    }
}
