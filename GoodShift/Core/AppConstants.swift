//
//  AppConstants.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import Foundation

enum AppInfo {
    static let name: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "GoodShift"
}
