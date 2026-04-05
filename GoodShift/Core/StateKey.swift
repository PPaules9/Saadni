//
//  StateKey.swift
//  GoodShift
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
    // Only track onboarding (first-time UX)
    // Role selection comes from User object (isJobSeeker/isServiceProvider)
    static let hasSeenOnboarding = StateKey<Bool>("hasSeenOnboarding", default: false)
}
