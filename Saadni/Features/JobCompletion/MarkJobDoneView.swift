import SwiftUI

struct MarkJobDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore
    @Environment(ConversationsStore.self) private var conversationsStore

    let service: JobService

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Mark Job as Done",
                systemImage: "checkmark.circle",
                description: Text("This feature is coming soon.")
            )
            .navigationTitle("Mark Done")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
