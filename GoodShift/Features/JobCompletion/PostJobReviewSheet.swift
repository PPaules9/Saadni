import SwiftUI

struct PostJobReviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthenticationManager.self) private var authManager
    @Environment(ReviewsStore.self) private var reviewsStore

    let service: JobService
    let revieweeId: String
    let revieweeName: String
    let reviewerRole: ReviewerRole

    var body: some View {
        SubmitReviewSheet(
            service: service,
            revieweeId: revieweeId,
            revieweeName: revieweeName,
            reviewerRole: reviewerRole
        )
        .environment(authManager)
        .environment(reviewsStore)
    }
}
