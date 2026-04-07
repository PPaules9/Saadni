//
//  PathA_PainPointsScreen.swift
//  GoodShift
//

import SwiftUI

struct PathA_PainPointsScreen: View {
    @Binding var selected: Set<String>
    let onNext: () -> Void

    private let options: [(emoji: String, label: String)] = [
        ("❓", "I never know if the job is real"),
        ("🔄", "My schedule changes — I need flexibility"),
        ("💸", "I got paid late, or not at all"),
        ("😤", "I showed up and there was no job"),
        ("📵", "I didn't know who to contact or how to apply"),
        ("🚫", "I didn't have enough experience to get hired")
    ]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "What's stopped\nyou before?",
                subheadline: "Pick everything that applies — we built GoodShift to fix exactly this."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(options, id: \.label) { option in
                        OnboardingMultiOptionRow(
                            emoji: option.emoji,
                            label: option.label,
                            isSelected: selected.contains(option.label)
                        ) {
                            if selected.contains(option.label) {
                                selected.remove(option.label)
                            } else {
                                selected.insert(option.label)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            // Always visible — multi-select has no requirement
            BrandButton("Continue", size: .large, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}
