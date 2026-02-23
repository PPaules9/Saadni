//
//  ServiceCard.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ServiceCard: View {
 let title: String
 let hasPhoto: Bool
 let imageName: String
 let price: String
 let locationName: String
 
 var body: some View {
  ZStack() {
   // Background Image
   Group {
    if !hasPhoto {
     ZStack {
      Color(.systemGray6)
      Image(systemName: imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .padding(40)
       .foregroundStyle(.accent)
     }
    } else {
     Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
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
     Spacer()
     Image(systemName: "mappin.and.ellipse")
     Text(locationName)
    }
    .font(.caption2)
    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
    .padding()
    
    Spacer()
    
    HStack(alignment: .bottom) {
     Text(title)
      .font(.title3)
      .fontWeight(.bold)
      .foregroundStyle(.white)
     
     Spacer()
     
     Text(price)
      .font(.title3)
      .fontWeight(.bold)
      .foregroundStyle(.white)
    }
    .padding()
   }

  }
  .clipShape(RoundedRectangle(cornerRadius: 15))
  .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 15))
  .padding()
  
 }
}


#Preview {
 ScrollView {
   ServiceCard(title: "Help Cleaning", hasPhoto: false, imageName: "washer", price: "250 EGP", locationName: "Cairo, Egypt")
  }
}
