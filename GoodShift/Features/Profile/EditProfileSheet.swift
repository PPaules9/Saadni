//
//  EditProfileSheet.swift
//  GoodShift
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
	@State private var ageText = ""
	@State private var gender: String?
	@State private var phoneNumber = ""
	@State private var city = ""
	@State private var bio = ""

	// Provider fields
	@State private var isCompany = false
	@State private var companyName = ""
	@State private var industryCategory = ""
	@State private var contactPersonName = ""
	@State private var contactPersonPhone = ""

	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()

			NavigationStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: 24) {
						if let error = saveError {
							HStack(spacing: 12) {
								Image(systemName: "exclamationmark.circle.fill")
									.foregroundStyle(Colors.swiftUIColor(.borderError))
								Text(error)
									.font(.caption)
									.fontDesign(.monospaced)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
								Spacer()
							}
							.padding(12)
							.background(Colors.swiftUIColor(.borderError).opacity(0.1))
							.cornerRadius(8)
							.padding(.horizontal)
						}

						if let user = user {
							if user.isJobSeeker && !user.isServiceProvider {
								needWork
							} else if user.isServiceProvider {
								jobProvider
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
							Task { await saveChanges() }
						}
						.disabled(isSaving)
					}
				}
			}
		}
		.onAppear {
			loadUserData()
		}
	}

	// MARK: - Job Provider Form (shown to workers / isServiceProvider)

	var jobProvider: some View {
		VStack(spacing: 24) {
			VStack(alignment: .leading, spacing: 16) {
				sectionHeader("Personal Information")
					.padding(.horizontal)

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

					BrandTextField(hasTitle: true, title: "City", placeholder: "Your city", text: $city)
				}
				.padding(.horizontal)
			}

			VStack(alignment: .leading, spacing: 16) {
				sectionHeader("Business Information")
					.padding(.horizontal)

				VStack(alignment: .leading, spacing: 12) {
					HStack {
						Text("I represent a company")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						Spacer()
						Toggle("", isOn: $isCompany)
							.tint(.accent)
					}
					.padding(.horizontal)

					VStack(spacing: 12) {
						if isCompany {
							BrandTextField(hasTitle: true, title: "Company/Brand Name", placeholder: "e.g., McDonald's, Zara", text: $companyName)
						}
						BrandTextField(hasTitle: true, title: "Industry Category (Optional)", placeholder: "e.g., Fast Food, Retail", text: $industryCategory)
						BrandTextField(hasTitle: true, title: "Contact Person Name *", placeholder: "Name", text: $contactPersonName)
						BrandTextField(hasTitle: true, title: "Contact Phone *", placeholder: "Phone Number", text: $contactPersonPhone)
							.keyboardType(.phonePad)
					}
					.padding(.horizontal)
				}
			}

			VStack(alignment: .leading, spacing: 16) {
				sectionHeader("About You")
					.padding(.horizontal)

				BrandTextEditor(hasTitle: false, title: "", placeholder: "Tell employers about yourself...", text: $bio)
					.padding(.horizontal)
			}
		}
	}

	// MARK: - Need Work Form (shown to employers / isJobSeeker)

	var needWork: some View {
		VStack(spacing: 24) {
			// Account Type
			VStack(alignment: .leading, spacing: 12) {
				sectionHeader("Account Type")
					.padding(.horizontal)

				HStack {
					Text("I represent a company")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textMain))
					Spacer()
					Toggle("", isOn: $isCompany)
						.tint(.accent)
				}
				.padding(.horizontal)
			}

			// Identity
			VStack(alignment: .leading, spacing: 16) {
				sectionHeader(isCompany ? "Company Details" : "Personal Information")
					.padding(.horizontal)

				VStack(spacing: 12) {
					if isCompany {
						BrandTextField(hasTitle: true, title: "Company/Brand Name", placeholder: "e.g., McDonald's, Zara", text: $companyName)
					} else {
						BrandTextField(hasTitle: true, title: "Full Name", placeholder: "Your name", text: $displayName)
					}
					BrandTextField(hasTitle: true, title: "Industry Category", placeholder: "e.g., Fast Food, Retail", text: $industryCategory)
					BrandTextField(hasTitle: true, title: "Phone", placeholder: "Your phone number", text: $phoneNumber)
						.keyboardType(.phonePad)
				}
				.padding(.horizontal)
			}

			// Contact Person
			VStack(alignment: .leading, spacing: 16) {
				sectionHeader("Contact Person")
					.padding(.horizontal)

				VStack(spacing: 12) {
					BrandTextField(hasTitle: true, title: "Contact Person Name", placeholder: "Name", text: $contactPersonName)
					BrandTextField(hasTitle: true, title: "Contact Phone", placeholder: "Phone Number", text: $contactPersonPhone)
						.keyboardType(.phonePad)
				}
				.padding(.horizontal)
			}

			// Bio
			VStack(alignment: .leading, spacing: 16) {
				sectionHeader("About Your Business")
					.padding(.horizontal)

				BrandTextEditor(hasTitle: false, title: "", placeholder: "Describe your business or the type of shifts you offer...", text: $bio)
					.padding(.horizontal)
			}
		}
	}

	// MARK: - Helpers

	private var genderLabel: String {
		switch gender {
		case "male":             return "Male"
		case "female":           return "Female"
		case "prefer_not_to_say": return "Prefer not to say"
		default:                 return "Select..."
		}
	}

	@ViewBuilder
	private func sectionHeader(_ title: String) -> some View {
		Text(title.uppercased())
			.font(.caption2)
			.fontWeight(.semibold)
			.fontDesign(.monospaced)
			.foregroundStyle(Colors.swiftUIColor(.textSecondary))
	}

	private func loadUserData() {
		guard let currentUser = authManager.currentUser else { return }
		user = currentUser

		displayName      = currentUser.displayName ?? ""
		ageText          = currentUser.age.map { String($0) } ?? ""
		gender           = currentUser.gender
		phoneNumber      = currentUser.phoneNumber ?? ""
		city             = currentUser.city ?? ""
		bio              = currentUser.bio ?? ""
		isCompany          = currentUser.isCompany
		companyName        = currentUser.companyName ?? ""
		industryCategory   = currentUser.industryCategory ?? ""
		contactPersonName  = currentUser.contactPersonName ?? ""
		contactPersonPhone = currentUser.contactPersonPhone ?? ""
	}

	private func saveChanges() async {
		guard var currentUser = authManager.currentUser else { return }

		isSaving = true
		saveError = nil

		currentUser.displayName      = displayName.isEmpty ? nil : displayName
		currentUser.age              = Int(ageText)
		currentUser.gender           = gender
		currentUser.phoneNumber      = phoneNumber.isEmpty ? nil : phoneNumber
		currentUser.city             = city.isEmpty ? nil : city
		currentUser.bio              = bio.isEmpty ? nil : bio
		currentUser.isCompany          = isCompany
		currentUser.companyName        = companyName.isEmpty ? nil : companyName
		currentUser.industryCategory   = industryCategory.isEmpty ? nil : industryCategory
		currentUser.contactPersonName  = contactPersonName.isEmpty ? nil : contactPersonName
		currentUser.contactPersonPhone = contactPersonPhone.isEmpty ? nil : contactPersonPhone

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

#Preview {
	let userCache = UserCache()
	let authManager = AuthenticationManager(userCache: userCache)
	return EditProfileSheet()
		.environment(authManager)
		.environment(userCache)
}
