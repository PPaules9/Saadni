//
//  HomeActivityCard.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

// MARK: - Activity Card View
struct HomeActivityCard: View {
 let title: String
 let serviceName: String
 let status: String
 let extraDetails: String
 let isHighlighted: Bool
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack(alignment: .top) {
    VStack(alignment: .leading, spacing: 4) {
     Text(title)
      .font(.subheadline)
      .fontWeight(.semibold)
      .fontDesign(.monospaced)
      .kerning(-0.5)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     
     Text(serviceName)
      .font(.subheadline)
      .fontDesign(.monospaced)
      .foregroundStyle(Colors.swiftUIColor(.textMain))
      .kerning(-0.5)
     
    }
    
    Spacer()
    VStack(alignment: .trailing, spacing: 4){
     
     Text(status)
      .font(.subheadline)
      .fontWeight(.semibold)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .fontDesign(.monospaced)
      .kerning(-0.5)
      .lineLimit(4)
     
     Text(extraDetails)
      .font(.caption)
      .fontWeight(.semibold)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .fontDesign(.monospaced)
      .kerning(-0.5)
      .lineLimit(4)
    }
   }
   
  }
  .padding(12)
  .background(
   RoundedRectangle(cornerRadius: 20)
    .strokeBorder(Colors.swiftUIColor(.textMain), lineWidth: 1)
  )
 }
}



#Preview {
 HomeActivityCard(
  title: "UpComing",
  serviceName: "Fix my batheroom",
  status: "Starting On",
  extraDetails: "12/09/2020 9:00Am",
  isHighlighted: true
 )
}
