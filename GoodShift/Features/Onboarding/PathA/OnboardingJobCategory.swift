//
//  OnboardingJobCategory.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import Foundation

enum OnboardingJobCategory: String, CaseIterable, Hashable {
    case foodAndDrinks    = "Food & Drinks"
    case retailAndShops   = "Retail & Shops"
    case delivery         = "Delivery"
    case cleaning         = "Cleaning"
    case movingAndLabour  = "Moving & Labour"
    case maintenance      = "Maintenance"
    case events           = "Events"
    case petrolAndAuto    = "Petrol & Auto"
    case outdoors         = "Outdoors"

    var imageName: String {
        switch self {
        case .foodAndDrinks:   return "barista"
        case .retailAndShops:  return "cashierMan"
        case .delivery:        return "delivery"
        case .cleaning:        return "homeCleaning"
        case .movingAndLabour: return "helpMoving"
        case .maintenance:     return "electricWork"
        case .events:          return "eventCatering"
        case .petrolAndAuto:   return "petrolStation"
        case .outdoors:        return "gardening"
        }
    }
}
