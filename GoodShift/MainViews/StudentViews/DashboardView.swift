//
//  DashboardView.swift
//  GoodShift
//
//  Created by Pavly Paules on 25/02/2026.
//
import SwiftUI
internal import Combine

struct DashboardView: View {
	@State private var dashboardViewModel = DashboardViewModel()
	@State private var currentCarouselIndex: Int = 0
	@State private var calendarSelection: Date = Date()
	@State private var isCalendarVisible: Bool = false
	@State private var markDoneService: JobService?
	@State private var markedDoneIds: Set<String> = []
	@State private var calendarAddedIds: Set<String> = []
	@State private var calendarError: String?
	@State private var showCalendarError: Bool = false
	@State private var calendarSuccessEvent: CalendarSuccessInfo?

	@Environment(ServicesStore.self) var servicesStore
	@Environment(ApplicationsStore.self) var applicationsStore
	@Environment(ConversationsStore.self) var conversationsStore
	@Environment(\.notificationsStore) var notificationsStore
	@Environment(ServiceProviderCoordinator.self) var coordinator

	/// The active hired job (accepted + service is active), if any
	var activeJob: (application: JobApplication, service: JobService)? {
		let serviceMap = Dictionary(
			servicesStore.services.map { ($0.id, $0) },
			uniquingKeysWith: { first, _ in first }
		)
		guard let app = applicationsStore.myApplications.first(where: {
			$0.status == .accepted &&
			serviceMap[$0.serviceId]?.status == .active
		}), let service = serviceMap[app.serviceId] else { return nil }
		return (app, service)
	}

	var jobDates: Set<DateComponents> {
		Set(servicesStore.services.compactMap { service in
			guard let serviceDate = service.serviceDate else { return nil }
			return Calendar.current.dateComponents([.year, .month, .day], from: serviceDate)
		})
	}

	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()

			ScrollView {
				VStack(spacing: 0) {
					// Dashboard Header (Toolbar)
					DashboardHeaderView()

					// Active job banner — shown only when hired
					if let job = activeJob {
						ActiveJobBannerView(
							service: job.service,
							markedDoneIds: $markedDoneIds,
							calendarAddedIds: $calendarAddedIds,
							onNavigateToDetail: { coordinator.navigate(to: .serviceDetail(job.service)) },
							onMarkDone: { markDoneService = job.service },
							onCalendarSuccess: { info in calendarSuccessEvent = info },
							onCalendarError: { msg in
								calendarError = msg
								showCalendarError = true
							}
						)
						.padding(.horizontal, 16)
						.padding(.bottom, 12)
					} else {
						
						VStack{
							// Shift-Picker Calendar
							ShiftPickerCalendarView(isCalendarVisible: $isCalendarVisible) { date in
								coordinator.presentSheet(.filteredServices(filter: .byDate(date)))
							}

							if isCalendarVisible {
								CustomCalendarWithJobIndicators(
									selectedDate: $calendarSelection,
									jobDates: jobDates,
									onDateSelected: { date in
										coordinator.presentSheet(.filteredServices(filter: .byDate(date)))
									}
								)
								.padding(.horizontal, 20)
								.padding(.vertical)
							}
						}
						.padding(.vertical)
						
						
						// Carousel Section
						JobStatusCarouselView(currentIndex: $currentCarouselIndex)
							.padding(.bottom, 24)
						
						
					}
					

					
					// Earnings Section
//					EarningsView(onWalletTap: { coordinator.presentSheet(.walletSheet) })
					EarningsView()
						.padding(.horizontal, 20)
						.padding(.bottom, 32)
					
					// Recent Activity Section
					RecentActivityView()
						.padding(.horizontal, 20)
						.padding(.vertical, 32)
				}
			}

