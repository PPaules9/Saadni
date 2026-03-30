//
//  ServiceDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import Kingfisher

struct ServiceDetailView: View {
 let service: JobService
 @Environment(\.dismiss) var dismiss
 @Environment(AuthenticationManager.self) var authManager
 @Environment(ApplicationsStore.self) var applicationsStore
 @Environment(ServicesStore.self) var servicesStore
 @Environment(WalletStore.self) var walletStore
 @Environment(ConversationsStore.self) var conversationsStore

 @State private var showingApplySheet = false
 @State private var showingApplications = false
 @State private var showingCompletionView = false
 @State private var selectedConversationId: String?
 @State private var isNavigatingToChat = false
 @State private var chatError: String?
 @State private var isCreatingChat = false

 var body: some View {
  ScrollView {
   VStack(alignment: .leading, spacing: 0) {
    // MARK: - Header Image
    ServiceImageSection(service: service)
     .frame(height: 280)

    VStack(alignment: .leading, spacing: 24) {
     // MARK: - Service Title & Price
     VStack(alignment: .leading, spacing: 8) {
      Text(service.title)
       .font(.system(size: 28, weight: .bold))
       .foregroundStyle(Colors.swiftUIColor(.textMain))

      HStack(spacing: 12) {
       Text(service.formattedPrice)
        .font(.system(size: 24, weight: .bold))
        .foregroundStyle(.green)

       Divider()
        .frame(height: 24)

       Text(service.categoryDisplayName)
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.accent.opacity(0.15))
        .cornerRadius(8)
        .foregroundStyle(.accent)

       Spacer()
      }
     }

     // MARK: - Service Details Grid
     VStack(spacing: 16) {
      // Location
      DetailItem(
       icon: "location.fill",
       label: "Location",
       value: service.location.name
      )

      // Duration
      if let hours = service.estimatedDurationHours {
       DetailItem(
        icon: "clock.fill",
        label: "Duration",
        value: String(format: "%.0f hours", hours)
       )
      }

      // Status
      DetailItem(
       icon: "checkmark.circle.fill",
       label: "Status",
       value: service.status.rawValue.capitalized
      )

      // Created Date
      DetailItem(
       icon: "calendar",
       label: "Posted",
       value: formatDate(service.createdAt)
      )
     }
     .padding(16)
     .background(Colors.swiftUIColor(.surfaceWhite))
     .cornerRadius(12)

     // MARK: - Description
     VStack(alignment: .leading, spacing: 8) {
      Text("About This Job")
       .font(.headline)
       .foregroundStyle(Colors.swiftUIColor(.textMain))

      Text(service.description)
       .font(.body)
       .foregroundStyle(Colors.swiftUIColor(.textSecondary))
       .lineSpacing(2)
     }

     // MARK: - Service Requirements
     if let tools = service.specialTools, !tools.isEmpty {
      VStack(alignment: .leading, spacing: 8) {
       Text("Tools & Equipment Needed")
        .font(.headline)
        .foregroundStyle(Colors.swiftUIColor(.textMain))

       Text(tools)
        .font(.body)
        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
        .padding(12)
        .background(Colors.swiftUIColor(.surfaceWhite))
        .cornerRadius(8)
      }
     }

     // Someone Around
     if service.someoneAround {
      HStack(spacing: 12) {
       Image(systemName: "person.fill")
        .foregroundStyle(.accent)
        .font(.title3)

       VStack(alignment: .leading, spacing: 2) {
        Text("Someone Will Be Around")
         .font(.headline)
         .foregroundStyle(Colors.swiftUIColor(.textMain))
        Text("The client will be present during the service")
         .font(.caption)
         .foregroundStyle(Colors.swiftUIColor(.textSecondary))
       }

       Spacer()
      }
      .padding(12)
      .background(Colors.swiftUIColor(.surfaceWhite))
      .cornerRadius(8)
     }

     // MARK: - Provider Section
     ProviderSection(service: service, startChatAction: startChatWithProvider)

     // MARK: - Action Buttons
     VStack(spacing: 12) {
      if !isOwnService {
       if hasAlreadyApplied {
        Button(action: {}) {
         HStack(spacing: 8) {
          Image(systemName: "checkmark.circle.fill")
          Text("Already Applied")
           .fontWeight(.semibold)
         }
         .frame(maxWidth: .infinity)
         .frame(height: 56)
         .foregroundStyle(.white)
         .background(Color.accent.opacity(0.3))
         .cornerRadius(12)
         .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.accent, lineWidth: 1))
        }
        .disabled(true)
       } else {
        BrandButton(
         "Apply Now",
         size: .large,
         isDisabled: false,
         hasIcon: true,
         icon: "hand.raised.fill",
         secondary: false
        ) {
         showingApplySheet = true
        }
       }
      }

      if isOwnService && service.status == .active {
       BrandButton(
        "Mark as Completed",
        size: .large,
        isDisabled: false,
        hasIcon: true,
        icon: "checkmark.circle.fill",
        secondary: false
       ) {
        showingCompletionView = true
       }
      }

      BrandButton(
       isOwnService ? "View Applications" : "Contact Provider",
       size: .large,
       isDisabled: isCreatingChat,
       hasIcon: true,
       icon: isOwnService ? "person.3.fill" : "bubble.left.fill",
       secondary: true
      ) {
       if isOwnService {
        showingApplications = true
       } else {
        startChatWithProvider()
       }
      }
     }
     .padding(.top, 8)
    }
    .padding(20)
   }
  }
  .background(Colors.swiftUIColor(.appBackground))
  .navigationBarTitleDisplayMode(.inline)
  .toolbar {
   ToolbarItem(placement: .topBarTrailing) {
    Button(action: {}) {
     Image(systemName: "heart")
      .foregroundStyle(.red)
    }
   }
  }
  .sheet(isPresented: $showingCompletionView) {
   ServiceCompletionView(service: service)
    .environment(servicesStore)
    .environment(walletStore)
  }
  .navigationDestination(isPresented: $isNavigatingToChat) {
   if let conversationId = selectedConversationId,
      let conversation = conversationsStore.getConversationById(conversationId) {
    ChatDetailView(conversation: conversation)
     .environment(conversationsStore)
     .environment(MessagesStore())
   }
  }
  .sheet(isPresented: $showingApplySheet) {
   ApplyJobSheetContent(service: service)
    .environment(applicationsStore)
  }
  .sheet(isPresented: $showingApplications) {
   ServiceApplicationsSheet(service: service)
    .environment(applicationsStore)
  }
 }

 private var isOwnService: Bool {
  guard let currentUserId = authManager.currentUserId else { return false }
  return service.providerId == currentUserId
 }

 private var hasAlreadyApplied: Bool {
  return applicationsStore.hasApplied(to: service.id)
 }

 private func startChatWithProvider() {
  guard let currentUserId = authManager.currentUserId else { return }

  isCreatingChat = true

  Task {
   do {
    let conversationId = try await conversationsStore.getOrCreateConversation(
     with: service.providerId,
     currentUserId: currentUserId
    )

    await MainActor.run {
     selectedConversationId = conversationId
     isNavigatingToChat = true
     isCreatingChat = false
    }
   } catch {
    await MainActor.run {
     isCreatingChat = false
    }
   }
  }
 }

 private func formatDate(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMM d, yyyy"
  return formatter.string(from: date)
 }
}

