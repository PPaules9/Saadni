import Foundation

// MARK: - Service Time Filter

enum ServiceTimeFilter: Hashable {
    case thisWeek
    case tomorrow
    case nextTwoWeeks
    case thisMonth
    case nextMonth
    case byDate(Date)
    case byTag(String)
    case all

    /// Human-readable title for navigation bar
    var displayTitle: String {
        switch self {
        case .thisWeek:     return "This Week"
        case .tomorrow:     return "Tomorrow"
        case .nextTwoWeeks: return "Next Two Weeks"
        case .thisMonth:    return "This Month"
        case .nextMonth:    return "Next Month"
        case .byDate(let d): return d.formatted(date: .abbreviated, time: .omitted)
        case .byTag(let t): return t
        case .all:          return "All Services"
        }
    }

    /// The date range this filter covers, nil means no date filter (show all / tag only).
    /// Uses guard let instead of force unwraps — Calendar.date(byAdding:) can theoretically
    /// return nil on unusual locale/timezone edge cases, which would otherwise crash the app.
    var dateRange: ClosedRange<Date>? {
        let cal = Calendar.current
        let now = Date()
        switch self {
        case .tomorrow:
            guard let tomorrow = cal.date(byAdding: .day, value: 1, to: now),
                  let end = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: tomorrow))
            else { return nil }
            return cal.startOfDay(for: tomorrow)...end

        case .thisWeek:
            let start = cal.startOfDay(for: now)
            guard let end = cal.date(byAdding: .day, value: 7, to: start) else { return nil }
            return start...end

        case .nextTwoWeeks:
            let start = cal.startOfDay(for: now)
            guard let end = cal.date(byAdding: .day, value: 14, to: start) else { return nil }
            return start...end

        case .thisMonth:
            let comps = cal.dateComponents([.year, .month], from: now)
            guard let start = cal.date(from: comps),
                  let end = cal.date(byAdding: .month, value: 1, to: start)
            else { return nil }
            return start...end

        case .nextMonth:
            let comps = cal.dateComponents([.year, .month], from: now)
            guard let thisMonthStart = cal.date(from: comps),
                  let start = cal.date(byAdding: .month, value: 1, to: thisMonthStart),
                  let end = cal.date(byAdding: .month, value: 1, to: start)
            else { return nil }
            return start...end

        case .byDate(let d):
            let start = cal.startOfDay(for: d)
            guard let end = cal.date(byAdding: .day, value: 1, to: start) else { return nil }
            return start...end

        case .byTag, .all:
            return nil
        }
    }

    /// serviceTag to filter on, nil means no tag filter
    var tag: String? {
        if case .byTag(let t) = self { return t }
        return nil
    }
}

enum JobSeekerTab: String, CaseIterable {
    case dashboard
    case chat
    case myJobs
    case profile

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .chat: return "Chat"
        case .myJobs: return "My Jobs"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "house"
        case .chat: return "text.bubble.fill"
        case .myJobs: return "bag.fill"
        case .profile: return "person.fill"
        }
    }
}

enum ServiceProviderTab: String, CaseIterable {
    case home
    case chat
    case myJobs
    case search
	case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .chat: return "Chat"
        case .myJobs: return "Jobs"
        case .profile: return "Profile"
				case .search: return "Search"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .chat: return "text.bubble.fill"
        case .myJobs: return "bag.fill"
        case .search: return "magnifyingglass"
				case .profile: return "person.fill"
        }
    }
}

// MARK: - Navigation Destinations

enum JobSeekerDestination: Hashable {
    case serviceDetail(JobService)
    case categoryDetail(ServiceCategoryType)
    case chatDetail(conversationId: String)
}

enum ServiceProviderDestination: Hashable {
    case serviceDetail(JobService)
    case groupServiceDetail(groupId: String, shifts: [JobService])
    case applicationsList(serviceId: String, serviceTitle: String)
    case categoryDetail(ServiceCategoryType)
    case chatDetail(conversationId: String)
    case createJob(category: String, initialJobName: String?, initialServiceImageName: String?)
    case performance
    case completedServices
    case userReviews(userId: String)
    case filteredServices(filter: ServiceTimeFilter)
}

// MARK: - Sheet Destinations

enum SheetDestination: Hashable, Identifiable {
    case createJob(category: String, initialJobName: String?, initialServiceImageName: String? = nil)
    case addService
    case applyToService(serviceTitle: String, serviceId: String)
    case applicationDetail(JobApplication)
    case applicationsList(serviceId: String, serviceTitle: String)
    case imagePicker
    case myAddresses
    case walletSheet
    case notificationDrawer(role: UserRole)
    case allActivities
    case userProfile(userId: String)
    case filteredServices(filter: ServiceTimeFilter)

    var id: String {
        switch self {
        case .createJob(let category, _, _): return "createJob_\(category)"
        case .addService: return "addService"
        case .applyToService(_, let serviceId): return "apply_\(serviceId)"
        case .applicationDetail(let app): return "appDetail_\(app.id)"
        case .applicationsList(let serviceId, _): return "appList_\(serviceId)"
        case .imagePicker: return "imagePicker"
        case .myAddresses: return "myAddresses"
        case .walletSheet: return "walletSheet"
        case .notificationDrawer(let role): return "notificationDrawer_\(role)"
        case .allActivities: return "allActivities"
        case .userProfile(let userId): return "userProfile_\(userId)"
        case .filteredServices(let filter): return "filteredServices_\(filter.displayTitle)"
        }
    }
}