			// Calendar success toast
			VStack {
				if let info = calendarSuccessEvent {
					CalendarSuccessToast(info: info)
						.padding(.horizontal, 20)
						.padding(.top, 12)
						.transition(.move(edge: .top).combined(with: .opacity))
				}
				Spacer()
			}
			.animation(.spring(duration: 0.4), value: calendarSuccessEvent?.id)
			.allowsHitTesting(false)
		}
		.sheet(item: $markDoneService) { service in
			MarkJobDoneView(service: service, onSuccess: { markedDoneIds.insert(service.id) })
				.environment(applicationsStore)
		}
		.alert("Calendar", isPresented: $showCalendarError) {
			Button("OK", role: .cancel) {}
		} message: {
			Text(calendarError ?? "Something went wrong.")
		}
		.onChange(of: calendarSuccessEvent?.id) {
			guard calendarSuccessEvent != nil else { return }
			Task {
				try? await Task.sleep(nanoseconds: 3_000_000_000)
				withAnimation(.easeOut(duration: 0.3)) {
					calendarSuccessEvent = nil
				}
			}
		}
		.refreshable {
			// Manual refresh: listeners update data automatically, but users can pull-to-refresh
			try? await Task.sleep(for: .milliseconds(500)) // Brief pause for UX
		}
		.environment(dashboardViewModel)
	}

}

// MARK: - Shift Picker Calendar View
struct ShiftPickerCalendarView: View {
	@Binding var isCalendarVisible: Bool
	let upcomingDates: [Date]
	let action: (Date) -> Void
	
	init(isCalendarVisible: Binding<Bool>, action: @escaping (Date) -> Void) {
		self._isCalendarVisible = isCalendarVisible
		self.action = action
		// Generate next 14 days
		var dates: [Date] = []
		let calendar = Calendar.current
		for i in 0..<14 {
			if let date = calendar.date(byAdding: .day, value: i, to: Date()) {
				dates.append(date)
			}
		}
		self.upcomingDates = dates
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack{
				Text("Work on a Shift")
					.font(.headline)
					.foregroundStyle(.primary)
					.fontDesign(.monospaced)
					.kerning(-1)
					.padding(.horizontal, 20)
				
				Spacer()
				Toggle("", isOn: $isCalendarVisible.animation(.easeInOut))
					.labelsHidden()
					.tint(.accent)
					.padding(.trailing, 20)
			}
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 8) {
					ForEach(upcomingDates, id: \.self) { date in
						Button(action: {
							action(date)
						}) {
							VStack(spacing: 4) {
								Text(isToday(date) ? "Today" : isTomorrow(date) ? "Tmrw" : getDayOfWeek(date))
									.font(.caption)
									.fontWeight(.semibold)
									.foregroundStyle(isToday(date) ? .white : Colors.swiftUIColor(.textSecondary))
								
								Text(getDayNumber(date))
									.font(.title2)
									.fontWeight(.bold)
									.foregroundStyle(isToday(date) ? .white : Colors.swiftUIColor(.textMain))
							}
							.frame(width: 70, height: 70)
							.background(isToday(date) ? Color.accentColor : Colors.swiftUIColor(.textPrimary))
							.cornerRadius(15)
							.shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
						}
						.buttonStyle(.plain)
					}
				}
				.padding(.horizontal, 18)
			}
			.padding(.vertical)
		}
	}
	
	private func isToday(_ date: Date) -> Bool {
		Calendar.current.isDateInToday(date)
	}
	
	private func isTomorrow(_ date: Date) -> Bool {
		Calendar.current.isDateInTomorrow(date)
	}
	
	private static let dayOfWeekFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "EEE"
		return f
	}()

	private static let dayNumberFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "d"
		return f
	}()

	private func getDayOfWeek(_ date: Date) -> String {
		ShiftPickerCalendarView.dayOfWeekFormatter.string(from: date)
	}

	private func getDayNumber(_ date: Date) -> String {
		ShiftPickerCalendarView.dayNumberFormatter.string(from: date)
	}
}


