//
//  ServiceCategoryType.swift
//  GoodShift
//
//  Created by Pavly Paules on 25/02/2026.
//

import Foundation

// MARK: - Service Tag Options (quick-pick tags shown in BrowseJobsView icons)

enum ServiceTagOption: String, CaseIterable, Identifiable {
    case cleaning  = "Cleaning"
    case cashier   = "Cashier"
    case moving    = "Moving"
    case barista   = "Barista"
    case delivery  = "Delivery"
    case fixing    = "Fixing"
    case furniture = "Furniture"
    case other     = "Other"

    var id: String { rawValue }

    var derivedCategory: ServiceCategoryType {
        switch self {
        case .cleaning, .fixing:   return .cleaningAndMaintenance
        case .cashier:             return .retailAndMalls
        case .moving, .furniture:  return .movingAndLabour
        case .barista:             return .foodAndBeverage
        case .delivery:            return .logisticsAndWarehousing
        case .other:               return .hospitalityAndEvents
        }
    }

    var icon: String {
        switch self {
        case .cleaning:  return "sparkles"
        case .cashier:   return "bag.fill"
        case .moving:    return "figure.walk.motion"
        case .barista:   return "cup.and.saucer.fill"
        case .delivery:  return "shippingbox.fill"
        case .fixing:    return "wrench.and.screwdriver.fill"
        case .furniture: return "sofa.fill"
        case .other:     return "ellipsis.circle.fill"
        }
    }
}

enum ServiceCategoryType: String, CaseIterable, Codable, Hashable {
    case foodAndBeverage = "Food & Beverage"
    case retailAndMalls = "Retail & Malls"
    case logisticsAndWarehousing = "Logistics & Warehousing"
    case cleaningAndMaintenance = "Cleaning & Maintenance"
    case petrolAndAutomotive = "Petrol & Automotive"
    case securityAndCrowdManagement = "Security & Crowd Management"
    case hospitalityAndEvents = "Hospitality & Events"
    case movingAndLabour = "Moving & Labour"
    case communityAndOutdoor = "Community & Outdoor"

    var icon: String {
        switch self {
        case .foodAndBeverage: return "cup.and.saucer.fill"
        case .retailAndMalls: return "bag.fill"
        case .logisticsAndWarehousing: return "shippingbox.fill"
        case .cleaningAndMaintenance: return "sparkles"
        case .petrolAndAutomotive: return "fuelpump.fill"
        case .securityAndCrowdManagement: return "shield.fill"
        case .hospitalityAndEvents: return "party.popper.fill"
        case .movingAndLabour: return "figure.walk.motion"
        case .communityAndOutdoor: return "leaf.fill"
        }
    }
}
