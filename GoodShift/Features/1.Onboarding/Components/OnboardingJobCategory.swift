//
//  OnboardingJobCategory.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import Foundation

enum OnboardingJobCategory: String, CaseIterable, Hashable {
	case barista    = "Barista"
	case cashier    = "Cashier"
	case cleaning   = "Cleaning"
	case delivery   = "delivery"
	case fixing     = "fixing"
	case furniture  = "furniture"
	case moving     = "moving"
	case other      = "Other"

	var imageName: String {
		switch self {
		case .barista:    return "barista"
		case .cashier:    return "cashier"
		case .cleaning:   return "cleaning"
		case .delivery:   return "delivery"
		case .fixing:     return "fixing"
		case .furniture:  return "furniture"
		case .moving:     return "moving"
		case .other:      return "person"
		}
	}
}
