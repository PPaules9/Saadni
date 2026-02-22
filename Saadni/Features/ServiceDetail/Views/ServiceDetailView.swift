//
//  ServiceDetailView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ServiceDetailView: View {
 let service: Service
 @Environment(\.dismiss) var dismiss
 
 var body: some View {
  ScrollView {
   VStack(alignment: .leading, spacing: 20) {
    
    // Header Image
    if service.isSystemImage {
     ZStack {
      Color(.systemGray6)
      Image(systemName: service.imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .padding(60)
       .foregroundStyle(.gray.opacity(0.5))
     }
     .frame(height: 250)
     .clipShape(RoundedRectangle(cornerRadius: 20))
    } else {
     Image(service.imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(height: 250)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // Info Row
    HStack {
     Text(service.date)
      .foregroundStyle(.gray)
     Text("|")
      .foregroundStyle(.gray)
     Text(service.location)
      .foregroundStyle(.gray)
     
     Spacer()
     
     Text(service.price)
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
    
    // Map Placeholder
    ZStack(alignment: .bottomTrailing) {
     // Mock Map Background
     Color(.systemGray6).opacity(0.2)
     
     // Mock Streets (Just for visuals)
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
      Text("Jönköping")
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
     Image(systemName: service.providerImageName)
      .resizable()
      .frame(width: 50, height: 50)
      .foregroundStyle(.gray)
      .background(Color(.systemGray6).opacity(0.3))
      .clipShape(Circle())
     
     VStack(alignment: .leading) {
      Text(service.providerName)
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
    
   }
   .padding()
  }
  .background(Color.black)
  .toolbarRole(.editor) // Removes "Back" text effectively
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
 }
}

#Preview {
 NavigationStack {
  ServiceDetailView(service: Service.mocks[0])
 }
}
