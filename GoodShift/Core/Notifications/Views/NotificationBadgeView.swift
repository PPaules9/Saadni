import SwiftUI

// MARK: - Notification Badge View

struct NotificationBadgeView: View {
    let unreadCount: Int
    let action: () -> Void

    @State private var isAnimating = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                // Bell icon
                Image(systemName: "bell.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(UIColor(hex: "#37857D")))

                // Badge
                if unreadCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor(hex: "#FF3B30")))

                        Text(unreadCount > 99 ? "99+" : "\(unreadCount)")
                            .font(.system(size: unreadCount > 99 ? 9 : 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 20, height: 20)
                    .offset(x: 4, y: -4)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 32) {
        NotificationBadgeView(unreadCount: 0, action: {})
        NotificationBadgeView(unreadCount: 5, action: {})
        NotificationBadgeView(unreadCount: 99, action: {})
        NotificationBadgeView(unreadCount: 150, action: {})
    }
    .padding()
}
