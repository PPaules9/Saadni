//
//  OnboardingProcessingScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct OnboardingProcessingScreen: View {
	let message: String
	let onComplete: () -> Void
	
	@State private var scale: CGFloat = 0.8
	@State private var opacity: Double = 0.4
	@State private var dotOpacities: [Double] = [1, 0.4, 0.4]
	
	var body: some View {
		VStack(spacing: 32) {
			Spacer()
			
			// Pulsing brand icon
			ZStack {
				Circle()
					.fill(Color.accentColor.opacity(0.1))
					.frame(width: 120, height: 120)
					.scaleEffect(scale)
				
				Circle()
					.fill(Color.accentColor.opacity(0.2))
					.frame(width: 90, height: 90)
				
				Image(systemName: "hands.and.sparkles.fill")
					.font(.system(size: 40))
					.foregroundStyle(Color.accentColor)
			}
			.onAppear {
				withAnimation(
					.easeInOut(duration: 1.0)
					.repeatForever(autoreverses: true)
				) {
					scale = 1.1
					opacity = 1.0
				}
			}
			
			VStack(spacing: 10) {
				Text(message)
					.font(.system(size: 20, weight: .semibold))
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.multilineTextAlignment(.center)
				
				// Animated dots
				HStack(spacing: 6) {
					ForEach(0..<3, id: \.self) { i in
						Circle()
							.fill(Color.accentColor)
							.frame(width: 7, height: 7)
							.opacity(dotOpacities[i])
					}
				}
				.onAppear { startDotAnimation() }
			}
			
			Spacer()
		}
		.padding(.horizontal, 32)
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
				onComplete()
			}
		}
	}
	
	private func startDotAnimation() {
		for i in 0..<3 {
			DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
				withAnimation(
					.easeInOut(duration: 0.5)
					.repeatForever(autoreverses: true)
					.delay(Double(i) * 0.3)
				) {
					dotOpacities[i] = 1.0
				}
			}
		}
	}
}

#Preview {
	OnboardingProcessingScreen(message: "Setting up your employer profile…") {}
		.background(Colors.swiftUIColor(.appBackground))
}