// MARK: - Dashboard Header View
struct DashboardHeaderView: View {
	@Environment(AuthenticationManager.self) var authManager
	@Environment(\.notificationsStore) var notificationsStore
	@Environment(ServiceProviderCoordinator.self) var coordinator
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				HStack(spacing: 8) {
					
					if let user = authManager.currentUser {
						Image(systemName: "person.crop.circle")
							.resizable()
							.frame(width: 32, height: 32)
							.clipShape(Circle())
							.overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round)))
						Text("Hello, \(user.displayName ?? "User")")
							.font(.title2 )
							.bold()
							.foregroundStyle(.white)
							.kerning(0.2)
					}
					
					
				}
				
				Spacer()
				
				HStack(spacing: 8) {
//					Button(action: {}) {
//						Image(systemName: "magnifyingglass")
//							.font(.system(size: 18, weight: .semibold))
//							.foregroundStyle(.white)
//					}
//					.frame(minWidth: 44, minHeight: 44)
//					.accessibilityLabel("Search")

					ZStack(alignment: .topTrailing) {
						Button(action: { coordinator.presentSheet(.notificationDrawer(role: .jobSeeker)) }) {
							Image(systemName: "bell.fill")
								.font(.system(size: 18, weight: .semibold))
								.foregroundStyle(.white)
						}
						.frame(minWidth: 44, minHeight: 44)
						.accessibilityLabel(
							notificationsStore.unreadCount(for: .jobSeeker) > 0
							? "Notifications, \(notificationsStore.unreadCount(for: .jobSeeker)) unread"
							: "Notifications"
						)

						if notificationsStore.unreadCount(for: .jobSeeker) > 0 {
							ZStack {
								Circle()
									.fill(Color.red)

								Text(notificationsStore.unreadCount(for: .jobSeeker) > 99 ? "99+" : "\(notificationsStore.unreadCount(for: .jobSeeker))")
									.font(.system(size: 10, weight: .bold))
									.foregroundColor(.white)
							}
							.frame(width: 20, height: 20)
							.offset(x: 8, y: -8)
							.accessibilityHidden(true) // count already in the button label above
						}
					}
				}
			}
			.padding(.horizontal)
		}
		.padding(.vertical)
		.background(
			Color.accentColor
				.padding(.top, -500)
				.ignoresSafeArea(edges: .top)
		)
		.padding(.bottom)
		
	}
}


// MARK: - Job Status Carousel View
struct JobStatusCarouselView: View {
	@Binding var currentIndex: Int
	@Environment(ServicesStore.self) var servicesStore
	@State private var navigateToFeaturedService = false
	@State private var navigateToNewService = false
	@State private var featuredService: JobService? = nil
	@State private var newService: JobService? = nil
	/// Pauses auto-scroll when the user taps a card — resumes on next tick
	@State private var isAutoScrollPaused = false
	
	var body: some View {
		VStack(spacing: 16) {
			TabView(selection: $currentIndex) {
				Group {
					if let featured = featuredService {
						CarouselCard(
							title: featured.title,
							subtitle: "Get extra cash",
							provider: "",
							carouselImage: featured.image,
							price: featured.formattedPrice,
							colorBanner: .orange,
							onTapAction: { navigateToFeaturedService = true }
						)
					} else {
						CarouselCardSkeleton()
					}
				}
				.tag(0)
				
				CarouselCard(
					title: "Top Rated Users",
					subtitle: "5★ rated by customers",
					provider: "",
					carouselImage: ServiceImage(assetName: "foodDelivery"),
					price: "Popular", colorBanner: .green,
					onTapAction: {}
				)
				.tag(1)
				
				Group {
					if let new = newService {
						CarouselCard(
							title: new.title,
							subtitle: "Discover what's new",
							provider: "",
							carouselImage: new.image,
							price: new.formattedPrice,
							colorBanner: .yellow,
							onTapAction: { navigateToNewService = true }
						)
					} else {
						CarouselCardSkeleton()
					}
				}
				.tag(2)
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.navigationDestination(isPresented: $navigateToFeaturedService) {
				if let featured = featuredService {
					ServiceDetailView(service: featured)
				}
			}
			.navigationDestination(isPresented: $navigateToNewService) {
				if let new = newService {
					ServiceDetailView(service: new)
				}
			}
			.frame(height: 220)
			.cornerRadius(16)
			
			
			// Carousel Indicators
			HStack(spacing: 6) {
				ForEach(0..<3, id: \.self) { index in
					Circle()
						.fill(index == currentIndex ? Color.accent : Color.gray.opacity(0.3))
						.frame(width: 8, height: 8)
				}
			}
			.padding(.bottom, 12)
		}
		.padding(.horizontal, 8)
		.onAppear {
			updateCarouselServices()
		}
		.onChange(of: servicesStore.services) {
			if featuredService == nil || newService == nil {
				updateCarouselServices()
			}
		}
		.onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
			guard !isAutoScrollPaused else {
				// Resume after one skipped tick
				isAutoScrollPaused = false
				return
			}
			withAnimation {
				currentIndex = (currentIndex + 1) % 3
			}
		}
		// Pause auto-scroll when user manually swipes
		.onChange(of: currentIndex) {
			isAutoScrollPaused = true
		}
	}
	
