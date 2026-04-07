//
//  PathB_GoalScreen.swift
//  GoodShift
//
//  Service Provider — what kind of staff do you usually need?
//

import SwiftUI

struct PathB_GoalScreen: View {
    @Binding var selected: Set<ServiceCategoryType>
    let onNext: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "What kind of staff\ndo you usually need?",
                subheadline: "Pick all that apply — we'll make sure the right workers find you."
            )

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(ServiceCategoryType.allCases, id: \.self) { category in
                        OnboardingCategoryCell(
                            icon: category.icon,
                            label: category.rawValue,
                            isSelected: selected.contains(category)
                        ) {
                            if selected.contains(category) {
                                selected.remove(category)
                            } else {
                                selected.insert(category)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("Continue", size: .large, hasIcon: false, icon: "", secondary: false) {
                AnalyticsService.shared.track(.onboardingCategoriesSelected(
                    categories: selected.map(\.rawValue),
                    role: "provider"
                ))
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}
