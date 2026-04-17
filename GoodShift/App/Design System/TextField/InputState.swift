//
//  InputState.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - InputState

enum InputState {
    case inactive
    case active
    case filled
}

extension InputState {
    var borderColor: Color {
        switch self {
        case .inactive:
            return .gray.opacity(0.3)
        case .active:
            return .accent
        case .filled:
            return .gray.opacity(0.3)
        }
    }
}

extension InputState {
    var textWeight: Font.Weight {
        switch self {
        case .inactive:
            return .regular
        case .active:
            return .regular
        case .filled:
            return .regular
        }
    }
}