	private func updateCarouselServices() {
		let services = servicesStore.services
		guard !services.isEmpty else { return }
		featuredService = services.filter { $0.isFeatured }.randomElement()
		newService = services.filter { $0.isNew }.randomElement()
	}
}


// MARK: - Carousel Skeleton
struct CarouselCardSkeleton: View {
	@State private var isAnimating = false
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			RoundedRectangle(cornerRadius: 16)
				.fill(Color(.systemGray5))
			
			VStack(alignment: .leading, spacing: 10) {
				RoundedRectangle(cornerRadius: 6)
					.fill(Color(.systemGray4))
					.frame(width: 160, height: 20)
				RoundedRectangle(cornerRadius: 4)
					.fill(Color(.systemGray4))
					.frame(width: 100, height: 14)
				Spacer()
				RoundedRectangle(cornerRadius: 4)
					.fill(Color(.systemGray4))
					.frame(width: 80, height: 18)
			}
			.padding(16)
		}
		.frame(height: 220)
		.opacity(isAnimating ? 0.5 : 1)
		.animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isAnimating)
		.onAppear { isAnimating = true }
	}
}

// MARK: - Earnings View
struct EarningsView: View {
//	let onWalletTap: () -> Void
	@Environment(ServicesStore.self) var servicesStore
	@Environment(AuthenticationManager.self) var authManager
	@State private var completedServices: [JobService] = []
	@AppStorage(AppConstants.Storage.appCurrency) private var appCurrency: String = "EGP"
	private var currencySymbol: String { Currency(rawValue: appCurrency)?.symbol ?? appCurrency }
	
	private var totalEarnings: Double {
		completedServices.reduce(0) { $0 + $1.price }
	}
	
	var body: some View {
		HStack() {
			VStack(alignment: .leading, spacing: 4){
				Text("Total Earnings")
					.font(.subheadline)
					.foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
					.fontDesign(.monospaced)
					.kerning(-1)
				
				Text("This Month")
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
					.fontDesign(.monospaced)
					.kerning(-1)
				
			}
			Spacer()
			HStack(alignment: .center, spacing: 0) {
				Text("\(currencySymbol) ")
					.font(.system(size: 30, weight: .bold))
					.foregroundStyle(.secondary)
					.fontDesign(.monospaced)
					.kerning(-1)
				
				Text(String(format: "%.0f", totalEarnings))
					.font(.system(size: 30, weight: .bold))
					.foregroundStyle(.primary)
					.fontDesign(.monospaced)
					.kerning(-1)
				
			}
		}
		.padding(16)
		.background(Color.accent)
		.cornerRadius(12)
//		.onTapGesture {
//			onWalletTap()
//		}
		.task {
			guard let userId = authManager.currentUser?.id else { return }
			let all = await servicesStore.fetchCompletedServices(userId: userId)
			completedServices = all.filter { $0.hiredApplicantId == userId }
		}
	}
}


