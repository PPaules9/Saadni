//
//  OnboardingStaffCategory.swift
//  GoodShift
//

import Foundation

enum OnboardingStaffCategory: String, CaseIterable, Hashable {
    case foodAndBeverage  = "Food & Beverage"
    case retailAssistants = "Retail Assistants"
    case delivery         = "Delivery"
    case cleaning         = "Cleaning"
    case movingAndLabour  = "Moving & Labour"
    case maintenance      = "Maintenance"
    case eventStaff       = "Event Staff"
    case security         = "Security"

    var imageName: String {
        switch self {
        case .foodAndBeverage:  return "waiter"
        case .retailAssistants: return "shopAssistant"
        case .delivery:         return "delivery"
        case .cleaning:         return "homeCleaning"
        case .movingAndLabour:  return "helpMoving"
        case .maintenance:      return "electricWork"
        case .eventStaff:       return "eventCatering"
        case .security:         return "eventSecurity"
        }
    }
}
