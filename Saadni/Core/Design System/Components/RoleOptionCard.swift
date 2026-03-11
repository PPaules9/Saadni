//
//  RoleOptionCard.swift
//  Saadni
//
//  Created by Pavly Paules on 10/03/2026.
//

import SwiftUI

struct RoleOptionCard: View {
 let icon: String
 let title: String
 let iconColor: Color
 let action: () -> Void
 
 var body: some View {
  Button(action: action) {
   HStack(spacing: 16) {
    Image(systemName: icon)
     .font(.system(size: 40))
     .foregroundStyle(iconColor)
     .frame(width: 60, height: 60)
     .background(iconColor.opacity(0.15))
     .clipShape(Circle())
    
    VStack(alignment: .leading, spacing: 4) {
     Text(title)
      .font(.headline)
      .foregroundStyle(Colors.swiftUIColor(.textMain))
      .multilineTextAlignment(.leading)
     
    }
    
    Spacer()
    
    Image(systemName: "chevron.right")
     .font(.system(size: 16, weight: .semibold))
     .foregroundStyle(.accent)
   }
   .padding(20)
   .background(Colors.swiftUIColor(.appBackground))
   .overlay(
    RoundedRectangle(cornerRadius: 25)
     .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.2), lineWidth: 1)
   )
  }
  .buttonStyle(.plain)
 }
}


#Preview {
 RoleOptionCard(icon: "person.crop.circle", title: "Profile", iconColor: .accent, action: {})
}
