//
//  ServiceCard.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import Kingfisher

struct ServiceCard: View {
 let service: JobService
 @Environment(AuthenticationManager.self) var authManager
 @Environment(AppCoordinator.self) var appCoordinator

 private var applicationCount: Int {
  return service.applicationCount
 }

 private var isOwnService: Bool {
  guard let currentUserId = authManager.currentUserId else { return false }
  return service.providerId == currentUserId
 }

 private var userIsJobSeeker: Bool {
  authManager.currentUser?.isJobSeeker ?? false
 }

 private var cardContent: some View {
  ZStack() {
    // Background Image
    Group {
     if let uiImage = service.image.localImage {
      Image(uiImage: uiImage)
       .resizable()
       .aspectRatio(contentMode: .fill)
     } else if let remoteURL = service.image.remoteURL, let url = URL(string: remoteURL) {
      KFImage(url)
       .placeholder {
        ZStack {
         Color(.systemGray6)
         ProgressView()
        }
       }
       .resizable()
       .aspectRatio(contentMode: .fill)
       .background(
        ZStack {
         Color(.systemGray6)
         Image(systemName: "briefcase.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(40)
          .foregroundStyle(.accent)
        }
       )
     } else {
      ZStack {
       Color(.systemGray6)
       Image(systemName: "briefcase.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(40)
        .foregroundStyle(.accent)
      }
     }
    }
    .frame(height: 190)
    .frame(maxWidth: .infinity)

    // Overlay Gradient
    LinearGradient(
     colors: [.black.opacity(0.8), .black.opacity(0)],
     startPoint: .bottom,
     endPoint: .center
    )

    VStack {
     HStack(spacing: 5) {
      // Add application badge for own services
      if isOwnService && applicationCount > 0 {
       ApplicationBadge(count: applicationCount, size: .small)
      }

      Spacer()
      Image(systemName: "mappin.and.ellipse")
      Text(service.location.name)
       .fontDesign(.monospaced)
     }
     .font(.caption2)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     .padding()

     Spacer()

     HStack(alignment: .bottom) {
      Text(service.title)
       .font(.title3)
       .fontWeight(.bold)
       .foregroundStyle(.white)
       .fontDesign(.monospaced)

      Spacer()

      Text(service.formattedPrice)
       .font(.title3)
       .fontWeight(.bold)
       .foregroundStyle(.white)
       .fontDesign(.monospaced)
     }
     .padding()
    }

   }
   .clipShape(RoundedRectangle(cornerRadius: 15))
 }

 var body: some View {
  if #available(iOS 26, *) {
   if userIsJobSeeker {
    NavigationLink(value: JobSeekerDestination.serviceDetail(service)) {
     cardContent
      .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 15))
    }
   } else {
    NavigationLink(value: ServiceProviderDestination.serviceDetail(service)) {
     cardContent
      .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 15))
    }
   }
  } else {
   Button(action: navigateToDetail) {
    cardContent
   }
  }
 }

 private func navigateToDetail() {
  // Use appropriate coordinator based on context
  if let coordinator = appCoordinator.jobSeekerCoordinator {
   coordinator.navigate(to: .serviceDetail(service))
  } else if let coordinator = appCoordinator.serviceProviderCoordinator {
   coordinator.navigate(to: .serviceDetail(service))
  }
 }
}


#Preview {
 ScrollView {
  ServiceCard(
   service: JobService(
    title: "Help Cleaning",
    price: 250,
    location: ServiceLocation(name: "Cairo, Egypt", latitude: nil, longitude: nil),
    description: "Need help cleaning my apartment",
    image: ServiceImage(),
		category: .foodAndBeverage,
    providerId: "provider_1"
   )
  )
 }
 .environment(UserCache())
 .environment(AuthenticationManager(userCache: UserCache()))
 .environment(AppCoordinator(
  authManager: AuthenticationManager(userCache: UserCache()),
  userCache: UserCache()
 ))
}
