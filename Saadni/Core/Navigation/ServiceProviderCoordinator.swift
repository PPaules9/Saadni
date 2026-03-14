import SwiftUI

@Observable
final class ServiceProviderCoordinator: Equatable {
    static func == (lhs: ServiceProviderCoordinator, rhs: ServiceProviderCoordinator) -> Bool {
        lhs === rhs
    }
    // Tab selection
    var selectedTab: ServiceProviderTab = .home

    // Navigation paths per tab
    var homePath = NavigationPath()
    var chatPath = NavigationPath()
    var myJobsPath = NavigationPath()
    var profilePath = NavigationPath()
    var searchPath = NavigationPath()

    // Sheet state (stack for modal layering)
    var sheetStack: [SheetDestination] = []

    // MARK: - Tab Navigation

    func selectTab(_ tab: ServiceProviderTab) {
        selectedTab = tab
    }

    // MARK: - Stack Navigation

    func navigate(to destination: ServiceProviderDestination) {
        currentPath.append(destination)
    }

    func pop() {
        if !currentPath.isEmpty {
            currentPath.removeLast()
        }
    }

    func popToRoot() {
        currentPath = NavigationPath()
    }

    // MARK: - Cross-Tab Navigation

    func selectTabAndNavigate(to tab: ServiceProviderTab, destination: ServiceProviderDestination? = nil) {
        selectedTab = tab
        if let destination = destination {
            // Ensure we're operating on the correct path after tab switch
            DispatchQueue.main.async {
                self.navigate(to: destination)
            }
        }
    }

    // MARK: - Sheet Navigation

    func presentSheet(_ sheet: SheetDestination) {
        sheetStack.append(sheet)
    }

    func dismissSheet() {
        if !sheetStack.isEmpty {
            sheetStack.removeLast()
        }
    }

    func dismissAllSheets() {
        sheetStack.removeAll()
    }

    var topSheet: SheetDestination? {
        sheetStack.last
    }

    // MARK: - Helpers

    private var currentPath: NavigationPath {
        get {
            switch selectedTab {
            case .home: return homePath
            case .chat: return chatPath
            case .myJobs: return myJobsPath
            case .profile: return profilePath
            case .search: return searchPath
            }
        }
        set {
            switch selectedTab {
            case .home: homePath = newValue
            case .chat: chatPath = newValue
            case .myJobs: myJobsPath = newValue
            case .profile: profilePath = newValue
            case .search: searchPath = newValue
            }
        }
    }

    func pathBinding(for tab: ServiceProviderTab) -> Binding<NavigationPath> {
        Binding(
            get: {
                switch tab {
                case .home: return self.homePath
                case .chat: return self.chatPath
                case .myJobs: return self.myJobsPath
                case .profile: return self.profilePath
                case .search: return self.searchPath
                }
            },
            set: { newValue in
                switch tab {
                case .home: self.homePath = newValue
                case .chat: self.chatPath = newValue
                case .myJobs: self.myJobsPath = newValue
                case .profile: self.profilePath = newValue
                case .search: self.searchPath = newValue
                }
            }
        )
    }
}
