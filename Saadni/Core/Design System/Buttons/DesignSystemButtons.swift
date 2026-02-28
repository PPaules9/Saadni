//
//  DesignSystemButtons.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI


// MARK: - Button Size
enum ButtonSize {
 case small
 case medium
 case large
 
 var height: CGFloat {
  switch self {
  case .small: return 36
  case .medium: return 48
  case .large: return 56
  }
 }
 
 var fontSize: CGFloat {
  switch self {
  case .small: return 14
  case .medium: return 16
  case .large: return 18
  }
 }
 
}

// MARK: - Glass Button Component
struct BrandButton: View {
 let title: String
 let size: ButtonSize
 let isDisabled: Bool
 let hasIcon: Bool
 let icon: String
 let secondary: Bool
 let action: () -> Void
 
 init( _ title: String, size: ButtonSize = .medium, isDisabled: Bool = false, hasIcon: Bool, icon: String, secondary: Bool, action: @escaping () -> Void ){
  self.title = title
  self.size = size
  self.isDisabled = isDisabled
  self.hasIcon = hasIcon
  self.icon = icon
  self.secondary = secondary
  self.action = action
 }
 
 var body: some View {
 
   if secondary {
    Button(action: action) {
     HStack(spacing: 8){
      Spacer()
      if hasIcon {
       Image(systemName: icon)
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.accent)
      }
      Text(title)
       .font(.system(size: size.fontSize, weight: .semibold))
       .frame(height: size.height)
       .contentShape(Rectangle())
       .foregroundStyle(.accent)
      Spacer()
     }
     .frame(maxWidth: .infinity)
     .disabled(isDisabled)
     .opacity(isDisabled ? 0.5 : 1.0)
    }
    .overlay(
     RoundedRectangle(cornerRadius: 35)
      .strokeBorder(.accent, lineWidth: 1)
//      .strokeBorder(Color.clear)
    )
    .glassEffect(.regular)

   } else {
    Button(action: action) {
    HStack(spacing: 8){
     Spacer()
     if hasIcon {
      Image(systemName: icon)
       .font(.system(size: 12, weight: .semibold))
       .foregroundStyle(Colors.swiftUIColor(.textPrimary))
      
     }
     Text(title)
      .font(.system(size: size.fontSize, weight: .semibold))
      .frame(height: size.height)
      .contentShape(Rectangle())
      .foregroundStyle(Colors.swiftUIColor(.textPrimary))
     Spacer()
    }
    .frame(maxWidth: .infinity)
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.5 : 1.0)

   }
    .glassEffect(.regular.tint(.accent))
  }
 }
}


#Preview {
 BrandButton("Publish", hasIcon: false, icon: "", secondary: false) {
  // Publish action
 }
 BrandButton("Publish", hasIcon: true, icon: "trash", secondary: true) {
  // Publish action
 }
 
}