// MARK: - Service Image Section with Remote Loading
struct ServiceImageSection: View {
 let service: JobService

 var body: some View {
  ZStack {
   // Background while loading
   Color(.systemGray6)

   // Try to load remote image first, fallback to local
   if let remoteURL = service.image.remoteURL, !remoteURL.isEmpty {
    KFImage(URL(string: remoteURL))
     .resizable()
     .placeholder {
      ProgressView()
       .tint(.accent)
     }
     .aspectRatio(contentMode: .fill)
     .ignoresSafeArea()
   } else if let localImage = service.image.localImage {
    Image(uiImage: localImage)
     .resizable()
     .aspectRatio(contentMode: .fill)
     .ignoresSafeArea()
   } else {
    VStack(spacing: 12) {
     Image(systemName: "briefcase.fill")
      .font(.system(size: 48))
      .foregroundStyle(.gray.opacity(0.5))
     Text("No Image")
      .font(.subheadline)
      .foregroundStyle(.gray)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
   }
  }
  .clipped()
 }
}

// MARK: - Detail Item Component
struct DetailItem: View {
 let icon: String
 let label: String
 let value: String

 var body: some View {
  HStack(spacing: 12) {
   Image(systemName: icon)
    .foregroundStyle(.accent)
    .font(.title3)
    .frame(width: 24)

   VStack(alignment: .leading, spacing: 2) {
    Text(label)
     .font(.caption)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
    Text(value)
     .font(.headline)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
   }

   Spacer()
  }
 }
}

// MARK: - Provider Section
struct ProviderSection: View {
 let service: JobService
 var startChatAction: () -> Void

