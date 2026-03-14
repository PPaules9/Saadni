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

#Preview {
 NavigationStack {
  ServiceDetailView(
   service: JobService(
    title: "Professional House Cleaning",
    price: 500,
    location: ServiceLocation(name: "Cairo, Egypt", latitude: nil, longitude: nil),
    description: "Comprehensive house cleaning service including deep cleaning, dusting, mopping, and sanitizing all areas of your home.",
    image: ServiceImage(),
    category: .homeCleaning,
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
