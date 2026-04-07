//
//  OnboardingScreenHeader.swift
//  GoodShift
//
//  Reusable headline + subheadline block used at the top of every questionnaire screen.
//

import SwiftUI

struct OnboardingScreenHeader: View {
    let headline: String
    let subheadline: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headline)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(subheadline)
                .font(.system(size: 15))
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
}
