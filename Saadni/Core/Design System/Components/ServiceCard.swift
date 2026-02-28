//
//  ServiceCard.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

// ServiceCardData - wrapper for both service types
enum ServiceCardData {
 case flexibleJob(FlexibleJobService)
 case shift(ShiftService)

 var title: String {
  switch self {
  case .flexibleJob(let service): return service.title
  case .shift(let service): return service.title
  }
 }

 var price: String {
  switch self {
  case .flexibleJob(let service): return "\(service.price) EGP"
  case .shift(let service): return "\(service.price) EGP"
  }
 }

 var location: String {
  switch self {
  case .flexibleJob(let service): return service.location.name
  case .shift(let service): return service.location.name
  }
 }

 var image: ServiceImage {
  switch self {
  case .flexibleJob(let service): return service.image
  case .shift(let service): return service.image
  }
 }

 var detailData: ServiceDetailData {
  switch self {
  case .flexibleJob(let service): return .flexibleJob(service)
  case .shift(let service): return .shift(service)
  }
 }
}

struct ServiceCard: View {
 let serviceData: ServiceCardData
 @Environment(AuthenticationManager.self) var authManager

 private var applicationCount: Int {
  switch serviceData {
  case .flexibleJob(let service):
   return service.applicationCount
  case .shift(let service):
   return service.applicationCount
  }
 }

 private var isOwnService: Bool {
  guard let currentUserId = authManager.currentUserId else { return false }

  switch serviceData {
  case .flexibleJob(let service):
   return service.providerId == currentUserId
  case .shift(let service):
   return service.providerId == currentUserId
  }
 }

 var body: some View {
  NavigationLink(destination: ServiceDetailView(serviceData: serviceData.detailData)) {
   ZStack() {
    // Background Image
    Group {
     if let uiImage = serviceData.image.localImage {
      Image(uiImage: uiImage)
       .resizable()
       .aspectRatio(contentMode: .fill)
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
    .frame(height: 210)
    .frame(maxWidth: .infinity)

    // Overlay Gradient
    LinearGradient(
     colors: [.black.opacity(0.8), .black.opacity(0)],
     startPoint: .bottom,
     endPoint: .center
    )

    VStack{
     HStack(spacing: 5) {
      // Add application badge for own services
      if isOwnService && applicationCount > 0 {
       ApplicationBadge(count: applicationCount, size: .small)
      }

      Spacer()
      Image(systemName: "mappin.and.ellipse")
      Text(serviceData.location)
     }
     .font(.caption2)
     .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     .padding()

     Spacer()

     HStack(alignment: .bottom) {
      Text(serviceData.title)
       .font(.title3)
       .fontWeight(.bold)
       .foregroundStyle(.white)

      Spacer()

      Text(serviceData.price)
       .font(.title3)
       .fontWeight(.bold)
       .foregroundStyle(.white)
     }
     .padding()
    }

   }
   .clipShape(RoundedRectangle(cornerRadius: 15))
   .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 15))
  }
 }
}


#Preview {
 NavigationStack {
  ScrollView {
   ServiceCard(
    serviceData: .flexibleJob(
     FlexibleJobService(
      id: "1",
      title: "Help Cleaning",
      price: 250,
      location: ServiceLocation(name: "Cairo, Egypt", coordinate: nil),
      description: "Need help cleaning my apartment",
      image: ServiceImage(localId: "1", remoteURL: nil, localImage: nil),
      createdAt: Date(),
      providerId: "provider_1",
      providerName: "Ahmed",
      providerImageURL: nil,
      status: .published,
      isFeatured: false,
      category: .helpCleaning
     )
    )
   )
  }
 }
}
