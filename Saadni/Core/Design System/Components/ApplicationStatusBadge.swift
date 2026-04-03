//
//  ApplicationStatusBadge.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ApplicationStatusBadge: View {
    let status: JobApplicationStatus

    var badgeConfig: (text: String, color: Color, icon: String) {
        switch status {
        case .pending:
            return ("Pending", .orange, "clock.fill")
        case .accepted:
            return ("Accepted", .green, "checkmark.circle.fill")
        case .rejected:
            return ("Rejected", .red, "xmark.circle.fill")
        case .withdrawn:
            return ("Withdrawn", .gray, "arrow.uturn.backward")
        case .completed:
            return ("Completed", .purple, "checkmark.seal.fill")
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: badgeConfig.icon)
            Text(badgeConfig.text)
        }
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeConfig.color.opacity(0.2))
        .foregroundStyle(badgeConfig.color)
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 12) {
        ApplicationStatusBadge(status: .pending)
        ApplicationStatusBadge(status: .accepted)
        ApplicationStatusBadge(status: .rejected)
        ApplicationStatusBadge(status: .withdrawn)
    }
    .padding()
    .background(Color(.systemGray6))
}
