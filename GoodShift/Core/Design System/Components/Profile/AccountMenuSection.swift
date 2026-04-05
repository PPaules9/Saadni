//
//  AccountMenuSection.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct AccountMenuSection: View {
    let onLogout: () -> Void

    @Environment(AuthenticationManager.self) var authManager

    @State private var navigateToAddresses = false
    @State private var navigateToLanguage = false
    @State private var navigateToCurrency = false
    @State private var showEditProfile = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Account")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ProfileMenuRow(
                    icon: "mappin.circle.fill",
                    title: "My Addresses",
                    action: { navigateToAddresses = true }
                )
                .navigationDestination(isPresented: $navigateToAddresses) {
                    MyAddressesView()
                }

                Divider()
                    .padding(.vertical, 0)

                ProfileMenuRow(
                    icon: "person.fill",
                    title: "Edit Personal Details",
                    action: { showEditProfile = true }
                )
                .sheet(isPresented: $showEditProfile) {
                    EditProfileSheet()
                }

                Divider()
                    .padding(.vertical, 0)

                ProfileMenuRow(
                    icon: "globe",
                    title: "Change The Language",
                    action: { navigateToLanguage = true }
                )
                .navigationDestination(isPresented: $navigateToLanguage) {
                    LanguageSelectionView()
                }

                Divider()
                    .padding(.vertical, 0)

                ProfileMenuRow(
                    icon: "dollarsign.circle.fill",
                    title: "Change The Currency",
                    action: { navigateToCurrency = true }
                )
                .navigationDestination(isPresented: $navigateToCurrency) {
                    CurrencySelectionView()
                }

                Divider()
                    .padding(.vertical, 0)

                ProfileMenuRow(
                    icon: "door.left.hand.open",
                    title: "Log Out",
                    action: onLogout
                )

                Divider()
                    .padding(.vertical, 0)

                ProfileMenuRow(
                    icon: "trash.fill",
                    title: "Delete Account",
                    action: { showDeleteConfirmation = true },
                    isDestructive: true
                )
            }
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showDeleteConfirmation) {
            DeleteAccountSheet(authManager: authManager)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Delete Account Confirmation Sheet

private struct DeleteAccountSheet: View {
    let authManager: AuthenticationManager

    @Environment(\.dismiss) private var dismiss

    @State private var password = ""
    @State private var errorMessage: String? = nil
    @State private var isDeleting = false

    var body: some View {
        ZStack {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Icon
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.red)

                // Title + description
                VStack(spacing: 8) {
                    Text("Delete Account")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    Text("This will permanently delete your account and all your data. This action cannot be undone.")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .multilineTextAlignment(.center)
                }

                // Password field
                VStack(alignment: .leading, spacing: 6) {
                    BrandPasswordField(
                        hasTitle: true,
                        title: "Confirm with your password",
                        placeholder: "Enter your password",
                        text: $password
                    )

                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 4)
                    }
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        Task { await confirmDelete() }
                    } label: {
                        Group {
                            if isDeleting {
                                ProgressView().tint(.white)
                            } else {
                                Text("Delete My Account")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(password.isEmpty ? Color.red.opacity(0.4) : Color.red)
                        .clipShape(Capsule())
                    }
                    .disabled(password.isEmpty || isDeleting)

                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .disabled(isDeleting)
                }
            }
            .padding(24)
        }
    }

    private func confirmDelete() async {
        errorMessage = nil
        isDeleting = true

        do {
            try await authManager.deleteAccount(password: password)
            // Auth state change automatically navigates the user out
        } catch {
            await MainActor.run {
                isDeleting = false
                errorMessage = friendlyError(error)
            }
        }
    }

    private func friendlyError(_ error: Error) -> String {
        let msg = error.localizedDescription.lowercased()
        if msg.contains("wrong-password") || msg.contains("invalid credential") {
            return "Incorrect password. Please try again."
        }
        if msg.contains("network") {
            return "No internet connection. Please try again."
        }
        return "Something went wrong. Please try again."
    }
}

#Preview {
    let userCache = UserCache()
    AccountMenuSection(onLogout: {})
        .environment(AuthenticationManager(userCache: userCache))
}
//
//  LanguageSelectionView.swift
//  GoodShift
//
//  Created by Assistant on 24/03/2026.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("appLanguage") private var appLanguage = "en"

    var body: some View {
        VStack(spacing: 0) {
            Text("Select Language")
                .font(.headline)
                .padding(.vertical, 24)

            List {
                LanguageRow(
                    title: "English",
                    subtitle: "English",
                    isSelected: appLanguage == "en"
                ) {
                    selectLanguage("en")
                }

                LanguageRow(
                    title: "العربية",
                    subtitle: "Arabic",
                    isSelected: appLanguage == "ar"
                ) {
                    selectLanguage("ar")
                }
            }
						.listRowBackground(Colors.swiftUIColor(.appBackground))
            .listStyle(.insetGrouped)
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(Colors.swiftUIColor(.appBackground))
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func selectLanguage(_ lang: String) {
        // Update the app language in AppStorage, triggering Global UI reload
        withAnimation {
            appLanguage = lang
        }

        // Give the UI a tiny moment to process the state change before popping back
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            dismiss()
        }
    }
}

// MARK: - Helper Components
fileprivate struct LanguageRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .environment(\.layoutDirection, .leftToRight) // Ensure English is LTR and Arabic can display properly without UI bugs mid-transition

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.accent)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
    }
}

// MARK: - CurrencySelectionView

struct CurrencySelectionView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("appCurrency") private var appCurrency = "EGP"

    var body: some View {
        List(Currency.allCases) { currency in
            CurrencyRow(
                currency: currency,
                isSelected: appCurrency == currency.rawValue
            ) {
                selectCurrency(currency)
            }
        }
        .listStyle(.insetGrouped)
        .scrollBounceBehavior(.basedOnSize)
        .background(Colors.swiftUIColor(.appBackground))
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func selectCurrency(_ currency: Currency) {
        withAnimation {
            appCurrency = currency.rawValue
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            dismiss()
        }
    }
}

// MARK: - Currency Row

private struct CurrencyRow: View {
    let currency: Currency
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(currency.flag)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(currency.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                    Text("\(currency.rawValue) · \(currency.symbol)")
                        .font(.caption)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.accent)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CurrencySelectionView()
    }
}
