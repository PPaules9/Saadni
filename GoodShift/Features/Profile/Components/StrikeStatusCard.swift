//
//  StrikeStatusCard.swift
//  GoodShift
//

import SwiftUI

// MARK: - Strike Level

enum StrikeLevel {
    case healthy    // 0 strikes
    case risky      // 1 strike
    case critical   // 2 strikes
    case banned     // 3 strikes

    init(strikes: Int) {
        switch strikes {
        case 0:        self = .healthy
        case 1:        self = .risky
        case 2:        self = .critical
        default:       self = .banned
        }
    }

    var label: String {
        switch self {
        case .healthy:  return "Healthy"
        case .risky:    return "Risky"
        case .critical: return "Critical"
        case .banned:   return "Banned"
        }
    }

    var description: String {
        switch self {
        case .healthy:
            return "Your account is in good standing. Keep showing up and doing great work!"
        case .risky:
            return "You have 1 strike. One more no-show will move you to Critical status."
        case .critical:
            return "You have 2 strikes. One more no-show will permanently ban your account."
        case .banned:
            return "Your account has been banned due to repeated no-shows. Contact support to appeal."
        }
    }

    var icon: String {
        switch self {
        case .healthy:  return "checkmark.shield.fill"
        case .risky:    return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        case .banned:   return "slash.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .healthy:  return .green
        case .risky:    return .orange
        case .critical: return Color(red: 1.0, green: 0.35, blue: 0.0)
        case .banned:   return .red
        }
    }
}

// MARK: - Strike Status Card

struct StrikeStatusCard: View {
    let strikes: Int

    private var level: StrikeLevel { StrikeLevel(strikes: strikes) }
    private let maxStrikes = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // Title row
            HStack(spacing: 8) {
                Image(systemName: level.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(level.color)

                Text("Account Status")
                    .font(.headline)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))

                Spacer()

                Text(level.label)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(level.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(level.color.opacity(0.15))
                    .clipShape(Capsule())
            }

            // Strike dots
            HStack(spacing: 10) {
                Text("Strikes:")
                    .font(.subheadline)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                HStack(spacing: 6) {
                    ForEach(0..<maxStrikes, id: \.self) { index in
                        Circle()
                            .fill(index < strikes ? level.color : Color.gray.opacity(0.25))
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .stroke(index < strikes ? level.color : Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                }

                Text("\(strikes)/\(maxStrikes)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }

            // Description
            Text(level.description)
                .font(.caption)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(level.color.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(level.color.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

#Preview {
    VStack(spacing: 16) {
        StrikeStatusCard(strikes: 0)
        StrikeStatusCard(strikes: 1)
        StrikeStatusCard(strikes: 2)
        StrikeStatusCard(strikes: 3)
    }
    .padding(20)
    .background(Color.gray.opacity(0.1))
}
