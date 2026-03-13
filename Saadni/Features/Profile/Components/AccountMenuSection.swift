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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Account")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
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
                    action: {}
                )

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
