//
//  PathA_GoalScreen.swift
//  GoodShift
//
//
//  Created by Pavly Paules on 14/04/2026.
//

import SwiftUI

struct PathA_GoalScreen: View {
    @Binding var selectedGoal: String
    let onNext: () -> Void

    private let goals: [(emoji: String, label: String)] = [
        ("📚", "Extra income alongside my studies"),
        ("🗓️", "A flexible job that works around me"),
        ("⭐", "My first real work experience"),
        ("🌅", "Something to do on weekends"),
        ("🎯", "A specific type of job I already have in mind")
    ]

    var body: some View {
        VStack(spacing: 0) {
            BrandHeaderText(
                headline: "What are you\nlooking for?",
                subheadline: "Pick the one that fits best — we'll find shifts that match."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(goals, id: \.label) { goal in
                        OnboardingSingleOptionRow(
                            emoji: goal.emoji,
                            label: goal.label,
                            isSelected: selectedGoal == goal.label
                        ) {
                            selectedGoal = goal.label
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("Continue", size: .large, isDisabled: selectedGoal.isEmpty, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    @Previewable @State var goal = ""
    PathA_GoalScreen(selectedGoal: $goal) {}
        .background(Colors.swiftUIColor(.appBackground))
}
