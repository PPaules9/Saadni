//
//  OnboardingWelcomeScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import SwiftUI

enum LegalSheet: Identifiable {
	case terms
	case privacy
	
	var id: Self { self }
}

struct OnboardingWelcomeScreen: View {
	let onGetStarted: () -> Void
	@State private var isAnimating = false
	@State private var isAgreed = false
	@State private var activeSheet: LegalSheet?
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 0) {
				// Hero illustration
				GeometryReader { proxy in
					Image("brandImage1")
						.resizable()
						.scaledToFit() // Scale perfectly without trimming
						.frame(width: UIScreen.main.bounds.width * 0.85, height: proxy.size.height)
						.opacity(isAnimating ? 1 : 0)
						.position(x: proxy.size.width / 2, y: proxy.size.height / 2)
				}
				.frame(height: UIScreen.main.bounds.height * 0.43)
				.padding(.top, 52)
				// Content block
				VStack(spacing: 32) {
					VStack(spacing: 12) {
						Text("Welcome to GoodShift")
							.font(.system(size: 32, weight: .bold, design: .default))
							.foregroundStyle(Colors.swiftUIColor(.textMain))
							.multilineTextAlignment(.center)
							.tracking(-0.5)
						
						Text("Pick up shifts in your free time. Or hire people who get it done")
							.font(.system(size: 18))
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							.multilineTextAlignment(.center)
					}
					.padding(.top, 32)
					
					Spacer()
					
					// Terms Checkbox
					HStack(alignment: .top, spacing: 14) {
						// Custom Checkbox UI
						Button {
							withAnimation(.easeInOut(duration: 0.15)) {
								isAgreed.toggle()
							}
						} label: {
							ZStack {
								RoundedRectangle(cornerRadius: 6)
									.stroke(isAgreed ? Color.accentColor : Colors.swiftUIColor(.textSecondary).opacity(0.4), lineWidth: 2)
									.frame(width: 24, height: 24)
									.background(
										RoundedRectangle(cornerRadius: 6)
											.fill(isAgreed ? Color.accentColor.opacity(0.1) : Color.clear)
									)
								if isAgreed {
									Image(systemName: "checkmark")
										.font(.system(size: 12, weight: .bold))
										.foregroundStyle(Color.accentColor)
								}
							}
						}
						.buttonStyle(.plain)
						.padding(.top, 2)
						
						Text("I agree to GoodShift's [Terms & Conditions](goodshift://terms) and acknowledge the [Privacy Policy](goodshift://privacy).")
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							.tint(Color.accentColor)
							.font(.system(size: 14))
							.multilineTextAlignment(.leading)
							.environment(\.openURL, OpenURLAction { url in
								if url.absoluteString == "goodshift://terms" {
									activeSheet = .terms
									return .handled
								} else if url.absoluteString == "goodshift://privacy" {
									activeSheet = .privacy
									return .handled
								}
								return .systemAction
							})
					}
					.padding(.horizontal, 8)
					.padding(.top, 52)
					// CTA
					BrandButton("Create an account", size: .large, hasIcon: false, icon: "", secondary: false) {
						onGetStarted()
					}
					.opacity(isAgreed ? 1.0 : 0.6)
					.disabled(!isAgreed)
				}
				.padding(.horizontal, 24)
			}
		}
		.background(Colors.swiftUIColor(.appBackground))
		.onAppear {
			withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
				isAnimating = true
			}
		}
		.sheet(item: $activeSheet) { sheet in
			NavigationStack {
				switch sheet {
				case .terms:
					TermsAndConditionsView()
				case .privacy:
					PrivacyPolicyView()
				}
			}
		}
	}
}

#Preview {
	OnboardingWelcomeScreen {}
}
