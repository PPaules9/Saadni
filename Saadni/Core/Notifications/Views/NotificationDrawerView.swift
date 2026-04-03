//
//  NotificationDrawerView.swift
//  Saadni
//
//  Created by Pavly Paules on 30/03/2026.
//

import SwiftUI

struct NotificationDrawerView: View {
	@Environment(\.notificationsStore) var notificationsStore
	@Environment(\.dismiss) var dismiss
	@Environment(AppCoordinator.self) var appCoordinator

	let userRole: UserRole
	@State private var selectedFilter: NotificationCategory? = nil
	@State private var searchText = ""
	
	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()
			
			NavigationStack {
				VStack(spacing: 0) {
					// MARK: - Header
					HStack {
						Text("Notifications")
							.font(.system(size: 18, weight: .bold))
							.foregroundColor(Colors.swiftUIColor(.textMain))
							.fontDesign(.monospaced)
							.kerning(0.1)
						Spacer()
						
						if notificationsStore.unreadCount(for: userRole) > 0 {
							Button(action: markAllAsRead) {
								Text("Mark all as read")
									.font(.system(size: 12, weight: .semibold))
									.foregroundColor(Colors.swiftUIColor(.textMain))
							}
						}
						
						Button(action: { dismiss() }) {
							Image(systemName: "xmark.circle.fill")
								.font(.system(size: 18))
								.foregroundColor(.accentColor)
						}
					}
					.padding(12)
					Divider()
					
					// MARK: - Search & Filter
					VStack(spacing: 8) {
						// Search bar
						HStack(spacing: 8) {
							
							BrandTextField(
								hasTitle: false,
								title: "",
								placeholder: "Search notifications...",
								text: $searchText
							)
							
							
							if !searchText.isEmpty {
								Button(action: { searchText = "" }) {
									Image(systemName: "xmark.circle.fill")
										.foregroundColor(Color.accentColor)
								}
							}
						}
						.padding(8)
						.cornerRadius(8)
						
						// Category filter pills
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 8) {
								// All button
								FilterPill(
									label: "All",
									isSelected: selectedFilter == nil,
									action: { selectedFilter = nil }
								)
								
								// Category buttons (role-specific)
								ForEach(categoryFiltersForRole, id: \.self) { category in
									FilterPill(
										label: category.displayName,
										isSelected: selectedFilter == category,
										action: { selectedFilter = category }
									)
								}
							}
							.padding(.horizontal, 12)
						}
					}
					.padding(.vertical, 8)
					
					Divider()
					// MARK: - Notifications List
					if filteredNotifications.isEmpty {
						emptyState
					} else {
						ScrollView {
							LazyVStack(spacing: 8) {
								ForEach(filteredNotifications, id: \.id) { notification in
									NotificationCardView(
										notification: notification,
										onTap: {
											handleNotificationTap(notification)
										},
										onMarkAsRead: {
											Task {
												await notificationsStore.markAsRead(notification)
											}
										},
										onDelete: {
											Task {
												await notificationsStore.deleteNotification(notification)
											}
										}
									)
									.padding(.horizontal, 12)
								}
							}
							.padding(.vertical, 8)
						}
					}
					
					Spacer()
				}
			}
		}
	}
	
	// MARK: - Computed Properties
	
	var categoryFiltersForRole: [NotificationCategory] {
		switch userRole {
		case .jobSeeker:
			return [.applications, .messages, .jobs, .reviews, .earnings]
		case .provider:
			return [.applications, .messages, .jobs, .reviews, .earnings, .ratings]
		}
	}
	
	var roleSpecificNotifications: [Notification] {
		switch userRole {
		case .jobSeeker:
			// NeedWorker sees these types
			let seekerTypes: [NotificationType] = [
				.applicationStatus, .newMessageFromProvider, .jobReminder,
				.reviewPostedByProvider, .jobCancelledByProvider, .earningReceived,
				.topupSuccess, .withdrawalProcessed, .matchingJob, .applicationWithdrawnAck
			]
			return notificationsStore.notifications.filter { seekerTypes.contains($0.type) }
			
		case .provider:
			// JobProvider sees these types
			let providerTypes: [NotificationType] = [
				.newApplicationReceived, .newMessageFromSeeker, .applicationAcceptedBySeeker,
				.applicationWithdrawnBySeeker, .jobStartsSoon, .paymentReceived,
				.reviewPostedBySeeker, .jobExpiringSoon, .lowRatingAlert, .withdrawalPending
			]
			return notificationsStore.notifications.filter { providerTypes.contains($0.type) }
		}
	}
	
	var filteredNotifications: [Notification] {
		var notifications = roleSpecificNotifications
		
		// Apply category filter
		if let category = selectedFilter {
			notifications = notifications.filter { $0.category == category }
		}
		
		// Apply search filter
		if !searchText.isEmpty {
			notifications = notificationsStore.searchNotifications(query: searchText)
				.filter { note in
					roleSpecificNotifications.contains { $0.id == note.id }
				}
		}
		
		return notifications.sorted { $0.timestamp > $1.timestamp }
	}
	
	var emptyState: some View {
		VStack(spacing: 16) {
			Image(systemName: "bell")
				.resizable()
				.frame(width: 30, height: 30)
			
			
			Text(searchText.isEmpty
					 ? "You're all caught up!"
					 : "No notifications match your search")
			.font(.system(size: 14))
			.fontDesign(.monospaced)
			.foregroundColor(Colors.swiftUIColor(.textSecondary))
			.kerning(0.1)
			if !searchText.isEmpty {
				Button(action: { searchText = "" }) {
					Text("Clear search")
						.font(.system(size: 14, weight: .semibold))
						.fontDesign(.monospaced)
						.foregroundColor(Colors.swiftUIColor(.textSecondary))
						.kerning(0.1)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	// MARK: - Actions

	private func handleNotificationTap(_ notification: Notification) {
		if !notification.read {
			Task { await notificationsStore.markAsRead(notification) }
		}
		dismiss()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
			appCoordinator.handleNotificationNavigation(notification)
		}
	}

	private func markAllAsRead() {
		Task {
			await notificationsStore.markAllAsRead()
		}
	}
}

// MARK: - Filter Pill Component

struct FilterPill: View {
	let label: String
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Text(label)
				.font(.system(size: 13, weight: .semibold))
				.foregroundColor(
					isSelected
					? .white
					: Color.accentColor
				)
				.padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
				.background(
					isSelected
					? Color.accentColor
					: Color.accentColor.opacity(0.2)
				)
				.cornerRadius(16)
		}
	}
}

// MARK: - Preview

#Preview {
	let userCache = UserCache()
	let authManager = AuthenticationManager(userCache: userCache)
	let coordinator = AppCoordinator(authManager: authManager, userCache: userCache)
	return NotificationDrawerView(userRole: .jobSeeker)
		.environment(\.notificationsStore, NotificationsStore())
		.environment(coordinator)
}

