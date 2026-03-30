//
//  EditProfileSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 28/03/2026.
//

import SwiftUI

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(UserCache.self) var userCache

    @State private var user: User?
    @State private var isSaving = false
    @State private var saveError: String?

    // Job Seeker fields
    @State private var displayName = ""
    @State private var age: Int?
    @State private var gender: String?
    @State private var phoneNumber = ""
    @State private var city = ""
    @State private var bio = ""

    // Provider fields
    @State private var isCompany = false
    @State private var companyName = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let error = saveError {
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 14, weight: .regular))
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.systemRed).opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }

                    if let user = user {
                        if user.isJobSeeker && !user.isServiceProvider {
                            jobSeekerForm
                        } else if user.isServiceProvider {
                            providerForm
                        }
                    }

                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        Task {
                            await saveChanges()
                        }
                    }
                    .disabled(isSaving)
                }
            }
        }
        .onAppear {
            loadUserData()
        }
    }

    // MARK: - Job Seeker Form

    var jobSeekerForm: some View {
        VStack(spacing: 16) {
            FormSection(title: "Personal Information") {
                VStack(spacing: 12) {
                    FormTextField(label: "Full Name", placeholder: "Your name", text: $displayName)

                    HStack(spacing: 12) {
                        FormNumberField(label: "Age", value: $age)
                        Picker("Gender", selection: $gender) {
                            Text("Select...").tag(nil as String?)
                            Text("Male").tag("male" as String?)
                            Text("Female").tag("female" as String?)
                            Text("Prefer not to say").tag("prefer_not_to_say" as String?)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    FormTextField(label: "Phone", placeholder: "Your phone number", text: $phoneNumber)

                    FormTextField(label: "City", placeholder: "Your city", text: $city)
                }
            }

            FormSection(title: "About You") {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .font(.system(size: 14, weight: .regular))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Provider Form

    var providerForm: some View {
        VStack(spacing: 16) {
            FormSection(title: "Company Information") {
                VStack(spacing: 12) {
                    Toggle("I'm a company", isOn: $isCompany)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
            }

            FormSection(title: isCompany ? "Company Details" : "Personal Information") {
                VStack(spacing: 12) {
                    if isCompany {
                        FormTextField(label: "Company Name", placeholder: "Your company name", text: $companyName)
                    } else {
                        FormTextField(label: "Full Name", placeholder: "Your name", text: $displayName)
                    }

                    FormTextField(label: "Phone", placeholder: "Your phone number", text: $phoneNumber)
                }
            }

            FormSection(title: "About Your Services") {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .font(.system(size: 14, weight: .regular))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers

    private func loadUserData() {
        guard let currentUser = authManager.currentUser else { return }
        user = currentUser

        displayName = currentUser.displayName ?? ""
        age = currentUser.age
        gender = currentUser.gender
        phoneNumber = currentUser.phoneNumber ?? ""
        city = currentUser.city ?? ""
        bio = currentUser.bio ?? ""
        isCompany = currentUser.isCompany
        companyName = currentUser.companyName ?? ""
    }

    private func saveChanges() async {
        guard var currentUser = authManager.currentUser else { return }

        isSaving = true
        saveError = nil

        currentUser.displayName = displayName.isEmpty ? nil : displayName
        currentUser.age = age
        currentUser.gender = gender
        currentUser.phoneNumber = phoneNumber.isEmpty ? nil : phoneNumber
        currentUser.city = city.isEmpty ? nil : city
        currentUser.bio = bio.isEmpty ? nil : bio
        currentUser.isCompany = isCompany
        currentUser.companyName = isCompany ? (companyName.isEmpty ? nil : companyName) : nil

        // Recalculate profile completion before saving
        currentUser.recalculateProfileCompletion()

        do {
            await userCache.updateUser(currentUser)
            isSaving = false
            dismiss()
        } catch {
            saveError = "Failed to save changes. Please try again."
            isSaving = false
        }
    }
}

// MARK: - Form Helper Views

struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 12)

            content()
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

struct FormTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)

            TextField(placeholder, text: $text)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .font(.system(size: 14, weight: .regular))
        }
    }
}

struct FormNumberField: View {
    let label: String
    @Binding var value: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)

            TextField("", value: $value, formatter: NumberFormatter())
                .frame(height: 40)
                .padding(.horizontal, 12)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .font(.system(size: 14, weight: .regular))
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    let userCache = UserCache()
    let authManager = AuthenticationManager(userCache: userCache)
    return EditProfileSheet()
        .environment(authManager)
        .environment(userCache)
}
