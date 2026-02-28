import SwiftUI

struct ApplicationBadge: View {
    let count: Int
    var size: BadgeSize = .medium

    enum BadgeSize {
        case small
        case medium
        case large

        var fontSize: CGFloat {
            switch self {
            case .small: return 11
            case .medium: return 13
            case .large: return 15
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
            case .large: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 14
            case .large: return 16
            }
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "person.fill")
                .font(.system(size: size.iconSize))

            Text("\(count)")
                .font(.system(size: size.fontSize, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(size.padding)
        .background(
            ZStack {
                // Glass background
                Color.white.opacity(0.15)

                // Accent tint
                Color.blue.opacity(0.3)
            }
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.blue.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Variants

extension ApplicationBadge {
    /// Badge showing "NEW" indicator
    static func newBadge(size: BadgeSize = .medium) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "sparkles")
                .font(.system(size: size.iconSize))
            Text("NEW")
                .font(.system(size: size.fontSize, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(size.padding)
        .background(Color.green.opacity(0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.green, lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color.black

        VStack(spacing: 20) {
            ApplicationBadge(count: 3, size: .small)
            ApplicationBadge(count: 12, size: .medium)
            ApplicationBadge(count: 99, size: .large)
            ApplicationBadge.newBadge(size: .medium)
        }
    }
}
