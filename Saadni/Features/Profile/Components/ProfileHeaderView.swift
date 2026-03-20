//
//  ProfileHeaderView.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
	let displayName: String
	let email: String
	let photoURL: String?
	
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
					VStack{
						HStack(spacing: 4){
							Image("star.accent")
								.resizable()
								.frame(width: 12, height: 12)
							Text("4.76")
								.font(.subheadline)
								.foregroundStyle(Colors.swiftUIColor(.primary))
							
						}
						Text("")
							.font(.title)
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
	ProfileHeaderView(displayName: "John Doe", email: "john@example.com", photoURL: nil)
}