// MARK: - Recent Activity View
struct RecentActivityView: View {
	@Environment(ServicesStore.self) var servicesStore
	@Environment(ApplicationsStore.self) var applicationsStore
	@Environment(DashboardViewModel.self) var dashboardVM
	@Environment(ServiceProviderCoordinator.self) var coordinator
	
	private var activities: [ServiceActivity] {
		dashboardVM.recentActivities(
			applications: applicationsStore.myApplications,
			services: servicesStore.services,
			limit: 4
		)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack {
				Text("Recent Activity")
					.font(.headline)
					.foregroundStyle(.primary)
					.fontDesign(.monospaced)
					.kerning(-1)
				
				Spacer()
				
				Button(action: { coordinator.presentSheet(.allActivities) }) {
					Text("See All")
						.font(.subheadline)
						.foregroundStyle(.accent)
						.fontDesign(.monospaced)
						.kerning(-0.5)
				}
			}
			
			if activities.isEmpty {
				Text("No activity yet — apply to a job to get started.")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.fontDesign(.monospaced)
					.kerning(-0.5)
					.multilineTextAlignment(.center)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 20)
			} else {
				VStack(spacing: 12) {
					ForEach(activities) { activity in
						HomeActivityCard(
							title: activity.activityType.rawValue,
							serviceName: activity.service.title,
							status: activity.status,
							extraDetails: activity.extraDetails,
							isHighlighted: activity.isHighlighted
						)
					}
				}
			}
		}
	}
}


// MARK: - Calendar Success Model

struct CalendarSuccessInfo: Identifiable {
	let id = UUID()
	let serviceTitle: String
	let serviceDate: Date
}

// MARK: - Calendar Success Toast

struct CalendarSuccessToast: View {
	let info: CalendarSuccessInfo

	var body: some View {
		HStack(spacing: 14) {
			ZStack {
				Circle()
					.fill(Color.green.opacity(0.15))
					.frame(width: 44, height: 44)
				Image(systemName: "calendar.badge.checkmark")
					.font(.system(size: 20, weight: .semibold))
					.foregroundStyle(.green)
			}

			VStack(alignment: .leading, spacing: 2) {
				Text("Added to Calendar")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
				Text(info.serviceTitle)
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					.lineLimit(1)
				Text(info.serviceDate.formatted(date: .abbreviated, time: .shortened))
					.font(.caption2)
					.foregroundStyle(.green)
			}

			Spacer()

			Image(systemName: "checkmark.circle.fill")
				.foregroundStyle(.green)
				.font(.title3)
		}
		.padding(14)
		.background(.regularMaterial)
		.cornerRadius(16)
		.shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
	}
}

// MARK: - Active Job Banner View
struct ActiveJobBannerView: View {
	let service: JobService
	@Binding var markedDoneIds: Set<String>
	@Binding var calendarAddedIds: Set<String>
	let onNavigateToDetail: () -> Void
	let onMarkDone: () -> Void
	let onCalendarSuccess: (CalendarSuccessInfo) -> Void
	let onCalendarError: (String) -> Void

