//
//  PathA_SocialProofScreen.swift
//  GoodShift
//

import SwiftUI

struct PathA_SocialProofScreen: View {
    let onNext: () -> Void

    private let testimonials: [OnboardingTestimonial] = [
        OnboardingTestimonial(
            quote: "I made 1,800 EGP in my first two weeks — just on weekends. I didn't even have to chase anyone for the money.",
            name: "Mariam K.",
            tag: "University student · Food & Beverage"
        ),
        OnboardingTestimonial(
            quote: "I applied on Monday and worked my first shift on Wednesday. I didn't think it'd be that fast.",
            name: "Omar S.",
            tag: "Fresh graduate · Logistics"
        ),
        OnboardingTestimonial(
            quote: "The best part? I could see exactly what I'd earn before I even applied. No surprises.",
            name: "Nour A.",
            tag: "Part-time student · Retail"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "You're not alone —\nand it gets better.",
                subheadline: "Thousands of students across Egypt have already found reliable shifts."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(testimonials, id: \.name) { testimonial in
                        OnboardingTestimonialCard(testimonial: testimonial)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("That sounds like me →", size: .large, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PathA_SocialProofScreen {}
        .background(Colors.swiftUIColor(.appBackground))
}
