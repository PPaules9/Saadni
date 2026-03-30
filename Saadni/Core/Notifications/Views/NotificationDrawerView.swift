import SwiftUI

// MARK: - Notification Drawer View

struct NotificationDrawerView: View {
	@Environment(\.notificationsStore) var notificationsStore
	@Environment(\.dismiss) var dismiss
	
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
							.kerning(0.8)
						Spacer()
						
						if notificationsStore.unreadCount > 0 {
							Button(action: markAllAsRead) {
								Text("Mark all as read")
									.font(.system(size: 12, weight: .semibold))
									.foregroundColor(Colors.swiftUIColor(.textMain))
								.fontDesign(.monospaced)
							}
						}
						
						Button(action: { dismiss() }) {
							Image(systemName: "xmark.circle.fill")
								.font(.system(size: 18))
								.foregroundColor(.accentColor)
						}
					}
					.padding(12)
					.borderBottom(color: Color(UIColor(hex: "#E5E5EA")), width: 1)
					
					// MARK: - Search & Filter
					VStack(spacing: 8) {
						// Search bar
						HStack(spacing: 8) {
							Image(systemName: "magnifyingglass")
								.foregroundColor(.accentColor)
							
							TextField("Search notifications", text: $searchText)
								.foregroundColor(Colors.swiftUIColor(.textMain))
								.fontDesign(.monospaced)
							
							if !searchText.isEmpty {
								Button(action: { searchText = "" }) {
									Image(systemName: "xmark.circle.fill")
										.foregroundColor(Color(UIColor(hex: "#8E8E93")))
								}
							}
						}
						.padding(8)
						.background(Color(UIColor(hex: "#F5F5F7")))
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
					.background(Color(UIColor(hex: "#FEFEFE")))
					.borderBottom(color: Color(UIColor(hex: "#E5E5EA")), width: 1)
					
					// MARK: - Notifications List
					if filteredNotifications.isEmpty {
						emptyState
					} else {
						ScrollView {
							LazyVStack(spacing: 8) {
								ForEach(filteredNotifications, id: \.id) { notification in
									NotificationCardView(
										notification: notification,
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
			Text("🔔")
				.font(.system(size: 48))
			
			Text("No notifications")
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(Color(UIColor(hex: "#1C1C1E")))
			
			Text(searchText.isEmpty
					 ? "You're all caught up!"
					 : "No notifications match your search")
			.font(.system(size: 14))
			.foregroundColor(Color(UIColor(hex: "#8E8E93")))
			
			if !searchText.isEmpty {
				Button(action: { searchText = "" }) {
					Text("Clear search")
						.font(.system(size: 14, weight: .semibold))
						.foregroundColor(Color(UIColor(hex: "#37857D")))
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color(UIColor(hex: "#F5F5F7")))
	}
	
	// MARK: - Actions
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
					: Color(UIColor(hex: "#37857D"))
				)
				.padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
				.background(
					isSelected
					? Color(UIColor(hex: "#37857D"))
					: Color(UIColor(hex: "#37857D")).opacity(0.1)
				)
				.cornerRadius(16)
		}
	}
}

// MARK: - Border Bottom Modifier

extension View {
	func borderBottom(color: Color, width: CGFloat) -> some View {
		VStack(spacing: 0) {
			self
			color
				.frame(height: width)
		}
	}
}

// MARK: - Preview

#Preview {
	NotificationDrawerView(userRole: .jobSeeker)
		.environment(\.notificationsStore, NotificationsStore())
}
