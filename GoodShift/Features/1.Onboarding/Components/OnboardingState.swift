//
//  OnboardingState.swift
//  GoodShift
//
//  Created by Pavly Paules on 15/04/2026.
//

import Foundation

struct OnboardingState {
    var role: UserRole? = nil

    // MARK: - Path A (Job Seeker)
    var pathA_goal: String = ""
    var pathA_painPoints: Set<String> = []
    var pathA_categories: Set<OnboardingJobCategory> = []
    var pathA_savedShiftIds: Set<String> = []

    // MARK: - Path B (Service Provider)
    var pathB_categories: Set<OnboardingJobCategory> = []
    var pathB_painPoints: Set<String> = []

    // Derived: shifts saved in demo, for display on result screen
    var pathA_savedShifts: [JobService] {
        JobService.sampleData.filter { pathA_savedShiftIds.contains($0.id) }
    }

    var pathA_totalEarnings: Int {
			Int(pathA_savedShifts.reduce(0) { $0 + $1.price })
    }
}

// MARK: - Screen Enum

enum OnboardingScreen: Hashable {
    // Shared
    case welcome
    case roleSplit

    // Path A — Job Seeker
    case a_goal
    case a_painPoints
    case a_socialProof
    case a_tinderCards
    case a_solution
    case a_categoryPrefs
    case a_locationPerm
    case a_processing
    case a_demo
    case a_notifPerm
    case a_account

    // Path B — Service Provider
    case b_goal
    case b_painPoints
    case b_socialProof
    case b_solution
    case b_comparison
    case b_processing
    case b_demo
    case b_notifPerm
    case b_account
}

extension OnboardingScreen {
    var analyticsName: String {
        switch self {
        case .welcome:          return "welcome"
        case .roleSplit:        return "role_split"
        case .a_goal:           return "a_goal"
        case .a_painPoints:     return "a_pain_points"
        case .a_socialProof:    return "a_social_proof"
        case .a_tinderCards:    return "a_tinder_cards"
        case .a_solution:       return "a_solution"
        case .a_categoryPrefs:  return "a_category_prefs"
        case .a_locationPerm:   return "a_location_perm"
        case .a_processing:     return "a_processing"
        case .a_demo:           return "a_demo"
        case .a_notifPerm:      return "a_notif_perm"
        case .a_account:        return "a_account"
        case .b_goal:           return "b_goal"
        case .b_painPoints:     return "b_pain_points"
        case .b_socialProof:    return "b_social_proof"
        case .b_solution:       return "b_solution"
        case .b_comparison:     return "b_comparison"
        case .b_processing:     return "b_processing"
        case .b_demo:           return "b_demo"
        case .b_notifPerm:      return "b_notif_perm"
        case .b_account:        return "b_account"
        }
    }

    var showsProgressBar: Bool {
        switch self {
        case .welcome, .roleSplit: return false
        default: return true
        }
    }

    func progressValue(for role: UserRole?) -> Double {
        switch role {
        case .jobSeeker:
            return pathAProgress
        case .provider:
            return pathBProgress
        case nil:
            return 0
        }
    }

    private var pathAProgress: Double {
        let total = 12.0
        switch self {
        case .a_goal:         return 1 / total
        case .a_painPoints:   return 2 / total
        case .a_socialProof:  return 3 / total
        case .a_tinderCards:  return 4 / total
        case .a_solution:     return 5 / total
        case .a_categoryPrefs: return 6 / total
        case .a_locationPerm: return 7 / total
        case .a_processing:   return 8 / total
        case .a_demo:         return 9 / total
        case .a_notifPerm:    return 10 / total
        case .a_account:      return 12 / total
        default: return 0
        }
    }

    private var pathBProgress: Double {
        let total = 10.0
        switch self {
        case .b_goal:        return 1 / total
        case .b_painPoints:  return 2 / total
        case .b_socialProof: return 3 / total
        case .b_solution:    return 4 / total
        case .b_comparison:  return 5 / total
        case .b_processing:  return 6 / total
        case .b_demo:        return 7 / total
        case .b_notifPerm:   return 8 / total
        case .b_account:     return 10 / total
        default: return 0
        }
    }
}
