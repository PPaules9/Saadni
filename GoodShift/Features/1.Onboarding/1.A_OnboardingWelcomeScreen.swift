//
//  OnboardingWelcomeScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/03/2026.
//

import SwiftUI

struct OnboardingWelcomeScreen: View {
	let onGetStarted: () -> Void
	@State private var showCurrencyPicker = false
	@AppStorage(AppConstants.Storage.appCurrency) private var appCurrency: String = "USD"
	
	private var selectedCurrency: Currency {
		Currency(rawValue: appCurrency) ?? .egp
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack(alignment: .top) {
				Color(Colors.swiftUIColor(.appBackground))
					.ignoresSafeArea()
				
				VStack(spacing: 0) {
					ZStack(alignment: .top){
						
						// MARK: - Photo (top 62%, extends behind status bar)
						ZStack(alignment: .bottomLeading) {
							Image("WelcomePhoto")
								.resizable()
								.scaledToFill()
								.frame(
									width: geo.size.width,
									height: UIScreen.main.bounds.height * 0.68
								)
								.clipped()
							
							LinearGradient(
								colors: [.black.opacity(0.7), .black.opacity(0.2)],
								startPoint: .bottom,
								endPoint: .top
							)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("find work with")
									.font(.system(size: 16, weight: .medium))
									.foregroundStyle(.white.opacity(0.85))
								Text("GoodShift")
									.font(.system(size: 42, weight: .bold))
									.foregroundStyle(.white)
							}
							.padding(.horizontal, 20)
							.padding(.bottom, 52)
						}
						.frame(height: UIScreen.main.bounds.height * 0.68)
						.ignoresSafeArea(edges: .top)
						
						// MARK: - Currency Pill (top-right, safe-area-aware)
						
						Button {
							showCurrencyPicker = true
						} label: {
							HStack(spacing: 6) {
								Text(selectedCurrency.flag)
									.font(.system(size: 18))
								Text(selectedCurrency.rawValue)
									.font(.system(size: 14))
									.bold()
									.foregroundStyle(.white)
								Image(systemName: "chevron.down")
									.font(.system(size: 12, weight: .medium))
									.foregroundStyle(.white.opacity(0.9))
							}
							.padding(.horizontal, 14)
							.padding(.vertical, 9)
							.background(Color.black.opacity(0.7))
							.clipShape(Capsule())
							.overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 0.5))
						}
						.padding(.top)
					}
										
					// MARK: - Bottom Content
					VStack(spacing: 0) {
												
						BrandHeaderText(
							headline: "Hi there, 👋",subheadline: "Pick up shifts in your free time, or hire people who get it done."
						)
						.multilineTextAlignment(.center)
						.padding(.bottom)
						
						BrandButton("Get Started", size: .large, hasIcon: false, icon: "", secondary: false) {
							onGetStarted()
						}
						.padding(.horizontal, 20)
					}
					.padding(.top, -22)
				}
			}
		}
		.sheet(isPresented: $showCurrencyPicker) {
			NavigationStack {
				CurrencySelectionView()
			}
			.presentationDetents([.medium, .large])
			.presentationDragIndicator(.visible)
		}
		
	}
}

#Preview {
	OnboardingWelcomeScreen {}
}