 var body: some View {
  HStack(spacing: 12) {
   Image(systemName: "person.circle.fill")
    .resizable()
    .frame(width: 48, height: 48)
    .foregroundStyle(.accent.opacity(0.3))

   VStack(alignment: .leading, spacing: 2) {
    Text(service.providerName ?? "Provider")
     .font(.headline)
     .foregroundStyle(Colors.swiftUIColor(.textMain))
    Text("Service Provider")
     .font(.caption)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
   }

   Spacer()

   Button(action: startChatAction) {
    Image(systemName: "message.fill")
     .foregroundStyle(.accent)
     .font(.title3)
     .padding(8)
     .background(Color.accent.opacity(0.15))
     .cornerRadius(8)
   }
  }
  .padding(12)
  .background(Colors.swiftUIColor(.surfaceWhite))
  .cornerRadius(12)
 }
}

// MARK: - Apply Job Sheet
struct ApplyJobSheetContent: View {
 let service: JobService

 @Environment(\.dismiss) var dismiss
 @Environment(AuthenticationManager.self) var authManager
 @Environment(ApplicationsStore.self) var applicationsStore

 @State private var coverMessage = ""
 @State private var proposedPrice = ""
 @State private var isSubmitting = false
 @State private var showError = false
 @State private var errorMessage = ""
 @State private var showSuccess = false

 var isFormValid: Bool {
  !isSubmitting
 }

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 24) {
					// MARK: - Header
					VStack(spacing: 8) {
						Text("Apply for This Job")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.white)
						
						Text(service.title)
							.font(.headline)
							.foregroundStyle(.white)
					}
					.frame(maxWidth: .infinity)
					
					Divider()
						.background(Color.gray.opacity(0.3))
					
					// MARK: - Service Summary
					VStack(spacing: 12) {
						HStack(spacing: 16) {
							Image(systemName: "briefcase.fill")
								.font(.title3)
								.foregroundStyle(.accent)
								.frame(width: 24)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("Price")
									.font(.caption)
									.foregroundStyle(.gray)
								Text(service.formattedPrice)
									.font(.headline)
									.foregroundStyle(.white)
							}
							
							Spacer()
						}
						
						HStack(spacing: 16) {
							Image(systemName: "location.fill")
								.font(.title3)
								.foregroundStyle(.accent)
								.frame(width: 24)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("Location")
									.font(.caption)
									.foregroundStyle(.gray)
								Text(service.location.name)
									.font(.headline)
									.foregroundStyle(.white)
							}
							
