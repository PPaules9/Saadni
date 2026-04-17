//
//  RoleCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import SwiftUI


 struct RoleCard: View {
	var icon: String? = nil
	let title: String
	let accentColor: Color
	let onTap: () -> Void
	
	@State private var isPressed = false
	
	var body: some View {
		Button(action: onTap) {
			HStack(spacing: 18) {
				if let icon = icon {
					Image(icon)
						.resizable()
						.frame(width: 68, height: 68)
						.foregroundStyle(accentColor)
				}
				VStack(alignment: .leading, spacing: 4) {
					Text(title)
						.font(.system(size: 17, weight: .semibold))
						.fontWeight(.semibold)
						.foregroundStyle(Colors.swiftUIColor(.textMain))
	
				}
				
				Spacer()
				
				Image(systemName: "chevron.right")
					.font(.system(size: 14, weight: .semibold))
					.foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.5))
			}
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 24)
					.fill(Colors.swiftUIColor(.cardBackground))
					.shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 4)
			)
			.scaleEffect(isPressed ? 0.97 : 1.0)
		}
		.buttonStyle(.plain)
		.simultaneousGesture(
			DragGesture(minimumDistance: 0)
				.onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = true } }
				.onEnded   { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = false } }
		)
	}
}


#Preview {
	VStack {
		Spacer()
		RoleCard(icon: "brandImage2", title: "dsfds", accentColor: .accent, onTap: {})
			.padding()
		Spacer()
	}
	.background(Colors.swiftUIColor(.appBackground))
	.ignoresSafeArea()
}
