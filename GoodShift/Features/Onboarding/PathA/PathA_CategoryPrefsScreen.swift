//
//  PathA_CategoryPrefsScreen.swift
//  GoodShift
//

import SwiftUI

struct PathA_CategoryPrefsScreen: View {
    @Binding var selected: Set<ServiceCategoryType>
    let onNext: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "What kind of work\ninterests you?",
                subheadline: "Pick everything you'd consider — we'll keep these in mind."
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

            BrandButton("Continue", size: .large, isDisabled: selected.isEmpty, hasIcon: false, icon: "", secondary: false) {
                AnalyticsService.shared.track(.onboardingCategoriesSelected(
                    categories: selected.map(\.rawValue),
                    role: "job_seeker"
                ))
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}
