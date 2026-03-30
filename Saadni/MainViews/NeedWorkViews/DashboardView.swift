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
 @State private var selectedDateForShift: Date?
 @State private var navigateToBrowseJobs: Bool = false
 @State private var calendarSelection: Date = Date()
 @State private var isCalendarVisible: Bool = false
	@State private var viewModel: ProfileViewModel?
 @Environment(ServicesStore.self) var servicesStore
 @Environment(\.notificationsStore) var notificationsStore

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
   
   NavigationStack {
    ScrollView {
     VStack(spacing: 0) {
      // Dashboard Header (Toolbar)
      DashboardHeaderView(showNotificationDrawer: $showNotificationDrawer)
       .padding(.horizontal, 20)
       .padding(.vertical, 16)
      
      // Shift-Picker Calendar
      ShiftPickerCalendarView { date in
       selectedDateForShift = date
       navigateToBrowseJobs = true
      }
      .padding(.bottom, 24)
      
      // Full Calendar Picker
      VStack(alignment: .leading, spacing: 12) {
				HStack {
					Text("Pick from calendar")
						.font(.subheadline)
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
       
				if isCalendarVisible {
					CustomCalendarWithJobIndicators(
						selectedDate: $calendarSelection,
						jobDates: jobDates,
						onDateSelected: { date in
							selectedDateForShift = date
							navigateToBrowseJobs = true
						}
					)
					.padding(.horizontal, 20)
				}
      }
      .padding(.bottom, 24)
      
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
    .navigationDestination(isPresented: $navigateToBrowseJobs) {
     if let date = selectedDateForShift {
      BrowseJobs(selectedDate: date)
     }
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
 let upcomingDates: [Date]
 let action: (Date) -> Void
 
 init(action: @escaping (Date) -> Void) {
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
   Text("Available Shifts Near You")
    .font(.headline)
    .foregroundStyle(.primary)
    .fontDesign(.monospaced)
    .kerning(-1)
    .padding(.horizontal, 20)
   
   ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 12) {
     ForEach(upcomingDates, id: \.self) { date in
      Button(action: {
       action(date)
      }) {
       VStack(spacing: 8) {
        Text(isToday(date) ? "Today" : isTomorrow(date) ? "Tmrw" : getDayOfWeek(date))
         .font(.caption)
         .fontWeight(.semibold)
         .foregroundStyle(isToday(date) ? .white : Colors.swiftUIColor(.textSecondary))
        
        Text(getDayNumber(date))
         .font(.title2)
         .fontWeight(.bold)
         .foregroundStyle(isToday(date) ? .white : Colors.swiftUIColor(.textMain))
       }
       .frame(width: 70, height: 80)
       .background(isToday(date) ? Color.accentColor : Colors.swiftUIColor(.textPrimary))
       .cornerRadius(16)
       .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
      }
      .buttonStyle(.plain)
     }
    }
    .padding(.horizontal, 20)
   }
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
                    .foregroundStyle(.primary)
                    .fontDesign(.monospaced)
                    .kerning(-1)
            }
     Text("Find your next Job")
      .font(.caption)
      .foregroundStyle(.secondary)
      .fontDesign(.monospaced)
      .kerning(-1)

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

      if notificationsStore.unreadCount > 0 {
       ZStack {
        Circle()
         .fill(Color(UIColor(hex: "#FF3B30")))

        Text(notificationsStore.unreadCount > 99 ? "99+" : "\(notificationsStore.unreadCount)")
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
 @State private var navigateToFeaturedService = false
 @State private var navigateToNewService = false
 @State private var featuredService: JobService?
 @State private var newService: JobService?

 var body: some View {
  VStack(spacing: 16) {
   TabView(selection: $currentIndex) {
    if let featured = featuredService {
     CarouselCard(
      title: "Featured Services",
      subtitle: "Get extra cash",
      provider: "",
      price: "Up to 10%",
      onTapAction: {
       navigateToFeaturedService = true
      }
     )
     .tag(0)
    }

    CarouselCard(
     title: "Top Rated Users",
     subtitle: "5★ rated by customers",
     provider: "",
     price: "Popular",
     onTapAction: {}
    )
     .tag(1)

    if let new = newService {
     CarouselCard(
      title: "New Services",
      subtitle: "Discover what's new",
      provider: "",
      price: "New",
      onTapAction: {
       navigateToNewService = true
      }
     )
     .tag(2)
    }
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
  .padding(.horizontal, 20)
  .onAppear {
   featuredService = JobService.sampleData.randomElement()
   newService = JobService.sampleData.filter { Calendar.current.isDateInToday($0.createdAt) }.randomElement() ?? JobService.sampleData.randomElement()
  }
  .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
   withAnimation {
    currentIndex = (currentIndex + 1) % 3
   }
  }
 }
}


// MARK: - Earnings View
struct EarningsView: View {
 @State private var totalEarnings: Double = 250
 @Binding var showWalletSheet: Bool
 
 var body: some View {
  HStack() {
   VStack(alignment: .leading, spacing: 4){
    Text("Your Wallet")
     .font(.subheadline)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
     .fontDesign(.monospaced)
     .kerning(-1)
    
    Text("Earnings per month")
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
 }
}


// MARK: - Recent Activity View
struct RecentActivityView: View {
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Text("Recent Activity")
     .font(.headline)
     .foregroundStyle(.primary)
     .fontDesign(.monospaced)
     .kerning(-1)

    Spacer()

    Button(action: {}) {
     Text("See All")
      .font(.subheadline)
      .foregroundStyle(.accent)
      .fontDesign(.monospaced)
      .kerning(-0.5)
    }
   }

   VStack(spacing: 12) {
    ForEach(JobService.sampleActivities) { activity in
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


#Preview {
    let userCache = UserCache()
    let authManager = AuthenticationManager(userCache: userCache)

 DashboardView()
        .environment(UserCache())
        .environment(authManager)
}
