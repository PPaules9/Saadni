//
//  ProfileSetupView.swift
//  GoodShift
//
//  Created by Pavly Paules on 04/04/2026.
//

import SwiftUI

struct ProfileSetupView: View {
    let user: User
    let isJobSeeker: Bool

    @Environment(UserCache.self) var userCache
    @State private var currentStep = 0
    @State private var isSaving = false

    // Shared fields
    @State private var displayName = ""
    @State private var phoneNumber = ""
    @State private var city = ""
    @State private var bio = ""

    // Service provider (worker) fields
    @State private var ageText = ""
    @State private var gender: String? = nil

    // Job seeker (employer) fields
    @State private var isCompany = false
    @State private var companyName = ""
    @State private var industryCategory = ""
    @State private var contactPersonName = ""
    @State private var contactPersonPhone = ""

    private var totalSteps: Int { isJobSeeker ? 3 : 3 }

    var body: some View {
        ZStack {
            Color(Colors.swiftUIColor(.appBackground))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    if currentStep > 0 {
                        Button {
                            withAnimation(.easeInOut) { currentStep -= 1 }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                        }
                    } else {
                        Spacer().frame(width: 24)
                    }

                    Spacer()

                    Button("Skip for now") {
                        Task { await saveAndProceed(skip: true) }
                    }
                    .font(.subheadline)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    .disabled(isSaving)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Progress indicator
                HStack(spacing: 6) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Capsule()
                            .fill(i <= currentStep ? Color.accent : Colors.swiftUIColor(.borderPrimary))
                            .frame(height: 4)
                            .animation(.easeInOut, value: currentStep)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Step content
                TabView(selection: $currentStep) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        stepView(for: step)
                            .tag(step)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)

                // Bottom navigation
                VStack(spacing: 12) {
                    Button {
                        if currentStep < totalSteps - 1 {
                            withAnimation(.easeInOut) { currentStep += 1 }
                        } else {
                            Task { await saveAndProceed(skip: false) }
                        }
                    } label: {
                        Group {
                            if isSaving {
                                ProgressView().tint(.white)
                            } else {
                                Text(currentStep < totalSteps - 1 ? "Continue" : "Complete Profile")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.accent)
                        .clipShape(Capsule())
                    }
                    .disabled(isSaving)

                    Text("Step \(currentStep + 1) of \(totalSteps)")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Step Router

    @ViewBuilder
    private func stepView(for step: Int) -> some View {
        ScrollView(showsIndicators: false) {
            if isJobSeeker {
                jobSeekerStep(step)
            } else {
                serviceProviderStep(step)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Job Seeker Steps (employer / "Need Help")

    @ViewBuilder
    private func jobSeekerStep(_ step: Int) -> some View {
        switch step {
        case 0:
            stepContainer(
                icon: "building.2.fill",
                title: "Who are you?",
                subtitle: "Tell workers a bit about the role"
            ) {
                VStack(spacing: 12) {
                    HStack {
                        Text("I represent a company")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                        Spacer()
                        Toggle("", isOn: $isCompany).tint(.accent)
                    }
                    .padding(.horizontal)

                    if isCompany {
                        BrandTextField(hasTitle: true, title: "Company / Brand Name", placeholder: "e.g., McDonald's, Zara", text: $companyName)
                    } else {
                        BrandTextField(hasTitle: true, title: "Full Name", placeholder: "Your name", text: $displayName)
                    }
                    BrandTextField(hasTitle: true, title: "Industry (Optional)", placeholder: "e.g., Fast Food, Retail", text: $industryCategory)
                }
            }

        case 1:
            stepContainer(
                icon: "phone.fill",
                title: "Contact Details",
                subtitle: "How should workers reach you?"
            ) {
                VStack(spacing: 12) {
                    BrandTextField(hasTitle: true, title: "Contact Person Name", placeholder: "Name", text: $contactPersonName)
                    BrandTextField(hasTitle: true, title: "Contact Phone", placeholder: "Phone number", text: $contactPersonPhone)
                        .keyboardType(.phonePad)
                    BrandTextField(hasTitle: true, title: "City", placeholder: "Your city", text: $city)
                }
            }

        case 2:
            stepContainer(
                icon: "text.alignleft",
                title: "About Your Business",
                subtitle: "Describe the type of work you offer"
            ) {
                BrandTextEditor(hasTitle: false, title: "", placeholder: "Describe your business or the type of shifts you typically offer...", text: $bio)
            }

        default:
            EmptyView()
        }
    }

    // MARK: - Service Provider Steps (worker / "Earn Cash")

    @ViewBuilder
    private func serviceProviderStep(_ step: Int) -> some View {
        switch step {
        case 0:
            stepContainer(
                icon: "person.fill",
                title: "Personal Info",
                subtitle: "Let employers know who you are"
            ) {
                VStack(spacing: 12) {
                    BrandTextField(hasTitle: true, title: "Full Name", placeholder: "Your name", text: $displayName)

                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age")
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            TextField("e.g., 22", text: $ageText)
                                .keyboardType(.numberPad)
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .padding(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Colors.swiftUIColor(.borderPrimary), lineWidth: 1)
                                )
                        }
                        .frame(width: 100)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender")
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            Menu {
                                Button("Male") { gender = "male" }
                                Button("Female") { gender = "female" }
                                Button("Prefer not to say") { gender = "prefer_not_to_say" }
                            } label: {
                                HStack {
                                    Text(genderLabel)
                                        .font(.caption)
                                        .fontDesign(.monospaced)
                                        .foregroundStyle(
                                            gender == nil
                                                ? Colors.swiftUIColor(.textSecondary)
                                                : Colors.swiftUIColor(.textMain)
                                        )
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.caption2)
                                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                }
                                .padding(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Colors.swiftUIColor(.borderPrimary), lineWidth: 1)
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }

        case 1:
            stepContainer(
                icon: "phone.fill",
                title: "Contact & Location",
                subtitle: "How can employers reach you?"
            ) {
                VStack(spacing: 12) {
                    BrandTextField(hasTitle: true, title: "Contact Phone", placeholder: "Your phone number", text: $contactPersonPhone)
                        .keyboardType(.phonePad)
                    BrandTextField(hasTitle: true, title: "City", placeholder: "Your city", text: $city)
                }
            }

        case 2:
            stepContainer(
                icon: "text.alignleft",
                title: "About You",
                subtitle: "Tell employers about your skills and experience"
            ) {
                BrandTextEditor(hasTitle: false, title: "", placeholder: "Describe your skills, experience, and availability...", text: $bio)
            }

        default:
            EmptyView()
        }
    }

    // MARK: - Step Container

    @ViewBuilder
    private func stepContainer<Content: View>(
        icon: String,
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundStyle(.accent)

                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }
            .padding(.horizontal)

            content()
                .padding(.horizontal)

            Spacer(minLength: 40)
        }
        .padding(.top, 32)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Helpers

    private var genderLabel: String {
        switch gender {
        case "male":              return "Male"
        case "female":            return "Female"
        case "prefer_not_to_say": return "Prefer not to say"
        default:                  return "Select..."
        }
    }

    // MARK: - Save

    private func saveAndProceed(skip: Bool) async {
        isSaving = true

        var updatedUser = user
        updatedUser.isJobSeeker = isJobSeeker
        updatedUser.isServiceProvider = !isJobSeeker

        if !skip {
            if isJobSeeker {
                if isCompany {
                    updatedUser.companyName = companyName.isEmpty ? nil : companyName
                } else {
                    updatedUser.displayName = displayName.isEmpty ? nil : displayName
                }
                updatedUser.industryCategory = industryCategory.isEmpty ? nil : industryCategory
                updatedUser.contactPersonName = contactPersonName.isEmpty ? nil : contactPersonName
                updatedUser.contactPersonPhone = contactPersonPhone.isEmpty ? nil : contactPersonPhone
                updatedUser.city = city.isEmpty ? nil : city
                updatedUser.bio = bio.isEmpty ? nil : bio
                updatedUser.isCompany = isCompany
            } else {
                updatedUser.displayName = displayName.isEmpty ? nil : displayName
                updatedUser.age = Int(ageText)
                updatedUser.gender = gender
                updatedUser.contactPersonPhone = contactPersonPhone.isEmpty ? nil : contactPersonPhone
                updatedUser.city = city.isEmpty ? nil : city
                updatedUser.bio = bio.isEmpty ? nil : bio
            }

            updatedUser.recalculateProfileCompletion()
        }

        await userCache.updateUser(updatedUser)

        let role = isJobSeeker ? "job_seeker" : "service_provider"
        AnalyticsService.shared.track(.profileSetupCompleted(role: role, skipped: skip))
        AnalyticsService.shared.setUserProperties(role: role)

        await MainActor.run { isSaving = false }
    }
}
