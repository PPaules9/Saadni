//
//  WelcomeCardsOverlay.swift
//  GoodShift
//

import SwiftUI

// MARK: - Card Model

struct WelcomeCard {
	let icon: String
	let title: String
	let body: String
}

// MARK: - Card Data

extension WelcomeCard {
	static let providerCards: [WelcomeCard] = [
		WelcomeCard(
			icon: "hand.wave.fill",
			title: "Welcome!",
			body: "Post shifts, pick your people, and get the work done — all in one place."
		),
		WelcomeCard(
			icon: "banknote.fill",
			title: "Pay Before You Hire",
			body: "You fund the shift upfront. Your money is held securely — released to the worker only after the job is completed."
		),
		WelcomeCard(
			icon: "lock.fill",
			title: "No Cancellations After Hiring",
			body: "Once a worker is accepted, the shift is locked. Plan your posting carefully before confirming."
		),
		WelcomeCard(
			icon: "arrow.uturn.left.circle.fill",
			title: "Worker No-Show? We've Got You",
			body: "If a hired worker doesn't show up, you get a full refund plus one free job boost credit — automatically."
		),
		WelcomeCard(
			icon: "star.fill",
			title: "Rate Every Shift",
			body: "Your honest ratings shape the community. Great workers get more visibility — and the bad ones get filtered out."
		),
	]
	
	static let workerCards: [WelcomeCard] = [
		WelcomeCard(
			icon: "hand.wave.fill",
			title: "Welcome!",
			body: "Browse shifts near you, apply in seconds, and start earning. Your wallet tracks every penny."
		),
		WelcomeCard(
			icon: "exclamationmark.triangle.fill",
			title: "Show Up or Strike",
			body: "Every accepted shift is a commitment. Miss one without notice = 1 strike. 3 strikes = permanent ban."
		),
		WelcomeCard(
			icon: "wallet.bifold.fill",
			title: "Get Paid Through the Wallet",
			body: "Your earnings are deposited automatically after each confirmed shift. Safe, simple, no cash drama."
		),
		WelcomeCard(
			icon: "chart.line.uptrend.xyaxis",
			title: "Build Your Reputation",
			body: "Every shift earns you a rating. High ratings mean more accepted applications and better opportunities."
		),
		WelcomeCard(
			icon: "checkmark.seal.fill",
			title: "Stay Professional",
			body: "Be on time, communicate clearly, and treat every shift like it counts. That's the GoodShift standard."
		),
	]
}

// MARK: - Overlay View

struct WelcomeCardsOverlay: View {
	let cards: [WelcomeCard]
	let onComplete: () -> Void
	
	@State private var currentIndex = 0
	@State private var slideOffset: CGFloat = 0
	@State private var opacity: Double = 1
	
	private var isLastCard: Bool { currentIndex == cards.count - 1 }
	private var card: WelcomeCard { cards[currentIndex] }
	
	var body: some View {
		ZStack {
			// Dim background
			Color.black.opacity(0.8)
				.ignoresSafeArea()
				.onTapGesture {} // Swallow taps so the background is not interactive
			
			VStack(spacing: 0) {
				
				Spacer()
				
				// Card
				VStack(spacing: 24) {
					// Icon
					ZStack {
						Circle()
							.fill(Color.accentColor.opacity(0.15))
							.frame(width: 88, height: 88)
						
						Image(systemName: card.icon)
							.font(.system(size: 36, weight: .semibold))
							.foregroundStyle(Color.accentColor)
					}
					
					
						BrandHeaderText(headline: card.title, subheadline: card.body)
							.multilineTextAlignment(.center)

					
					// Page dots
					HStack(spacing: 7) {
						ForEach(0..<cards.count, id: \.self) { i in
							Capsule()
								.fill(i == currentIndex ? Color.accentColor : Color.gray.opacity(0.3))
								.frame(width: i == currentIndex ? 22 : 8, height: 8)
								.animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentIndex)
						}
					}
					.padding(.top, 4)
					
					VStack(spacing: 8){
						
						BrandButton(isLastCard ? "Got It" : "Next", hasIcon: false, icon: "", secondary: false, action: {
							if isLastCard {
								dismiss()
							} else {
								advanceCard()
							}
						})
						
						BrandButton("SkiP", hasIcon: false, icon: "", secondary: true, action: {
							dismiss()
						})
					}
				}
				.padding(28)
				.background(Colors.swiftUIColor(.cardBackground))
				.cornerRadius(32)
				.padding(.horizontal, 24)
				.offset(x: slideOffset)
				.opacity(opacity)
				
				Spacer()
			}
		}
		.transition(.opacity)
	}
	
	// MARK: - Helpers
	
	private func advanceCard() {
		let direction: CGFloat = -1
		withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
			slideOffset = direction * 60
			opacity = 0
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
			currentIndex += 1
			slideOffset = -direction * 60
			withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
				slideOffset = 0
				opacity = 1
			}
		}
	}
	
	private func dismiss() {
		withAnimation(.easeOut(duration: 0.25)) {
			onComplete()
		}
	}
}

#Preview {
	ZStack {
		Color.gray.ignoresSafeArea()
		WelcomeCardsOverlay(cards: WelcomeCard.providerCards) {}
	}
}
