//
//  StrikeNotificationCard.swift
//  GoodShift
//

import SwiftUI

struct StrikeNotificationCard: View {
    let strikes: Int
    let serviceTitle: String?
    let onDismiss: () -> Void

    private var level: StrikeLevel { StrikeLevel(strikes: strikes) }

    var body: some View {
        ZStack {
            // Blurred background
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(level.color.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: level.icon)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(level.color)
                    }

                    // Text
                    VStack(spacing: 8) {
                        Text("You Received a Strike")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        if let title = serviceTitle, !title.isEmpty {
                            Text("For missing the shift: \"\(title)\"")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                .multilineTextAlignment(.center)
                        }

                        // Strike dots
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index < strikes ? level.color : Color.gray.opacity(0.25))
                                    .frame(width: 16, height: 16)
                                    .overlay(Circle().stroke(index < strikes ? level.color : Color.gray.opacity(0.4), lineWidth: 1))
                            }
                        }
                        .padding(.top, 4)

                        // Status label
                        Text(level.label)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(level.color)

                        Text(level.description)
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Warning banner for critical/banned
                    if strikes >= 2 {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(level.color)
                            Text(strikes >= 3
                                 ? "Your account has been banned. Contact support to appeal."
                                 : "One more no-show will permanently ban your account.")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(level.color)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .background(level.color.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(level.color.opacity(0.3), lineWidth: 1))
                    }

                    // Dismiss button
                    Button(action: onDismiss) {
                        Text("I Understand")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(level.color)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(28)
                .background(Colors.swiftUIColor(.cardBackground))
                .cornerRadius(28)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        StrikeNotificationCard(strikes: 2, serviceTitle: "Barista at Beano's Maadi") {}
    }
}