							Spacer()
						}
						
						if let hours = service.estimatedDurationHours {
							HStack(spacing: 16) {
								Image(systemName: "clock.fill")
									.font(.title3)
									.foregroundStyle(.accent)
									.frame(width: 24)
								
								VStack(alignment: .leading, spacing: 4) {
									Text("Duration")
										.font(.caption)
										.foregroundStyle(.gray)
									Text(String(format: "%.0f hours", hours))
										.font(.headline)
										.foregroundStyle(.white)
								}
								
								Spacer()
							}
						}
					}
					.padding(12)
					.background(Color(.systemGray6).opacity(0.3))
					.cornerRadius(8)
					
					Divider()
						.background(Color.gray.opacity(0.3))
					
					// MARK: - Cover Message Section
					VStack(alignment: .leading, spacing: 8) {
						Text("Cover Message (Optional)")
							.font(.subheadline)
							.foregroundStyle(.gray)
						
						Text("Tell the job poster why you're interested and why you're a good fit")
							.font(.caption)
							.foregroundStyle(.gray.opacity(0.7))
						
						TextEditor(text: $coverMessage)
							.frame(height: 120)
							.padding(8)
							.background(Color(.systemGray6).opacity(0.3))
							.cornerRadius(8)
							.foregroundStyle(.white)
							.scrollContentBackground(.hidden)
						
						Text("\(coverMessage.count)/500")
							.font(.caption)
							.foregroundStyle(.gray)
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
					
					// MARK: - Proposed Price Section
					VStack(alignment: .leading, spacing: 8) {
						Text("Proposed Price (Optional)")
							.font(.subheadline)
							.foregroundStyle(.gray)
						
						Text("Counter-offer a different price if needed")
							.font(.caption)
							.foregroundStyle(.gray.opacity(0.7))
						
						HStack(spacing: 8) {
							Image(systemName: "dollarsign")
								.foregroundStyle(.accent)
							
							TextField("Enter price", text: $proposedPrice)
								.keyboardType(.decimalPad)
								.foregroundStyle(.white)
						}
						.padding(12)
						.background(Color(.systemGray6).opacity(0.3))
						.cornerRadius(8)
						
						if !proposedPrice.isEmpty && Double(proposedPrice) == nil {
							Text("Please enter a valid number")
								.font(.caption)
								.foregroundStyle(.red)
						}
					}
					
					Spacer()
					
					// MARK: - Submit Button
					Button {
						Task {
							await submitApplication()
						}
					} label: {
						if isSubmitting {
							HStack {
								ProgressView()
									.tint(.white)
								Text("Submitting...")
							}
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color.gray.opacity(0.5))
							.cornerRadius(12)
							.foregroundStyle(.white)
						} else {
							Text("Submit Application")
								.font(.headline)
								.frame(maxWidth: .infinity)
								.padding()
								.background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
								.cornerRadius(12)
								.foregroundStyle(.white)
						}
					}
					.disabled(!isFormValid)
				}
				.padding()
			}
			.navigationTitle("Apply for Job")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
					.foregroundStyle(.blue)
				}
			}
			.alert("Error", isPresented: $showError) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(errorMessage)
			}
			.alert("Application Sent!", isPresented: $showSuccess) {
				Button("OK", role: .cancel) {
					dismiss()
				}
			} message: {
				Text("Your application has been submitted successfully. The job poster will review it soon.")
			}
		
	}
 }

 private func submitApplication() async {
  guard let currentUserId = authManager.currentUserId,
        let currentUser = authManager.currentUser else {
   errorMessage = "You must be logged in to submit an application"
   showError = true
   return
  }

  // Validate proposed price if provided
  if !proposedPrice.isEmpty, Double(proposedPrice) == nil {
   errorMessage = "Please enter a valid price"
   showError = true
   return
  }

  isSubmitting = true

  do {
   try await applicationsStore.submitApplication(
    serviceId: service.id,
    providerId: service.providerId,
    applicantId: currentUserId,
    applicantName: currentUser.displayName ?? "User",
    applicantPhotoURL: currentUser.photoURL,
    coverMessage: coverMessage.isEmpty ? nil : coverMessage
   )

   showSuccess = true
   isSubmitting = false
  } catch {
   errorMessage = "Failed to submit application: \(error.localizedDescription)"
   showError = true
   isSubmitting = false
  }
 }
}

// MARK: - Service Applications Sheet

struct ApplicantID: Identifiable {
    let id: String
}

struct ServiceApplicationsSheet: View {
    let service: JobService
    @Environment(\.dismiss) var dismiss
    @Environment(ApplicationsStore.self) var applicationsStore

    @State private var applicantUsers: [String: User] = [:]
    @State private var isLoading = true
    @State private var selectedApplicantID: ApplicantID?
    @State private var actionError: String?
    @State private var showError = false

