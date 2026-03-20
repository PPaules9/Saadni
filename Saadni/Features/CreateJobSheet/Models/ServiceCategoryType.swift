//
//  ServiceCategoryType.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import Foundation

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
