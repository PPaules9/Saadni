//
//  ProfileHeaderView.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
	let displayName: String
	let email: String
	let photoURL: String?
	let completionPercentage: Int

	var body: some View {
		VStack(spacing: 12) {
			HStack(spacing: 16) {
				// Profile Image
				if let photoURL = photoURL, let url = URL(string: photoURL) {
					KFImage(url)
						.placeholder {
							Circle()
								.fill(Color.accent.opacity(0.2))
								.overlay(
									ProgressView()
										.progressViewStyle(.circular)
								)
						}
						.resizable()
						.scaledToFill()
						.frame(width: 70, height: 70)
						.clipShape(Circle())
				} else {
					Circle()
						.fill(Color.accent.opacity(0.2))
						.frame(width: 70, height: 70)
						.overlay(
							Image(systemName: "person.fill")
								.font(.system(size: 28))
								.foregroundStyle(.accent)
						)
				}
				HStack{
					VStack(alignment: .leading, spacing: 6) {
						Text(displayName)
							.font(.headline)
							.fontWeight(.semibold)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						Text(email)
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
					Spacer()
					// Profile Completion Circle
					ZStack {
						Circle()
							.stroke(Color(.systemGray5), lineWidth: 3)
							.frame(width: 50, height: 50)

						Circle()
							.trim(from: 0, to: CGFloat(completionPercentage) / 100)
							.stroke(Color.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
							.frame(width: 50, height: 50)
							.rotationEffect(.degrees(-90))

						VStack(spacing: 0) {
							Text("\(completionPercentage)")
								.font(.system(size: 14, weight: .semibold))
								.foregroundColor(.primary)
							Text("%")
								.font(.system(size: 10, weight: .regular))
								.foregroundColor(.secondary)
						}
					}
				}
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
	ProfileHeaderView(displayName: "John Doe", email: "john@example.com", photoURL: nil, completionPercentage: 75)
}
