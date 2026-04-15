//
//  PathA_TinderCardsScreen.swift
//  GoodShift
//

import SwiftUI

struct PathA_TinderCardsScreen: View {
    let onComplete: () -> Void

    private let statements = [
        "I've taken jobs before where I had to chase the employer for my money — and sometimes I never got it.",
        "I want to work, but I can't commit to a fixed schedule every week.",
        "I don't have a lot of experience yet. I worry that's why no one calls me back."
    ]

    @State private var currentIndex = 0
    @State private var swipedCount = 0

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "Do any of these\nsound familiar?",
                subheadline: "Swipe right if you relate, left if not."
            )

            Spacer()

            // Card stack
            ZStack {
                if currentIndex < statements.count {
                    // Background hint cards (stack depth illusion)
                    if currentIndex + 1 < statements.count {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Colors.swiftUIColor(.cardBackground))
                            .frame(height: 260)
                            .padding(.horizontal, 36)
                            .scaleEffect(0.92)
                            .offset(y: 10)
                            .opacity(0.6)
                    }
                    if currentIndex + 2 < statements.count {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Colors.swiftUIColor(.cardBackground))
                            .frame(height: 260)
                            .padding(.horizontal, 48)
                            .scaleEffect(0.85)
                            .offset(y: 20)
                            .opacity(0.3)
                    }

                    TinderCardView(
                        text: statements[currentIndex],
                        onAccept: {
                            AnalyticsService.shared.track(.onboardingCardSwiped(index: currentIndex, agreed: true))
                            advance()
                        },
                        onReject: {
                            AnalyticsService.shared.track(.onboardingCardSwiped(index: currentIndex, agreed: false))
                            advance()
                        }
                    )
                    .padding(.horizontal, 24)
                    .id(currentIndex)
                }
            }
            .frame(height: 310)

            // Swipe hint
            HStack(spacing: 32) {
                Label("Not me", systemImage: "xmark.circle")
                    .font(.system(size: 13))
                    .foregroundStyle(Colors.swiftUIColor(.borderError).opacity(0.8))

                Spacer()

                // Card counter
                Text("\(min(currentIndex + 1, statements.count)) / \(statements.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                Spacer()

                Label("I relate", systemImage: "checkmark.circle")
                    .font(.system(size: 13))
                    .foregroundStyle(Colors.swiftUIColor(.successGreen).opacity(0.9))
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)

            Spacer()
        }
    }

    private func advance() {

        swipedCount += 1
        if currentIndex + 1 < statements.count {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentIndex += 1
            }
        } else {
            // All cards swiped — advance after brief pause
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                onComplete()
            }
        }
    }
}

#Preview {
    PathA_TinderCardsScreen {}
        .background(Colors.swiftUIColor(.appBackground))
}
