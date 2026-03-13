//
//  AppConstants.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

enum AppConstants {
    // MARK: - Time Constants
    enum Time {
        static let secondsPerDay: TimeInterval = 86400
        static let secondsPerHour: TimeInterval = 3600
        static let secondsPerMinute: TimeInterval = 60
    }

    // MARK: - Messaging Constants
    enum Messaging {
        static let messageRetentionDays = 90
        static let messagePreviewLength = 50
        static let maxMessageLength = 1000
    }

    // MARK: - User Scoring
    enum Scoring {
        static let maxProviderScore = 100
    }

    // MARK: - Pagination
    enum Pagination {
        static let defaultPageSize = 20
        static let maxPageSize = 100
    }
}
