//
//  ProfileView.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
	@Environment(AppStateManager.self) var appStateManager
	@Environment(AuthenticationManager.self) var authManager
	@Environment(UserCache.self) var userCache
	@Environment(AppCoordinator.self) var appCoordinator
	
	// Local UI State replacing the ProfileViewModel
	@State private var isAnimating: Bool = false
	@State private var isSwitching: Bool = false
	@State private var showPerformance: Bool = false
	
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
						AccountMenuSection(
							onLogout: {
								Task {
									try await authManager.signOut()
								}
							}
						)
						
						// Role Switcher
						RoleSwitcherView(
							currentRoleLabel: currentUserTypeLabel,
							currentRoleIcon: currentUserTypeIcon,
							isAnimating: isAnimating,
							isSwitching: isSwitching,
							onSwitch: switchUserType
						)
						
						Spacer()
							.frame(height: 20)
					}
				}
				.scrollIndicators(.hidden)
				.navigationTitle("Profile")
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							showPerformance = true
						} label: {
							Image(systemName: "chart.bar.fill")
								.foregroundStyle(.accent)
						}
					}
				}
				.navigationDestination(isPresented: $showPerformance) {
					UserPerformanceView()
				}
			}
		}
	}

	// MARK: - Computed Properties
	
	private var currentUserTypeLabel: String {
		if let user = authManager.currentUser {
			if user.isJobSeeker { return "Need Help With Something" }
			if user.isServiceProvider { return "Earn Some Cash" }
		}
		return "Unknown"
	}
	
	private var currentUserTypeIcon: String {
		if let user = authManager.currentUser {
			if user.isJobSeeker { return "magnifyingglass.circle.fill" }
			if user.isServiceProvider { return "briefcase.circle.fill" }
		}
		return "questionmark.circle"
	}
	
	// MARK: - Handlers
	
	private func switchUserType() {
		guard let currentUser = authManager.currentUser else { return }
		
		isSwitching = true
		withAnimation(.easeInOut(duration: 0.6)) {
			isAnimating = true
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			isAnimating = false
		}
		
		Task {
			var updatedUser = currentUser
			updatedUser.isJobSeeker.toggle()
			updatedUser.isServiceProvider.toggle()
			
			// Use UserCache for optimistic update + Firestore sync
			await userCache.updateUser(updatedUser)
			
			// Trigger coordinator to switch role
			appCoordinator.switchUserRole()
			
			await MainActor.run {
				isSwitching = false
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
