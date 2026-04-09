//
//  PathB_AccountScreen.swift
//  GoodShift
//
//  Final onboarding screen for the Service Provider path.
//

import SwiftUI

struct PathB_AccountScreen: View {
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

                VStack(spacing: 10) {
                    Image(systemName: "building.2.crop.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Colors.swiftUIColor(.primaryDark))

                    Text(isSignUp ? "Start posting shifts —\nit's free" : "Welcome back")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .multilineTextAlignment(.center)

                    if isSignUp {
                        Text("Your first shift is one tap away.")
                            .font(.system(size: 15))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 28)

                if isSignUp {
                    VStack(alignment: .leading, spacing: 12) {
                        benefitRow(icon: "doc.badge.plus", text: "Post unlimited shifts during your trial")
                        benefitRow(icon: "person.2.fill", text: "Access verified, rated workers in your area")
                        benefitRow(icon: "chart.bar.fill", text: "Manage everything from one dashboard")
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Colors.swiftUIColor(.cardBackground))
                    )
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 24)
                }

                VStack(spacing: 14) {
                    if isSignUp {
                        BrandTextField(hasTitle: false, title: "", placeholder: "Business / Full name", text: $displayName)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "Email address", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    BrandPasswordField(hasTitle: false, title: "", placeholder: "Password", text: $password)
                }
                .padding(.horizontal, 24)

                if let error = authManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.borderError))
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                Spacer().frame(height: 20)

                BrandButton(
                    isSignUp ? "Create Free Account" : "Sign In",
                    size: .large,
                    isDisabled: !isFormValid || isLoading,
                    hasIcon: false, icon: "", secondary: false
                ) {
                    Task { await handleAuth() }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 16)

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

    private var isFormValid: Bool {
        isSignUp
            ? !displayName.isEmpty && !email.isEmpty && password.count >= 6
            : !email.isEmpty && !password.isEmpty
    }

    private func handleAuth() async {
        isLoading = true
        do {
            if isSignUp {
                try await authManager.signUp(email: email, password: password, fullName: displayName, role: .provider)
            } else {
                try await authManager.signIn(email: email, password: password)
            }
            try await appStateManager.completeOnboarding()
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
                .foregroundStyle(Colors.swiftUIColor(.primaryDark))
                .frame(width: 24)
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
        }
    }
}