	private var alreadyMarkedDone: Bool { markedDoneIds.contains(service.id) }
	private var alreadyAddedToCalendar: Bool { calendarAddedIds.contains(service.id) }

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {

			// Tappable area: header + service details
			Button(action: onNavigateToDetail) {
				VStack(alignment: .leading, spacing: 12) {
					// Header row
					HStack(spacing: 8) {
						Image(systemName: "briefcase.fill")
							.font(.caption)
							.foregroundStyle(.white)
						Text("You're Hired")
							.font(.caption)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
						Spacer()
						Text(service.formattedPrice)
							.font(.caption)
							.fontWeight(.bold)
							.fontDesign(.monospaced)
							.foregroundStyle(.white.opacity(0.9))
						Image(systemName: "chevron.right")
							.font(.caption)
							.foregroundStyle(.white.opacity(0.7))
					}
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(Color.green)
					.cornerRadius(10, corners: [.topLeft, .topRight])

					// Service details
					VStack(alignment: .leading, spacing: 6) {
						Text(service.title)
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
							.lineLimit(2)

						HStack(spacing: 12) {
							if let name = service.providerName {
								HStack(spacing: 4) {
									Image(systemName: "person.fill")
										.font(.caption2)
									Text(name)
										.font(.caption)
								}
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							}

							HStack(spacing: 4) {
								Image(systemName: "mappin.and.ellipse")
									.font(.caption2)
								Text(service.location.name)
									.font(.caption)
									.lineLimit(1)
							}
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						}

						if let serviceDate = service.serviceDate {
							HStack(spacing: 4) {
								Image(systemName: "calendar")
									.font(.caption2)
								Text(serviceDate.formatted(date: .abbreviated, time: .shortened))
									.font(.caption)
							}
							.foregroundStyle(.accent)
						}
					}
					.padding(.horizontal, 12)
				}
			}
			.buttonStyle(.plain)

			Divider()
				.padding(.horizontal, 12)

			// Action buttons
			HStack(spacing: 10) {
				Button(action: alreadyMarkedDone ? {} : onMarkDone) {
					HStack(spacing: 6) {
						Image(systemName: "checkmark.circle.fill")
						Text(alreadyMarkedDone ? "Done" : "Mark as Done")
							.fontWeight(.semibold)
					}
					.font(.subheadline)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 10)
					.background(alreadyMarkedDone ? Color.green.opacity(0.08) : Color.green)
					.foregroundColor(alreadyMarkedDone ? Color.green.opacity(0.5) : .white)
					.cornerRadius(10)
				}
				.disabled(alreadyMarkedDone)
				.buttonStyle(.plain)

				if service.serviceDate != nil {
					Button {
						Task {
							guard let serviceDate = service.serviceDate else { return }
							do {
								try await CalendarService.shared.addJobEvent(
									title: service.title,
									startDate: serviceDate,
									durationHours: service.estimatedDurationHours,
									location: service.location.name,
									notes: service.description
								)
								calendarAddedIds.insert(service.id)
								onCalendarSuccess(CalendarSuccessInfo(
									serviceTitle: service.title,
									serviceDate: serviceDate
								))
							} catch {
								onCalendarError(error.localizedDescription)
							}
						}
					} label: {
						HStack(spacing: 6) {
							Image(systemName: alreadyAddedToCalendar ? "calendar.badge.checkmark" : "calendar.badge.plus")
							Text(alreadyAddedToCalendar ? "Added" : "Calendar")
								.fontWeight(.semibold)
						}
						.font(.subheadline)
						.frame(maxWidth: .infinity)
						.padding(.vertical, 10)
						.background(alreadyAddedToCalendar ? Color.blue.opacity(0.08) : Color.blue.opacity(0.15))
						.foregroundColor(alreadyAddedToCalendar ? Color.blue.opacity(0.5) : .blue)
						.cornerRadius(10)
					}
					.buttonStyle(.plain)
					.disabled(alreadyAddedToCalendar)
				}
			}
			.padding(.horizontal, 12)
			.padding(.bottom, 12)
		}
		.background()
		.cornerRadius(12)
		.shadow(color: Color.green.opacity(0.15), radius: 8, x: 0, y: 4)
	}
}

// Helper for per-corner rounding
extension View {
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

private struct RoundedCorner: Shape {
	var radius: CGFloat
	var corners: UIRectCorner

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius)
		)
		return Path(path.cgPath)
	}
}

#Preview {
	let userCache = UserCache()
	let authManager = AuthenticationManager(userCache: userCache)
	
	DashboardView()
		.environment(UserCache())
		.environment(authManager)
		.environment(ServicesStore())
		.environment(ApplicationsStore())
		.environment(NotificationsStore())
		.environment(ServiceProviderCoordinator())
		.environment(DashboardViewModel())
}
