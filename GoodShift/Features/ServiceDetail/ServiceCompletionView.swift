//
//  ServiceCompletionView.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ServiceCompletionView: View {
    let service: JobService

    @Environment(\.dismiss) var dismiss
    @Environment(ServicesStore.self) var servicesStore
    @Environment(WalletStore.self) var walletStore
    @Environment(AuthenticationManager.self) var authManager

    @State private var isCompleting: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Success icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)

                VStack(spacing: 12) {
                    Text("Mark Service as Complete?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text("Once marked complete, both you and the worker will be able to leave reviews. This action cannot be undone.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)

                // Service details
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Service")
                            .font(.caption)
                            .foregroundStyle(.gray)

                        Text(service.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Price")
                                .font(.caption)
                                .foregroundStyle(.gray)

                            Text(service.formattedPrice)
                                .font(.headline)
                                .foregroundStyle(.green)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Status")
                                .font(.caption)
                                .foregroundStyle(.gray)

                            Text(service.status.rawValue.capitalized)
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.3))
                .cornerRadius(12)

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        showConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Complete")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .foregroundStyle(.white)
                    }
                    .disabled(isCompleting)

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(12)
                            .foregroundStyle(.blue)
                    }
                    .disabled(isCompleting)
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.1))
            .navigationTitle("Complete Service")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog(
                "Confirm Completion",
                isPresented: $showConfirmation,
                titleVisibility: .visible
            ) {
                Button("Complete Service", role: .destructive) {
                    Task {
                        await completeService()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Mark this service as complete? Both parties will be able to leave reviews.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func completeService() async {
        isCompleting = true

        do {
            // Mark service as completed
            try await servicesStore.markServiceAsCompleted(serviceId: service.id)

            // Create earning transaction for provider
            guard let userId = authManager.currentUserId else {
                throw NSError(domain: "ServiceCompletion", code: 1,
                             userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            }

            try await walletStore.createEarningTransaction(
                userId: userId,
                amount: service.price,
                serviceId: service.id,
                serviceName: service.title
            )

            AnalyticsService.shared.track(.jobCompleted(
                jobId: service.id,
                category: service.category?.rawValue ?? "",
                price: service.price
            ))
            dismiss()
        } catch {
            errorMessage = "Failed to complete service: \(error.localizedDescription)"
            showError = true
            isCompleting = false
        }
    }
}

#Preview {
    ServiceCompletionView(service: JobService.sampleData[0])
        .environment(ServicesStore())
        .environment(WalletStore())
        .environment(AuthenticationManager(userCache: UserCache()))
}
