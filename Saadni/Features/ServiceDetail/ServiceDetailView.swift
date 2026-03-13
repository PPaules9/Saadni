//
//  ServiceDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ServiceDetailView: View {
 let service: JobService
 @Environment(\.dismiss) var dismiss
 @Environment(AuthenticationManager.self) var authManager
 @Environment(ApplicationsStore.self) var applicationsStore
 @Environment(ServicesStore.self) var servicesStore
 // @Environment(WalletStore.self) var walletStore // TODO: Fix WalletStore

 @State private var showingApplySheet = false
 @State private var showingApplications = false
 @State private var showingCompletionView = false
 
 var body: some View {
  ScrollView {
   VStack(alignment: .leading, spacing: 20) {
    
    // Header Image
    if let uiImage = service.image.localImage {
     Image(uiImage: uiImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(height: 250)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    } else {
     ZStack {
      Color(.systemGray6)
      Image(systemName: "briefcase.fill")
       .resizable()
       .aspectRatio(contentMode: .fit)
       .padding(60)
       .foregroundStyle(.gray.opacity(0.5))
     }
     .frame(height: 250)
     .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // Info Row
    HStack {
     Text(formatDate(service.createdAt))
      .foregroundStyle(.gray)
     Text("|")
      .foregroundStyle(.gray)
     Text(service.location.name)
      .foregroundStyle(.gray)
     
     Spacer()
     
     Text(service.formattedPrice)
      .font(.title3)
      .fontWeight(.bold)
      .foregroundStyle(.green)
    }
    .font(.subheadline)
    
    // Title & Description
    VStack(alignment: .leading, spacing: 10) {
     Text(service.title)
      .font(.largeTitle)
      .fontWeight(.bold)
      .foregroundStyle(.white)
     
     Text(service.description)
      .font(.body)
      .foregroundStyle(.gray)
    }
    
    // Category Badge
    HStack {
     Text(service.categoryDisplayName)
      .font(.caption)
      .fontWeight(.bold)
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(Color.green.opacity(0.3))
      .cornerRadius(8)
      .foregroundStyle(.green)
     
     Spacer()
    }
    
    // Map Placeholder
    ZStack(alignment: .bottomTrailing) {
     Color(.systemGray6).opacity(0.2)
     
     Path { path in
      path.move(to: CGPoint(x: 0, y: 50))
      path.addLine(to: CGPoint(x: 400, y: 150))
      path.move(to: CGPoint(x: 50, y: 0))
      path.addLine(to: CGPoint(x: 50, y: 200))
     }
     .stroke(Color.gray.opacity(0.3), lineWidth: 2)
     
     VStack {
      Image(systemName: "map.fill")
       .font(.largeTitle)
       .foregroundStyle(.gray)
      Text(service.location.name)
       .font(.title)
       .fontWeight(.bold)
       .foregroundStyle(.white)
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity)
     
     Button {
      // Action
     } label: {
      HStack {
       Image(systemName: "map")
       Text("Get Directions")
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color(.systemGray6).opacity(0.8))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .foregroundStyle(.white)
     }
     .padding()
    }
    .frame(height: 200)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay(
     RoundedRectangle(cornerRadius: 20)
      .stroke(Color.white.opacity(0.1), lineWidth: 1)
    )
    
    // Provider Info
    HStack {
     Image(systemName: "person.circle.fill")
      .resizable()
      .frame(width: 50, height: 50)
      .foregroundStyle(.gray)
      .background(Color(.systemGray6).opacity(0.3))
      .clipShape(Circle())
     
     VStack(alignment: .leading) {
      Text(service.providerName ?? "Unknown")
       .font(.headline)
       .foregroundStyle(.white)
      Text("Joined 6 February 2026")
       .font(.caption)
       .foregroundStyle(.gray)
     }
     
     Spacer()
     
     Button {
      // Chat Action
     } label: {
      Image(systemName: "bubble.left.fill")
       .font(.title2)
       .foregroundStyle(.green)
     }
    }
    .padding()
    
    // Action Buttons Section
    VStack(spacing: 12) {
     // Apply Button
     if !isOwnService {
      if hasAlreadyApplied {
       // Show "Applied" state
       HStack {
        Image(systemName: "checkmark.circle.fill")
        Text("Applied")
         .fontWeight(.semibold)
       }
       .font(.headline)
       .foregroundStyle(.white)
       .frame(maxWidth: .infinity)
       .frame(height: 56)
       .background(Color.green.opacity(0.3))
       .cornerRadius(16)
       .overlay(
        RoundedRectangle(cornerRadius: 16)
         .strokeBorder(Color.green, lineWidth: 2)
       )
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
     
     // Mark as Completed Button (for active services by provider)
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

     // Chat/View Applications Button
     BrandButton(
      isOwnService ? "View Applications" : "Chat with Owner",
      size: .large,
      isDisabled: false,
      hasIcon: true,
      icon: isOwnService ? "person.3.fill" : "bubble.left.fill",
      secondary: true
     ) {
      if isOwnService {
       showingApplications = true
      } else {
       // Navigate to chat (Phase 7)
       print("📝 Chat feature coming soon")
      }
     }
    }
    .padding(.horizontal)
    .padding(.vertical, 20)
    
   }
   .padding()
  }
  .background(Colors.swiftUIColor(.appBackground))
  .toolbarRole(.editor)
  .toolbar {
   ToolbarItem(placement: .topBarTrailing) {
    Button {
     // Favorite
    } label: {
     Image(systemName: "heart")
      .foregroundStyle(.red)
    }
   }
  }
  .navigationBarBackButtonHidden(false)
  .sheet(isPresented: $showingCompletionView) {
   ServiceCompletionView(service: service)
    .environment(servicesStore)
    // .environment(walletStore) // TODO: Fix WalletStore
  }

 }
 
 private var isOwnService: Bool {
  guard let currentUserId = authManager.currentUserId else { return false }
  return service.providerId == currentUserId
 }
 
 private var hasAlreadyApplied: Bool {
  return applicationsStore.hasApplied(to: service.id)
 }
 
 
 private func formatDate(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMM d, yyyy"
  return formatter.string(from: date)
 }
 
 private func formatTime(_ date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateFormat = "h:mm a"
  return formatter.string(from: date)
 }
}

struct DetailRow: View {
 let label: String
 let value: String
 
 var body: some View {
  HStack {
   Text(label)
    .foregroundStyle(.gray)
   Spacer()
   Text(value)
    .foregroundStyle(.white)
    .fontWeight(.semibold)
  }
 }
}

#Preview {
 NavigationStack {
  ServiceDetailView(
   service: JobService(
    title: "Help Cleaning",
    price: 500,
    location: ServiceLocation(name: "Cairo, Egypt", latitude: nil, longitude: nil),
    description: "Need help cleaning my apartment before guests arrive",
    image: ServiceImage(),
    category: .homeCleaning,
    providerId: "provider_1"
   )
  )
 }
 .environment(ApplicationsStore())
 .environment(UserCache())
 .environment(AuthenticationManager(userCache: UserCache()))
 .environment(ServicesStore())
 // .environment(WalletStore()) // TODO: Fix WalletStore
}
