//
//  OnboardingView.swift
//  GoodShift
//

import SwiftUI

struct OnboardingView: View {
    @State private var screen: OnboardingScreen = .welcome
    @State private var state = OnboardingState()

    @Environment(AppStateManager.self) var appStateManager
    @Environment(AuthenticationManager.self) var authManager

    var body: some View {
        ZStack(alignment: .top) {
            Colors.swiftUIColor(.appBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if screen.showsProgressBar {
                    OnboardingProgressBar(
                        progress: screen.progressValue(for: state.role)
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, safeAreaTop + 8)
                    .padding(.bottom, 12)
                }

                currentScreen
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(screen)
            }
        }
        .ignoresSafeArea(edges: .top)
        .animation(.easeInOut(duration: 0.3), value: screen)
        .onChange(of: screen) { _, newScreen in
            trackStep(newScreen)
        }
        .onAppear {
            trackStep(.welcome)
        }
    }

    // MARK: - Screen Router

    @ViewBuilder
    private var currentScreen: some View {
        switch screen {

        // Shared
        case .welcome:
            OnboardingWelcomeScreen { navigate(to: .roleSplit) }

        case .roleSplit:
            OnboardingRoleSplitScreen { role in
                state.role = role
                navigate(to: role == .jobSeeker ? .a_goal : .b_goal)
            }

        // ── PATH A — Job Seeker ──────────────────────────────────────

        case .a_goal:
            PathA_GoalScreen(selectedGoal: $state.pathA_goal) {
                navigate(to: .a_painPoints)
            }

        case .a_painPoints:
            PathA_PainPointsScreen(selected: $state.pathA_painPoints) {
                navigate(to: .a_socialProof)
            }

        case .a_socialProof:
            PathA_SocialProofScreen { navigate(to: .a_tinderCards) }

        case .a_tinderCards:
            PathA_TinderCardsScreen { navigate(to: .a_solution) }

        case .a_solution:
            PathA_SolutionScreen(painPoints: state.pathA_painPoints) {
                navigate(to: .a_categoryPrefs)
            }

        case .a_categoryPrefs:
            PathA_CategoryPrefsScreen(selected: $state.pathA_categories) {
                navigate(to: .a_locationPerm)
            }

        case .a_locationPerm:
            PathA_LocationPermScreen(
                onEnable: { navigate(to: .a_processing) },
                onSkip:   { navigate(to: .a_processing) }
            )

        case .a_processing:
            OnboardingProcessingScreen(message: "Building your shift feed…") {
                navigate(to: .a_demo)
            }

        case .a_demo:
            PathA_DemoScreen(state: $state) { navigate(to: .a_notifPerm) }

        case .a_notifPerm:
            PathA_NotifPermScreen(
                onEnable: { navigate(to: .a_paywall) },
                onSkip:   { navigate(to: .a_paywall) }
            )

        case .a_paywall:
            PathA_PaywallScreen { navigate(to: .a_account) }

        case .a_account:
            PathA_AccountScreen()

        // ── PATH B — Service Provider ────────────────────────────────

        case .b_goal:
            PathB_GoalScreen(selected: $state.pathB_categories) {
                navigate(to: .b_painPoints)
            }

        case .b_painPoints:
            PathB_PainPointsScreen(selected: $state.pathB_painPoints) {
                navigate(to: .b_socialProof)
            }

        case .b_socialProof:
            PathB_SocialProofScreen { navigate(to: .b_solution) }

        case .b_solution:
            PathB_SolutionScreen(painPoints: state.pathB_painPoints) {
                navigate(to: .b_comparison)
            }

        case .b_comparison:
            PathB_ComparisonScreen { navigate(to: .b_processing) }

        case .b_processing:
            OnboardingProcessingScreen(message: "Setting up your employer profile…") {
                navigate(to: .b_demo)
            }

        case .b_demo:
            PathB_DemoScreen { navigate(to: .b_notifPerm) }

        case .b_notifPerm:
            PathB_NotifPermScreen(
                onEnable: { navigate(to: .b_paywall) },
                onSkip:   { navigate(to: .b_paywall) }
            )

        case .b_paywall:
            PathB_PaywallScreen { navigate(to: .b_account) }

        case .b_account:
            PathB_AccountScreen()
        }
    }

    // MARK: - Navigation

    private func navigate(to next: OnboardingScreen) {
        withAnimation(.easeInOut(duration: 0.3)) {
            screen = next
        }
    }

    // MARK: - Analytics

    private func trackStep(_ s: OnboardingScreen) {
        let role = state.role.map { $0 == .jobSeeker ? "job_seeker" : "provider" } ?? "unknown"
        AnalyticsService.shared.track(.onboardingStepViewed(step: s.analyticsName, role: role))
    }

    // MARK: - Helpers

    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
}

#Preview {
    OnboardingView()
        .environment(AppStateManager())
        .environment(AuthenticationManager(userCache: UserCache()))
}
