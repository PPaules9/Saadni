//
//  AnalyticsService.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/04/2026.
//

import Foundation
import AmplitudeSwift

final class AnalyticsService {

    static let shared = AnalyticsService()

    private let amplitude: Amplitude

    private init() {
        amplitude = Amplitude(configuration: Configuration(
            apiKey: "c7038224db8d9e53a5839f7df54a3f8d"
        ))
    }

    // MARK: - Identity

    func identify(userId: String) {
        amplitude.setUserId(userId: userId)
    }

    func setUserProperties(role: String) {
        let identify = Identify()
        identify.set(property: "role", value: role)
        amplitude.identify(identify: identify)
    }

    func reset() {
        amplitude.reset()
    }

    // MARK: - Events

    func track(_ event: AnalyticsEvent) {
        amplitude.track(eventType: event.name, eventProperties: event.properties)
    }
}
