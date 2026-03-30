import SwiftUI

// MARK: - Professional Notification Card View

struct NotificationCardView: View {
    let notification: Notification
    let onMarkAsRead: () -> Void
    let onDelete: () -> Void

    @State private var isShowingDeleteConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Card Container
            HStack(spacing: 12) {
                // MARK: - Icon & Unread Indicator
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 48, height: 48)

                    Text(iconEmoji)
                        .font(.system(size: 24))

                    // Unread dot
                    if !notification.read {
                        Circle()
                            .fill(Color(UIColor(hex: "#FF3B30")))
                            .frame(width: 10, height: 10)
                            .offset(x: 2, y: -2)
                    }
                }

                // MARK: - Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(notification.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(UIColor(hex: "#1C1C1E")))
                            .lineLimit(1)

                        Spacer()

                        Text(notification.timeAgo)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(UIColor(hex: "#8E8E93")))
                    }

                    Text(notification.body)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(UIColor(hex: "#3C3C43")))
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        // Priority badge
                        HStack(spacing: 4) {
                            Circle()
                                .fill(priorityColor)
                                .frame(width: 6, height: 6)

                            Text(notification.priority.rawValue.capitalized)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(priorityColor)
                        }
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(
                            Color(UIColor(hex: priorityBackgroundHex))
                                .opacity(0.2)
                        )
                        .cornerRadius(4)

                        // Category badge
                        Text(notification.category.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(UIColor(hex: "#37857D")))
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(
                                Color(UIColor(hex: "#37857D"))
                                    .opacity(0.1)
                            )
                            .cornerRadius(4)

                        Spacer()
                    }
                }

                // MARK: - Actions Menu
                Menu {
                    Button(action: onMarkAsRead) {
                        Label(
                            notification.read ? "Mark as Unread" : "Mark as Read",
                            systemImage: notification.read ? "circle" : "circle.fill"
                        )
                    }

                    Button(role: .destructive, action: {
                        isShowingDeleteConfirmation = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(UIColor(hex: "#8E8E93")))
                        .font(.system(size: 18))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
            )
            .opacity(notification.read ? 0.6 : 1.0)

            // MARK: - Divider
            Divider()
                .padding(.horizontal, 12)
        }
        .confirmationDialog(
            "Delete Notification",
            isPresented: $isShowingDeleteConfirmation,
            presenting: notification
        ) { _ in
            Button("Delete", role: .destructive, action: onDelete)
        } message: { _ in
            Text("Are you sure you want to delete this notification?")
        }
    }

    // MARK: - Computed Properties

    private var iconEmoji: String {
        switch notification.type {
        case .newApplicationReceived:
            return "📝"
        case .newMessageFromProvider, .newMessageFromSeeker:
            return "💬"
        case .applicationAcceptedBySeeker, .applicationStatus:
            return "✅"
        case .applicationWithdrawnBySeeker, .applicationWithdrawnAck:
            return "❌"
        case .jobReminder, .jobStartsSoon:
            return "🔔"
        case .paymentReceived, .earningReceived:
            return "💰"
        case .reviewPostedByProvider, .reviewPostedBySeeker:
            return "⭐"
        case .jobExpiringSoon:
            return "⏰"
        case .lowRatingAlert:
            return "⚠️"
        case .withdrawalPending, .withdrawalProcessed, .topupSuccess:
            return "💳"
        case .matchingJob:
            return "🎯"
        case .jobCancelledByProvider:
            return "🚫"
        }
    }

    private var iconBackgroundColor: Color {
        switch notification.priority {
        case .high:
            return Color(UIColor(hex: "#FF3B30")).opacity(0.1)
        case .medium:
            return Color(UIColor(hex: "#FF9500")).opacity(0.1)
        case .low:
            return Color(UIColor(hex: "#34C759")).opacity(0.1)
        }
    }

    private var priorityColor: Color {
        switch notification.priority {
        case .high:
            return Color(UIColor(hex: "#FF3B30"))
        case .medium:
            return Color(UIColor(hex: "#FF9500"))
        case .low:
            return Color(UIColor(hex: "#34C759"))
        }
    }

    private var priorityBackgroundHex: String {
        switch notification.priority {
        case .high:
            return "#FF3B30"
        case .medium:
            return "#FF9500"
        case .low:
            return "#34C759"
        }
    }

    private var backgroundColor: Color {
        notification.read
            ? Color(UIColor(hex: "#F5F5F7"))
            : Color(UIColor(hex: "#FEFEFE"))
    }
}

