//
//  AccountMenuSection.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct AccountMenuSection: View {
    let onLogout: () -> Void
    let onDeleteAccount: () -> Void
    @State private var navigateToAddresses = false
    @State private var navigateToLanguage = false

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
                    action: {}
                )

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
                    action: {}
                )

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
                    action: onDeleteAccount,
                    isDestructive: true
                )
            }
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AccountMenuSection(
        onLogout: {},
        onDeleteAccount: {}
    )
}
//
//  LanguageSelectionView.swift
//  Saadni
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
