import SwiftUI

struct CompletionConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore
    @Environment(AuthenticationManager.self) private var authManager
    @Environment(ReviewsStore.self) private var reviewsStore

    let service: JobService
    let application: JobApplication

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Confirm Job Completion",
                systemImage: "checkmark.seal",
                description: Text("This feature is coming soon.")
            )
            .navigationTitle("Confirm Completion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
