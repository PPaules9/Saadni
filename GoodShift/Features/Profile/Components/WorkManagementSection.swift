//
//  WorkManagementSection.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

struct WorkManagementSection: View {
    let userId: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Work")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                NavigationLink {
                    CompletedServicesView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.accent)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Completed Services")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                            Text("View your finished work")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                    .contentShape(Rectangle())
                }
                .padding(16)

                Divider()
                    .padding(.vertical, 0)

                NavigationLink {
                    UserReviewsView(userId: userId)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.yellow)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Reviews")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                            Text("See what others say")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    }
                    .contentShape(Rectangle())
                }
                .padding(16)
            }
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    WorkManagementSection(userId: "user_1")
}
