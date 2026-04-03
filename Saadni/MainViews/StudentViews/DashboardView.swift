//
//  DashboardView.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//
import SwiftUI
internal import Combine

struct DashboardView: View {
 @State private var currentCarouselIndex: Int = 0
 @State private var showWalletSheet: Bool = false
 @State private var showNotificationDrawer: Bool = false
 @State private var calendarSelection: Date = Date()
 @State private var isCalendarVisible: Bool = false

 @Environment(ServicesStore.self) var servicesStore
 @Environment(\.notificationsStore) var notificationsStore
 @Environment(StudentCoordinator.self) var coordinator

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
			 DashboardHeaderView(showNotificationDrawer: $showNotificationDrawer)
				 .padding(.horizontal, 20)
				 .padding(.vertical, 16)
			 
			 VStack{
			 // Shift-Picker Calendar
			 ShiftPickerCalendarView(isCalendarVisible: $isCalendarVisible) { date in
				 coordinator.filterDate = date
				 coordinator.selectTab(.search)
			 }
			 
			 if isCalendarVisible {
				 CustomCalendarWithJobIndicators(
					selectedDate: $calendarSelection,
					jobDates: jobDates,
					onDateSelected: { date in
						coordinator.filterDate = date
						coordinator.selectTab(.search)
					}
				 )
				 .padding(.horizontal, 20)
				 .padding(.vertical)
			 }
		 }
				.padding(.bottom)

     // Carousel Section
     JobStatusCarouselView(currentIndex: $currentCarouselIndex)
      .padding(.bottom, 24)

     // Earnings Section
     EarningsView(showWalletSheet: $showWalletSheet)
      .padding(.horizontal, 20)
      .padding(.bottom, 32)

     // Recent Activity Section
     RecentActivityView()
      .padding(.horizontal, 20)
      .padding(.vertical, 32)
    }
   }
  }
  .sheet(isPresented: $showWalletSheet) {
   WalletSheet()
  }
  .sheet(isPresented: $showNotificationDrawer) {
   NotificationDrawerView(userRole: .jobSeeker)
  }
  .refreshable {
   // Manual refresh: listeners update data automatically, but users can pull-to-refresh
   try? await Task.sleep(nanoseconds: 500_000_000) // Brief pause for UX
  }
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
       .cornerRadius(14)
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
 
 private func getDayOfWeek(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEE"
  return formatter.string(from: date)
 }
 
 private func getDayNumber(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "d"
  return formatter.string(from: date)
 }
}


// MARK: - Dashboard Header View
struct DashboardHeaderView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.notificationsStore) var notificationsStore
    @Binding var showNotificationDrawer: Bool

 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack {
    VStack(alignment: .leading, spacing: 4) {
            if let user = authManager.currentUser {
                Text("Hi, \(user.displayName ?? "User")")
                    .font(.headline)
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .fontDesign(.monospaced)
                    .kerning(-1)
            }
//     Text("Find your next Job")
//      .font(.caption)
//      .foregroundStyle(.secondary)
//      .fontDesign(.monospaced)
//      .kerning(-1)
//     if let user = authManager.currentUser,
//        let defaultId = user.defaultAddressId,
//        let defaultAddress = user.savedAddresses?.first(where: { $0.id == defaultId }) {
//      HStack(spacing: 4) {
//       Image(systemName: "mappin.circle.fill")
//        .font(.caption2)
//        .foregroundStyle(Color.accent)
//       Text(defaultAddress.label.isEmpty ? defaultAddress.address : defaultAddress.label)
//        .font(.caption2)
//        .fontWeight(.medium)
//        .foregroundStyle(Color.accent)
//        .fontDesign(.monospaced)
//        .kerning(-0.5)
//      }
//     }

    }

    Spacer()

    HStack(spacing: 12) {
     Button(action: {}) {
      Image(systemName: "magnifyingglass")
       .font(.system(size: 18, weight: .semibold))
       .foregroundStyle(.primary)
     }

     ZStack(alignment: .topTrailing) {
      Button(action: { showNotificationDrawer = true }) {
       Image(systemName: "bell.fill")
        .font(.system(size: 18, weight: .semibold))
        .foregroundStyle(.primary)
      }

      if notificationsStore.unreadCount(for: .jobSeeker) > 0 {
       ZStack {
        Circle()
         .fill(Color(UIColor(hex: "#FF3B30")))

        Text(notificationsStore.unreadCount(for: .jobSeeker) > 99 ? "99+" : "\(notificationsStore.unreadCount(for: .jobSeeker))")
         .font(.system(size: 10, weight: .bold))
         .foregroundColor(.white)
       }
       .frame(width: 20, height: 20)
       .offset(x: 8, y: -8)
      }
     }
    }
   }
		Divider()
  }
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
   withAnimation {
    currentIndex = (currentIndex + 1) % 3
   }
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
  @Binding var showWalletSheet: Bool
 @Environment(ServicesStore.self) var servicesStore
 @Environment(AuthenticationManager.self) var authManager
 @State private var completedServices: [JobService] = []

 private var totalEarnings: Double {
  completedServices.reduce(0) { $0 + $1.price }
 }

 var body: some View {
  HStack() {
   VStack(alignment: .leading, spacing: 4){
    Text("Your Wallet")
     .font(.subheadline)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
     .fontDesign(.monospaced)
     .kerning(-1)

    Text("Total Earnings")
     .font(.caption)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
     .fontDesign(.monospaced)
     .kerning(-1)

   }
   Spacer()
   HStack(alignment: .center, spacing: 0) {
    Text("EGP ")
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
  .onTapGesture {
   showWalletSheet = true
  }
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
 @State private var showAllActivities = false

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

    Button(action: { showAllActivities = true }) {
     Text("See All")
      .font(.subheadline)
      .foregroundStyle(.accent)
      .fontDesign(.monospaced)
      .kerning(-0.5)
    }
   }
   .sheet(isPresented: $showAllActivities) {
    AllActivitiesView()
     .environment(servicesStore)
     .environment(applicationsStore)
     .environment(dashboardVM)
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


#Preview {
    let userCache = UserCache()
    let authManager = AuthenticationManager(userCache: userCache)

 DashboardView()
        .environment(UserCache())
        .environment(authManager)
        .environment(ServicesStore())
        .environment(ApplicationsStore())
        .environment(NotificationsStore())
        .environment(StudentCoordinator())
        .environment(DashboardViewModel())
}
