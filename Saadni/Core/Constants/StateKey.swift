//
//  StateKey.swift
//  Saadni
//
//  Created by Pavly Paules on 09/03/2026.
//


import Foundation

struct StateKey<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, default: T) {
        self.key = key
        self.defaultValue = `default`
    }
}

// Define keys as constants (prevents typos)
enum StateKeys {
    static let hasSeenOnboarding = StateKey<Bool>("hasSeenOnboarding", default: false)
    static let hasSelectedRole = StateKey<Bool>("hasSelectedRole", default: false)
}
