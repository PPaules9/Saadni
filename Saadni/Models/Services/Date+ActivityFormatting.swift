//
//  Date+ActivityFormatting.swift
//  Saadni
//

import Foundation

extension Date {
    /// "2 hours ago", "3 days ago", "just now"
    func relativeFormatted() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// "Apr 5, 9:00 AM"
    func shortFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// "Mon, Apr 5"
    func dayFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: self)
    }
}
