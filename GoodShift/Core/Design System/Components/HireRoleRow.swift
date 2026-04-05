//
//  HireRoleRow.swift
//  GoodShift
//
//  Created by Pavly Paules on 30/03/2026.
//

import SwiftUI

struct HireRoleRow: View {
	let icon: String
	let title: LocalizedStringResource
	let onHire: () -> Void

	var body: some View {
		HStack(spacing: 16) {
			ZStack {
				Circle()
					.fill(Color.accentColor.opacity(0.15))
					.frame(width: 30, height: 30)
				Image(systemName: icon)
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(Colors.swiftUIColor(.textMain))
			}

			Text(title)
				.font(.subheadline)
				.foregroundStyle(Colors.swiftUIColor(.textMain))

			Spacer()

			Button(action: onHire) {
				Text("Hire")
					.font(.subheadline)
					.foregroundStyle(.white)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(.accent)
					)
			}
		}
		.padding()
	}
}
