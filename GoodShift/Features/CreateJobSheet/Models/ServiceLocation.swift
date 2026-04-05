//
//  ServiceLocation.swift
//  GoodShift
//
//  Created by Pavly Paules on 26/02/2026.
//

import Foundation
import CoreLocation

/// Represents a service's location with both name and GPS coordinates
struct ServiceLocation: Codable, Hashable {
    let name: String
    let latitude: Double?
    let longitude: Double?

    /// Convenience initializer for creating from AddService form data
    /// - Parameters:
    ///   - name: The location name (e.g., "Cairo Festival City")
    ///   - coordinate: Optional CLLocationCoordinate2D from map selection
    init(name: String, coordinate: CLLocationCoordinate2D?) {
        self.name = name
        self.latitude = coordinate?.latitude
        self.longitude = coordinate?.longitude
    }

    /// Default memberwise initializer required for Codable/Firebase
    /// - Parameters:
    ///   - name: The location name
    ///   - latitude: GPS latitude (-90 to 90)
    ///   - longitude: GPS longitude (-180 to 180)
    init(name: String, latitude: Double?, longitude: Double?) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
