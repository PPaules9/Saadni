import SwiftUI

struct CompletionRequestBanner: View {
    let service: JobService
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Job Completion Requested")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text(service.title)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(14)
            .background(Color.accentColor)
            .cornerRadius(14)
        }
    }
}