    var applications: [JobApplication] {
        applicationsStore.getApplications(for: service.id)
            .sorted { $0.appliedAt > $1.appliedAt }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading && applications.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Colors.swiftUIColor(.appBackground))
                } else if applications.isEmpty {
                    ContentUnavailableView(
                        "No Applications Yet",
                        systemImage: "person.fill.questionmark",
                        description: Text("No one has applied to this job yet")
                    )
                    .background(Colors.swiftUIColor(.appBackground))
                } else {
                    List {
                        ForEach(applications) { application in
                            applicationRow(application)
                                .listRowBackground(Colors.swiftUIColor(.surfaceWhite))
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Colors.swiftUIColor(.appBackground))
                }
            }
            .navigationTitle("Applications (\(applications.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(actionError ?? "An error occurred")
            }
        }
        .task {
            await loadApplicantUsers()
            isLoading = false
        }
        .sheet(item: $selectedApplicantID) { identifier in
            UserProfileSheet(userId: identifier.id)
        }
    }

    @ViewBuilder
    private func applicationRow(_ application: JobApplication) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: avatar + name + status badge
            HStack(spacing: 12) {
                if let photoURL = applicantUsers[application.applicantId]?.photoURL,
                   let url = URL(string: photoURL) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 44, height: 44)
                        .overlay(Text("👤").font(.system(size: 18)))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(applicantUsers[application.applicantId]?.displayName ?? application.applicantName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    if let rating = applicantUsers[application.applicantId]?.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                statusBadge(for: application.status)
            }

            // Cover message
            if let message = application.coverMessage, !message.isEmpty {
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            // Action buttons
            HStack(spacing: 8) {
                if application.status == .pending {
                    Button {
                        Task { await accept(application) }
                    } label: {
                        Label("Accept", systemImage: "checkmark")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                    Button {
                        Task { await reject(application) }
                    } label: {
                        Label("Reject", systemImage: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    selectedApplicantID = ApplicantID(id: application.applicantId)
                } label: {
                    Text("View Profile")
                        .font(.system(size: 13, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func statusBadge(for status: JobApplicationStatus) -> some View {
        let (text, color): (String, Color) = {
            switch status {
            case .pending: return ("Pending", .orange)
            case .accepted: return ("Accepted", .green)
            case .rejected: return ("Rejected", .red)
            case .withdrawn: return ("Withdrawn", .gray)
            }
        }()

        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(6)
    }

    private func loadApplicantUsers() async {
        for application in applications {
            guard applicantUsers[application.applicantId] == nil else { continue }
            if let user = try? await FirestoreService.shared.fetchUser(id: application.applicantId) {
                applicantUsers[application.applicantId] = user
            }
        }
    }

    private func accept(_ application: JobApplication) async {
        do {
            try await applicationsStore.acceptApplication(
                applicationId: application.id,
                serviceId: service.id
            )
        } catch {
            actionError = error.localizedDescription
            showError = true
        }
    }

    private func reject(_ application: JobApplication) async {
        do {
            try await applicationsStore.updateApplicationStatus(
                applicationId: application.id,
                newStatus: .rejected
            )
        } catch {
            actionError = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
 NavigationStack {
  ServiceDetailView(
   service: JobService(
    title: "Professional House Cleaning",
    price: 500,
    location: ServiceLocation(name: "Cairo, Egypt", latitude: nil, longitude: nil),
    description: "Comprehensive house cleaning service including deep cleaning, dusting, mopping, and sanitizing all areas of your home.",
    image: ServiceImage(),
		category: .communityAndOutdoor,
    providerId: "provider_1",
    someoneAround: true,
    specialTools: "Vacuum cleaner, mop, cleaning supplies provided",
    estimatedDurationHours: 8
   )
  )
 }
 .environment(ApplicationsStore())
 .environment(UserCache())
 .environment(AuthenticationManager(userCache: UserCache()))
 .environment(ServicesStore())
 .environment(WalletStore())
 .environment(ConversationsStore())
 .environment(MessagesStore())
}
