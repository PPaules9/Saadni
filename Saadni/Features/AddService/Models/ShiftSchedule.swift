//
//  ShiftSchedule.swift
//  Saadni
//
//  Created by Pavly Paules on 26/02/2026.
//


import Foundation

/// Encapsulates shift timing information
struct ShiftSchedule: Codable, Hashable {
    
    // MARK: - Properties
    
    /// The date when the shift occurs
    let startDate: Date
    
    /// When the shift starts (time of day)
    let startTime: Date
    
    /// When the shift ends (time of day)
    let endTime: Date
    
    /// Whether this shift repeats on multiple dates
    let isRepeated: Bool
    
    /// Array of dates when shift repeats (up to 26 dates)
    let repeatDates: [Date]
    
    // MARK: - Initializers
    
    /// Create a one-time shift
    init(startDate: Date, startTime: Date, endTime: Date) {
        self.startDate = startDate
        self.startTime = startTime
        self.endTime = endTime
        self.isRepeated = false
        self.repeatDates = []
    }
    
    /// Create a repeated shift
    init(startDate: Date, startTime: Date, endTime: Date, repeatDates: [Date]) {
        self.startDate = startDate
        self.startTime = startTime
        self.endTime = endTime
        self.isRepeated = true
        self.repeatDates = repeatDates
    }
    
    /// Full initializer
    init(startDate: Date, startTime: Date, endTime: Date, isRepeated: Bool, repeatDates: [Date]) {
        self.startDate = startDate
        self.startTime = startTime
        self.endTime = endTime
        self.isRepeated = isRepeated
        self.repeatDates = repeatDates
    }
}

// MARK: - Computed Properties

extension ShiftSchedule {
    /// Total number of shift occurrences
    var totalShifts: Int {
        return isRepeated ? repeatDates.count : 1
    }
    
    /// Duration of each shift in hours
    var durationInHours: Double {
        return endTime.timeIntervalSince(startTime) / 3600
    }
    
    /// Check if shift is valid (end time after start time)
    var isValid: Bool {
        return endTime > startTime
    }
}
