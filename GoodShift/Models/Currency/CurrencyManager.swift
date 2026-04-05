//
//  CurrencyManager.swift
//  GoodShift
//
//  Created by Pavly Paules on 04/04/2026.
//

import Foundation
import SwiftUI

// MARK: - Currency Enum

enum Currency: String, CaseIterable, Identifiable {
    case egp = "EGP"
    case aed = "AED"
    case usd = "USD"
    case sar = "SAR"
    case kwd = "KWD"
    case qar = "QAR"
    case bhd = "BHD"
    case omr = "OMR"
    case eur = "EUR"
    case gbp = "GBP"

    var id: String { rawValue }

    /// Short symbol displayed next to amounts
    var symbol: String {
        switch self {
        case .egp: return "EGP"
        case .aed: return "AED"
        case .usd: return "$"
        case .sar: return "SAR"
        case .kwd: return "KWD"
        case .qar: return "QAR"
        case .bhd: return "BHD"
        case .omr: return "OMR"
        case .eur: return "€"
        case .gbp: return "£"
        }
    }

    /// Full English display name
    var displayName: String {
        switch self {
        case .egp: return "Egyptian Pound"
        case .aed: return "UAE Dirham"
        case .usd: return "US Dollar"
        case .sar: return "Saudi Riyal"
        case .kwd: return "Kuwaiti Dinar"
        case .qar: return "Qatari Riyal"
        case .bhd: return "Bahraini Dinar"
        case .omr: return "Omani Rial"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        }
    }

    /// Flag emoji for visual flair
    var flag: String {
        switch self {
        case .egp: return "🇪🇬"
        case .aed: return "🇦🇪"
        case .usd: return "🇺🇸"
        case .sar: return "🇸🇦"
        case .kwd: return "🇰🇼"
        case .qar: return "🇶🇦"
        case .bhd: return "🇧🇭"
        case .omr: return "🇴🇲"
        case .eur: return "🇪🇺"
        case .gbp: return "🇬🇧"
        }
    }

    // MARK: - Static Accessor (for non-view code)

    /// Reads the currently selected currency from UserDefaults.
    /// Use this in non-view contexts (e.g. model computed properties).
    static var current: Currency {
        let code = UserDefaults.standard.string(forKey: "appCurrency") ?? "EGP"
        return Currency(rawValue: code) ?? .egp
    }
}

// MARK: - Currency Manager

@Observable
final class CurrencyManager {
    @ObservationIgnored
    @AppStorage("appCurrency") private var _currencyCode: String = "EGP"

    var selectedCurrency: Currency {
        get { Currency(rawValue: _currencyCode) ?? .egp }
        set { _currencyCode = newValue.rawValue }
    }
}
