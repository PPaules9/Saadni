//
//  ProfileView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
	@State private var viewModel: ProfileViewModel?
	@Environment(AppStateManager.self) var appStateManager
	@Environment(AuthenticationManager.self) var authManager
	@Environment(UserCache.self) var userCache
	@Environment(AppCoordinator.self) var appCoordinator
	
	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()
			
			NavigationStack {
				ScrollView {
					VStack(alignment: .leading, spacing: 24) {
						// Profile Header
						if let user = authManager.currentUser {
							let currentRole: UserRole = user.isServiceProvider ? .provider : .jobSeeker
							let completionPercentage = user.getCompletionPercentage(forRole: currentRole)

							ProfileHeaderView(
								displayName: user.displayName ?? "User",
								email: user.email,
								photoURL: user.photoURL,
								completionPercentage: completionPercentage
							)
						}
						
						// Account Menu
						if let vm = viewModel {
							AccountMenuSection(
								onLogout: {
									Task {
										try await vm.logout()
									}
								},
								onDeleteAccount: {
									Task {
										try await vm.deleteAccount()
									}
								}
							)
						}
						
						// Work Management
						WorkManagementSection(
							userId: authManager.currentUserId ?? ""
						)
						
						// Role Switcher
						if let vm = viewModel {
							RoleSwitcherView(
								currentRoleLabel: vm.currentUserTypeLabel,
								currentRoleIcon: vm.currentUserTypeIcon,
								isAnimating: vm.isAnimating,
								isSwitching: vm.isSwitching,
								onSwitch: vm.switchUserType
							)
						}
						
						Spacer()
							.frame(height: 20)
					}
				}
				.scrollIndicators(.hidden)
				.navigationTitle("Profile")
			}
		}
		.onAppear {
			if viewModel == nil {
				viewModel = ProfileViewModel(
					authManager: authManager,
					userCache: userCache,
					appCoordinator: appCoordinator,
					appStateManager: appStateManager
				)
			}
		}
	}
}

#Preview {
	let userCache = UserCache()
	let authManager = AuthenticationManager(userCache: userCache)
	return ProfileView()
		.environment(AppStateManager())
		.environment(userCache)
		.environment(authManager)
		.environment(AppCoordinator(authManager: authManager, userCache: userCache))
}
