//
//  ProfileHeaderView.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    let displayName: String
    let email: String

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Profile Image
                Circle()
                    .fill(Color.accent.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.accent)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(16)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(28)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

#Preview {
    ProfileHeaderView(displayName: "John Doe", email: "john@example.com")
}
