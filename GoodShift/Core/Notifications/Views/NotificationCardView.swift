//
//  NotificationCardView.swift
//  GoodShift
//
//  Created by Pavly Paules on 30/03/2026.
//

import SwiftUI

struct NotificationCardView: View {
	let notification: Notification
	let onTap: () -> Void
	let onMarkAsRead: () -> Void
	let onDelete: () -> Void

	@State private var isShowingDeleteConfirmation = false
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 12) {
				// MARK: - Icon & Unread Indicator
				ZStack(alignment: .topTrailing) {
					ZStack() {
						Circle()
							.fill(iconBackgroundColor)
							.frame(width: 40, height: 40)
						
						Text(iconEmoji)
							.font(.system(size: 24))
					}
					// Unread dot
					if !notification.read {
						Circle()
							.fill(Colors.swiftUIColor(.borderError))
							.frame(width: 10, height: 10)
							.offset(x: 2, y: -2)
					}
				}
				
				// MARK: - Content
				VStack(alignment: .leading, spacing: 4) {
					HStack(spacing: 8) {
						Text(notification.title)
							.font(.system(size: 14, weight: .semibold))
							.foregroundColor(Colors.swiftUIColor(.textMain))
							.lineLimit(1)
						
						Spacer()
						
						
					}
					
					Text(notification.body)
						.font(.system(size: 13, weight: .regular))
						.foregroundColor(Colors.swiftUIColor(.textSecondary))
						.lineLimit(2)
					
					// Category badge
					HStack(spacing: 12) {
						Text(notification.category.displayName)
							.font(.system(size: 11, weight: .medium))
							.foregroundColor(Colors.swiftUIColor(.primary))
							.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
							.background(
								Colors.swiftUIColor(.primary).opacity(0.1)
							)
							.cornerRadius(4)
						
						Spacer()
						
						Text(notification.timeAgo)
							.font(.system(size: 12, weight: .regular))
							.fontDesign(.monospaced)
							.foregroundColor(Colors.swiftUIColor(.textSecondary))
					}
				}
	
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
						.foregroundColor(Colors.swiftUIColor(.textSecondary))
						.font(.system(size: 18))
						.padding(.bottom)
				}
			
			}
			.padding(12)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(Colors.swiftUIColor(.appBackground))
					.strokeBorder(notification.read ?  Colors.swiftUIColor(.textSecondary) : .accent, lineWidth: notification.read ? 0 : 1)
			)
			.opacity(notification.read ? 0.6 : 1.0)
	
		}
		.contentShape(Rectangle())
		.onTapGesture { onTap() }
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
			return Colors.swiftUIColor(.borderError).opacity(0.1)
		case .medium:
			return Colors.swiftUIColor(.borderWarning).opacity(0.1)
		case .low:
			return Colors.swiftUIColor(.primary).opacity(0.1)
		}
	}
	
	private var priorityColor: Color {
		switch notification.priority {
		case .high:
			return Colors.swiftUIColor(.borderError)
		case .medium:
			return Colors.swiftUIColor(.borderWarning)
		case .low:
			return Colors.swiftUIColor(.primary)
		}
	}
	
	private var backgroundColor: Color {
		notification.read
		? Colors.swiftUIColor(.appBackground)
		: Colors.swiftUIColor(.surfaceWhite)
	}
}

// MARK: - Preview
#Preview {
	NotificationCardView(
		notification: Notification(
			userId: "user_1",
			type: .newApplicationReceived,
			title: "New Job Application",
			body: "Someone applied to your Gardening Service job. Tap here to review their profile and accept or decline.",
			priority: .high,
			category: .applications
		),
		onTap: {},
		onMarkAsRead: {},
		onDelete: {}
	)
	.padding()
	.background(Colors.swiftUIColor(.appBackground))
}

