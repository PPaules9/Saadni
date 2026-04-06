//
//  UserProfileSheet.swift
//  GoodShift
//
//  Created by Pavly Paules on 28/03/2026.
//

import SwiftUI

// MARK: - State Holder (keeps FirestoreService out of the View)
@Observable private final class UserProfileLoader {
    var user: User?
    var isLoading = true
    var error: String?

    func load(userId: String) async {
        isLoading = true
        error = nil
        do {
            user = try await FirestoreService.shared.fetchUser(id: userId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}

struct UserProfileSheet: View {
    let userId: String
    @Environment(\.dismiss) var dismiss

    @State private var loader = UserProfileLoader()
    private var user: User? { loader.user }
    private var isLoading: Bool { loader.isLoading }
    private var loadError: String? { loader.error }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if let error = loadError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        Text("Failed to load profile")
                            .font(.system(size: 16, weight: .semibold))
                        Text(error)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Colors.swiftUIColor(.appBackground))
                } else if let user = user {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 12) {
                                if let photoURL = user.photoURL, let url = URL(string: photoURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 100, height: 100)
                                    }
                                } else {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 100, height: 100)
                                        .overlay(Text("👤").font(.system(size: 40)))
                                }

                                // Name or Company Name
                                if user.isCompany {
                                    Text(user.companyName ?? "Company")
                                        .font(.system(size: 20, weight: .bold))
                                } else {
                                    Text(user.displayName ?? "User")
                                        .font(.system(size: 20, weight: .bold))
                                }

                                // Rating
                                if let rating = user.rating {
                                    HStack(spacing: 4) {
                                        HStack(spacing: 2) {
                                            ForEach(0..<5, id: \.self) { index in
                                                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                        Text("(\(user.totalReviews))")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            // About Section
                            if let bio = user.bio, !bio.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    Text(bio)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }

                            // Info Rows
                            VStack(spacing: 12) {
                                if user.isJobSeeker && !user.isServiceProvider {
                                    jobSeekerInfo
                                } else if user.isServiceProvider {
                                    providerInfo
                                }
                            }

                            Spacer()
                        }
                        .padding(16)
                    }
                    .background(Colors.swiftUIColor(.appBackground))
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await loader.load(userId: userId)
        }
    }

    var jobSeekerInfo: some View {
        VStack(spacing: 12) {
            if let age = user?.age {
                InfoRow(icon: "🎂", label: "Age", value: "\(age)")
            }
            if let gender = user?.gender {
                InfoRow(icon: "👤", label: "Gender", value: genderDisplay(gender))
            }
            if let city = user?.city {
                InfoRow(icon: "📍", label: "Location", value: city)
            }
            if let phone = user?.phoneNumber {
                InfoRow(icon: "📞", label: "Phone", value: phone)
            }
        }
    }

    var providerInfo: some View {
        VStack(spacing: 12) {
            InfoRow(icon: "🏢", label: "Services Posted", value: "\(user?.totalServicesPosted ?? 0)")
            InfoRow(icon: "✅", label: "Jobs Completed", value: "\(user?.totalJobsCompleted ?? 0)")
            if let phone = user?.phoneNumber {
                InfoRow(icon: "📞", label: "Phone", value: phone)
            }
        }
    }

    private func genderDisplay(_ gender: String) -> String {
        switch gender {
        case "male":
            return "Male"
        case "female":
            return "Female"
        case "prefer_not_to_say":
            return "Prefer not to say"
        default:
            return gender
        }
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 18))
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    UserProfileSheet(userId: "test-user-id")
}
