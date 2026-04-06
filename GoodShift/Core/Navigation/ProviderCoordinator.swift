//
//  JobSeekerCoordinator.swift
//  GoodShift
//
//  Created by Pavly Paules on 30/03/2026.
//


import SwiftUI

@Observable
final class ProviderCoordinator: Equatable {
    static func == (lhs: ProviderCoordinator, rhs: ProviderCoordinator) -> Bool {
        lhs === rhs
    }
    // Tab selection
    var selectedTab: JobSeekerTab = .dashboard

    // Navigation paths per tab
    var dashboardPath = NavigationPath()
    var chatPath = NavigationPath()
//    var addJobPath = NavigationPath()
    var myJobsPath = NavigationPath()
    var profilePath = NavigationPath()

    // Sheet state (stack for modal layering)
    var sheetStack: [SheetDestination] = []

    // MARK: - Tab Navigation

    func selectTab(_ tab: JobSeekerTab) {
        selectedTab = tab
    }

    // MARK: - Stack Navigation

    func navigate(to destination: JobSeekerDestination) {
        currentPath.append(destination)
    }

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

    func selectTabAndNavigate(to tab: JobSeekerTab, destination: JobSeekerDestination? = nil) {
        selectedTab = tab
        if let destination = destination {
            // Ensure we're operating on the correct path after tab switch
            Task { @MainActor in
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
            case .dashboard: return dashboardPath
            case .chat: return chatPath
//            case .addJob: return addJobPath
            case .myJobs: return myJobsPath
            case .profile: return profilePath
            }
        }
        set {
            switch selectedTab {
            case .dashboard: dashboardPath = newValue
            case .chat: chatPath = newValue
//            case .addJob: addJobPath = newValue
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
//                case .addJob: return self.addJobPath
                case .myJobs: return self.myJobsPath
                case .profile: return self.profilePath
                }
            },
            set: { newValue in
                switch tab {
                case .dashboard: self.dashboardPath = newValue
                case .chat: self.chatPath = newValue
//                case .addJob: self.addJobPath = newValue
                case .myJobs: self.myJobsPath = newValue
                case .profile: self.profilePath = newValue
                }
            }
        )
    }
}
