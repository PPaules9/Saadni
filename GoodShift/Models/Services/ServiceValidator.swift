//
//  ServiceValidator.swift
//  GoodShift
//
//  Created by Claude Code on 15/03/2026.
//
//  Validates service operations to prevent data corruption and invalid state transitions.
//

import Foundation

struct ServiceValidator {
    /// Validates that a service can be marked as completed
    static func canMarkAsCompleted(_ service: JobService) throws {
        guard service.status == .active else {
            throw NSError(
                domain: "ServiceValidator",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Only active services can be marked as completed. Current status: \(service.status.rawValue)"]
            )
        }

        guard service.hiredApplicantId != nil else {
            throw NSError(
                domain: "ServiceValidator",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Cannot complete service without a hired applicant"]
            )
        }

        guard service.price > 0 else {
            throw NSError(
                domain: "ServiceValidator",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Cannot complete service with zero or negative price"]
            )
        }
    }

    /// Validates that an application can be submitted for a service
    static func canSubmitApplication(
        to service: JobService,
        by userId: String
    ) throws {
        guard service.status != .completed && service.status != .cancelled else {
            throw NSError(
                domain: "ServiceValidator",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "Cannot apply to \(service.status.rawValue) services"]
            )
        }

        guard service.providerId != userId else {
            throw NSError(
                domain: "ServiceValidator",
                code: 5,
                userInfo: [NSLocalizedDescriptionKey: "You cannot apply to your own services"]
            )
        }

        guard service.price > 0 else {
            throw NSError(
                domain: "ServiceValidator",
                code: 6,
                userInfo: [NSLocalizedDescriptionKey: "Cannot apply to services with invalid pricing"]
            )
        }
    }

    static func canPublish(_ service: JobService) throws {
        guard !service.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(
                domain: "ServiceValidator",
                code: 7,
                userInfo: [NSLocalizedDescriptionKey: "Service title cannot be empty"]
            )
        }

        guard service.price > 0 else {
            throw NSError(
                domain: "ServiceValidator",
                code: 8,
                userInfo: [NSLocalizedDescriptionKey: "Service price must be greater than 0"]
            )
        }
    }

    /// Validates that an earning can be created
    static func canCreateEarning(
        amount: Double,
        forServiceWithId serviceId: String
    ) throws {
        guard !serviceId.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw NSError(
                domain: "ServiceValidator",
                code: 11,
                userInfo: [NSLocalizedDescriptionKey: "Service ID is required for earning"]
            )
        }

        guard amount > 0 else {
            throw NSError(
                domain: "ServiceValidator",
                code: 12,
                userInfo: [NSLocalizedDescriptionKey: "Earning amount must be positive"]
            )
        }

        guard amount <= 1_000_000 else {
            throw NSError(
                domain: "ServiceValidator",
                code: 13,
                userInfo: [NSLocalizedDescriptionKey: "Earning amount exceeds maximum limit"]
            )
        }
    }
}
