//
//  PermissionHelpers.swift
//  GoodShift
//
//  Helper utilities for requesting system permissions from onboarding screens.
//  Each request is fire-and-forget — the completion block always fires so
//  navigation continues regardless of whether the user grants or denies.
//

import Foundation
import CoreLocation
import UserNotifications
import UIKit

enum LocationPermissionHelper {
    static func request(completion: @escaping () -> Void) {
        AnalyticsService.shared.track(.permissionPrompted(type: "location"))
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        // Navigate immediately — we can't easily await CLLocationManager's callback here
        // without holding a reference. Track grant/deny in-app when location is first used.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
}

enum NotificationPermissionHelper {
    static func request(completion: @escaping () -> Void) {
        AnalyticsService.shared.track(.permissionPrompted(type: "notifications"))
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        AnalyticsService.shared.track(.permissionGranted(type: "notifications"))
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        AnalyticsService.shared.track(.permissionDenied(type: "notifications"))
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    completion()
                }
            }
    }
}
