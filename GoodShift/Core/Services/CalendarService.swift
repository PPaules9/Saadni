//
//  CalendarService.swift
//  GoodShift
//

import EventKit
import Foundation

@MainActor
final class CalendarService {
    static let shared = CalendarService()
    private let store = EKEventStore()

    private init() {}

    func requestAccess() async -> Bool {
        if #available(iOS 17, *) {
            return (try? await store.requestWriteOnlyAccessToEvents()) ?? false
        } else {
            return await withCheckedContinuation { continuation in
                store.requestAccess(to: .event) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }
    }

    /// Adds a job event to the user's default calendar.
    /// - Returns: `true` on success.
    func addJobEvent(title: String, startDate: Date, durationHours: Double?, location: String?, notes: String?) async throws {
        let granted = await requestAccess()
        guard granted else {
            throw CalendarError.accessDenied
        }

        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate

        let duration = durationHours ?? 1.0
        event.endDate = startDate.addingTimeInterval(duration * 3600)

        if let location {
            event.location = location
        }
        if let notes {
            event.notes = notes
        }

        event.calendar = store.defaultCalendarForNewEvents

        try store.save(event, span: .thisEvent)
    }
}

enum CalendarError: LocalizedError {
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Calendar access was denied. Please enable it in Settings."
        }
    }
}
