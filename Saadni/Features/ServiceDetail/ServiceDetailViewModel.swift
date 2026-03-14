//
//  ServiceDetailViewModel.swift
//  Saadni
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class ServiceDetailViewModel {
    // MARK: - Dependencies
    @ObservationIgnored var servicesStore: ServicesStore?
    @ObservationIgnored var applicationsStore: ApplicationsStore?
    @ObservationIgnored var reviewsStore: ReviewsStore?
    @ObservationIgnored var walletStore: WalletStore?
    @ObservationIgnored var userCache: UserCache?

    // MARK: - UI State
    var isSubmittingApplication = false
    var applicationError: String?
    var showApplicationSuccess = false
    var isMarkingComplete = false
    var completionError: String?
    var showCompletionSuccess = false
    var isArchiving = false
    var archiveError: String?

    // MARK: - Service Operations

    /// Submits an application for the service
    func submitApplication(
        for serviceId: String,
        by applicantId: String,
        message: String = ""
    ) async {
        guard let applicationsStore = applicationsStore else { return }

        isSubmittingApplication = true
        applicationError = nil

        do {
            let application = JobApplication(
                id: UUID().uuidString,
                serviceId: serviceId,
                applicantId: applicantId,
                appliedAt: Date(),
                status: .pending,
                coverMessage: message
            )
            try await applicationsStore.submitApplication(application)
            showApplicationSuccess = true
            isSubmittingApplication = false
        } catch {
            applicationError = error.localizedDescription
            isSubmittingApplication = false
            print("❌ Failed to submit application: \(error)")
        }
    }

    /// Marks a service as completed and creates earning transaction
    func markServiceAsCompleted(
        serviceId: String,
        providerId: String,
        servicePrice: Double
    ) async {
        guard let servicesStore = servicesStore,
              let walletStore = walletStore else { return }

        isMarkingComplete = true
        completionError = nil

        do {
            // Mark service as completed
            try await servicesStore.markServiceAsCompleted(serviceId: serviceId)

            // Create earning transaction
            let transaction = Transaction(
                id: UUID().uuidString,
                userId: providerId,
                type: .earning,
                amount: servicePrice,
                description: "Service completed",
                createdAt: Date()
            )
            try await walletStore.createTransaction(transaction)

            showCompletionSuccess = true
            isMarkingComplete = false
        } catch {
            completionError = error.localizedDescription
            isMarkingComplete = false
            print("❌ Failed to mark service as completed: \(error)")
        }
    }

    /// Archives a service
    func archiveService(serviceId: String) async {
        guard let servicesStore = servicesStore else { return }

        isArchiving = true
        archiveError = nil

        do {
            try await servicesStore.archiveService(serviceId: serviceId)
            isArchiving = false
        } catch {
            archiveError = error.localizedDescription
            isArchiving = false
            print("❌ Failed to archive service: \(error)")
        }
    }

    /// Unarchives a service
    func unarchiveService(serviceId: String) async {
        guard let servicesStore = servicesStore else { return }

        isArchiving = true
        archiveError = nil

        do {
            try await servicesStore.unarchiveService(serviceId: serviceId)
            isArchiving = false
        } catch {
            archiveError = error.localizedDescription
            isArchiving = false
            print("❌ Failed to unarchive service: \(error)")
        }
    }

    /// Gets reviews for a service
    func getReviewsForService(_ serviceId: String) -> [Review] {
        guard let reviewsStore = reviewsStore else { return [] }
        return reviewsStore.getReviewsForService(serviceId)
    }

    /// Checks if current user has reviewed the service
    func hasReviewedService(_ serviceId: String) -> Bool {
        guard let reviewsStore = reviewsStore else { return false }
        return reviewsStore.hasReviewedService(serviceId)
    }
}
