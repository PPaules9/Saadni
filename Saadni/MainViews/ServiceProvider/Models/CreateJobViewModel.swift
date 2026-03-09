//
//  CreateJobViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

enum AroundOption: String, CaseIterable {
    case you = "You"
    case someoneElse = "Someone Else"
    case noOne = "No One"
}

enum ToolsNeeded: String, CaseIterable {
    case yes = "Yes"
    case maybe = "Maybe"
    case no = "No"
}

@Observable
class CreateJobViewModel {
    // Tab 1: Job Details & Location
    var jobName: String = ""
    var address: String = ""
    var floor: String = ""
    var unit: String = ""
    var city: String = ""

    // Tab 2: Pictures & Around
    var selectedImage: UIImage?
    var aroundOption: AroundOption = .you

    // Tab 3: Tools
    var toolsNeeded: ToolsNeeded = .yes
    var toolsDescription: String = ""

    // Tab 4: Price
    var price: String = ""

    // Tab 5: Details
    var otherDetails: String = ""

    // UI State
    var currentTab: Int = 0
    var showConfetti: Bool = false
    var showImagePicker: Bool = false

    // MARK: - Validation
    var isTab1Valid: Bool {
        !jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isTab2Valid: Bool {
        selectedImage != nil
    }

    var isTab3Valid: Bool {
        if toolsNeeded == .yes {
            return !toolsDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }

    var isTab4Valid: Bool {
        guard let priceValue = Double(price), priceValue > 0 else { return false }
        return true
    }

    var isCurrentTabValid: Bool {
        switch currentTab {
        case 0: return isTab1Valid
        case 1: return isTab2Valid
        case 2: return isTab3Valid
        case 3: return isTab4Valid
        case 4: return true
        default: return false
        }
    }

    func canPublish() -> Bool {
        return isTab1Valid && isTab2Valid && isTab3Valid && isTab4Valid
    }

    func nextTab() {
        if currentTab < 4 {
            currentTab += 1
        }
    }

    func previousTab() {
        if currentTab > 0 {
            currentTab -= 1
        }
    }
}
