//
//  PathB_DemoScreen.swift
//  GoodShift
//
//  Read-only preview of a pre-built shift post — lets the provider
//  feel the interface without having to fill out a form.
//

import SwiftUI

struct PathB_DemoScreen: View {
    let onNext: () -> Void

    // Simulated applicants for the demo
    private let applicants: [(initials: String, rating: Double)] = [
        ("MA", 4.8),
        ("OS", 4.6),
        ("NF", 4.9)
    ]

    var body: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "This is what posting\na shift looks like.",
                subheadline: "Simple, fast, and done in under a minute."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // Pre-built shift card
                    VStack(alignment: .leading, spacing: 0) {
                        // Card header
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color.accentColor)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Barista Shift — Evening Rush")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                                Text("Your Business")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            }

                            Spacer()

                            Text("Live")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Colors.swiftUIColor(.successGreen))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Colors.swiftUIColor(.successGreen).opacity(0.12))
                                )
                        }
                        .padding(16)

                        Divider()
                            .overlay(Colors.swiftUIColor(.textSecondary).opacity(0.1))

                        // Shift details grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            shiftDetail(icon: "banknote", label: "Pay", value: "250 EGP")
                            shiftDetail(icon: "clock", label: "Duration", value: "6 hours")
                            shiftDetail(icon: "calendar", label: "Date", value: "Tomorrow")
                            shiftDetail(icon: "clock.arrow.circlepath", label: "Time", value: "5:00 PM – 11:00 PM")
                            shiftDetail(icon: "mappin.circle", label: "Location", value: "Cairo Festival City")
                            shiftDetail(icon: "person.2.fill", label: "Workers needed", value: "2")
                        }
                        .padding(16)

                        Divider()
                            .overlay(Colors.swiftUIColor(.textSecondary).opacity(0.1))

                        // Applicants section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("👥  3 applicants already matched")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))

                            HStack(spacing: 12) {
                                ForEach(applicants, id: \.initials) { applicant in
                                    VStack(spacing: 4) {
                                        Text(applicant.initials)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundStyle(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Circle().fill(Color.accentColor))

                                        HStack(spacing: 2) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 9))
                                                .foregroundStyle(.yellow)
                                            Text(String(format: "%.1f", applicant.rating))
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Colors.swiftUIColor(.cardBackground))
                            .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 6)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton("This is what I want", size: .large, hasIcon: false, icon: "", secondary: false) {
                AnalyticsService.shared.track(.onboardingDemoCompleted(shiftsSaved: 0, role: "provider"))
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    @ViewBuilder
    private func shiftDetail(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Color.accentColor)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            Spacer()
        }
    }
}

#Preview {
    PathB_DemoScreen {}
        .background(Colors.swiftUIColor(.appBackground))
}
