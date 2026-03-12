import SwiftUI

@Observable
final class JobSeekerCoordinator: Equatable {
    static func == (lhs: JobSeekerCoordinator, rhs: JobSeekerCoordinator) -> Bool {
        lhs === rhs
    }
    // Tab selection
    var selectedTab: JobSeekerTab = .dashboard

    // Navigation paths per tab
    var dashboardPath = NavigationPath()
    var chatPath = NavigationPath()
    var addJobPath = NavigationPath()
    var myJobsPath = NavigationPath()
    var profilePath = NavigationPath()

    // Sheet state
    var activeSheet: SheetDestination?

    // MARK: - Tab Navigation

    func selectTab(_ tab: JobSeekerTab) {
        selectedTab = tab
    }

    // MARK: - Stack Navigation

    func navigate(to destination: JobSeekerDestination) {
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

    // MARK: - Sheet Navigation

    func presentSheet(_ sheet: SheetDestination) {
        activeSheet = sheet
    }

    func dismissSheet() {
        activeSheet = nil
    }

    // MARK: - Helpers

    private var currentPath: NavigationPath {
        get {
            switch selectedTab {
            case .dashboard: return dashboardPath
            case .chat: return chatPath
            case .addJob: return addJobPath
            case .myJobs: return myJobsPath
            case .profile: return profilePath
            }
        }
        set {
            switch selectedTab {
            case .dashboard: dashboardPath = newValue
            case .chat: chatPath = newValue
            case .addJob: addJobPath = newValue
            case .myJobs: myJobsPath = newValue
            case .profile: profilePath = newValue
            }
        }
    }

    func pathBinding(for tab: JobSeekerTab) -> Binding<NavigationPath> {
        Binding(
            get: {
                switch tab {
                case .dashboard: return self.dashboardPath
                case .chat: return self.chatPath
                case .addJob: return self.addJobPath
                case .myJobs: return self.myJobsPath
                case .profile: return self.profilePath
                }
            },
            set: { newValue in
                switch tab {
                case .dashboard: self.dashboardPath = newValue
                case .chat: self.chatPath = newValue
                case .addJob: self.addJobPath = newValue
                case .myJobs: self.myJobsPath = newValue
                case .profile: self.profilePath = newValue
                }
            }
        )
    }
}
