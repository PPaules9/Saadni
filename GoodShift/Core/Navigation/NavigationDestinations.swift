import Foundation

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
    case applicationsList(serviceId: String, serviceTitle: String)
    case categoryDetail(ServiceCategoryType)
    case chatDetail(conversationId: String)
    case createJob(category: String, initialJobName: String?, initialServiceImageName: String?)
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

    var id: String {
        switch self {
        case .createJob(let category, _, _): return "createJob_\(category)"
        case .addService: return "addService"
        case .applyToService(_, let serviceId): return "apply_\(serviceId)"
        case .applicationDetail(let app): return "appDetail_\(app.id)"
        case .applicationsList(let serviceId, _): return "appList_\(serviceId)"
        case .imagePicker: return "imagePicker"
        case .myAddresses: return "myAddresses"
        }
    }
}
