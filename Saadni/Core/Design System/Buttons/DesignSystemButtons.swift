//
//  DesignSystemButtons.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI

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
 
 var horizontalPadding: CGFloat {
  switch self {
  case .small: return 16
  case .medium: return 24
  case .large: return 32
  }
 }
 
 var cornerRadius: CGFloat {
  switch self {
  case .small: return 18
  case .medium: return 24
  case .large: return 28
  }
 }
}

// MARK: - Button Components
struct PrimaryButton: View {
 let title: String
 let size: ButtonSize
 let isDisabled: Bool
 let action: () -> Void
 
 init(_ title: String, size: ButtonSize = .medium, isDisabled: Bool = false, action: @escaping () -> Void) {
  self.title = title
  self.size = size
  self.isDisabled = isDisabled
  self.action = action
 }
 
 var body: some View {
  Button(action: action) {
   Text(title)
    .font(.system(size: size.fontSize, weight: .semibold))
    .foregroundColor(isDisabled ? .gray : .white)
    .frame(height: size.height)
    .padding(.horizontal, size.horizontalPadding)
    .background(isDisabled ? Color(red: 230/255, green: 230/255, blue: 230/255) : Color(red: 138/255, green: 0/255, blue: 230/255))
    .cornerRadius(size.cornerRadius)
  }
  .disabled(isDisabled)
 }
}

struct SecondaryButton: View {
 let title: String
 let size: ButtonSize
 let isDisabled: Bool
 let action: () -> Void
 
 init(_ title: String, size: ButtonSize = .medium, isDisabled: Bool = false, action: @escaping () -> Void) {
  self.title = title
  self.size = size
  self.isDisabled = isDisabled
  self.action = action
 }
 
 var body: some View {
  Button(action: action) {
   Text(title)
    .font(.system(size: size.fontSize, weight: .semibold))
    .foregroundColor(isDisabled ? .gray : .black)
    .frame(height: size.height)
    .padding(.horizontal, size.horizontalPadding)
    .background(isDisabled ? Color(red: 230/255, green: 230/255, blue: 230/255) : Color.white)
    .cornerRadius(size.cornerRadius)
    .overlay(
     RoundedRectangle(cornerRadius: size.cornerRadius)
      .stroke(isDisabled ? Color.gray : Color.black, lineWidth: 1)
    )
  }
  .disabled(isDisabled)
 }
}

struct TertiaryButton: View {
 let title: String
 let size: ButtonSize
 let isDisabled: Bool
 let action: () -> Void

 init(_ title: String, size: ButtonSize = .medium, isDisabled: Bool = false, action: @escaping () -> Void) {
  self.title = title
  self.size = size
  self.isDisabled = isDisabled
  self.action = action
 }

 var body: some View {
  Button(action: action) {
   Text(title)
    .font(.system(size: size.fontSize, weight: .semibold))
    .foregroundColor(isDisabled ? .gray : Color(red: 138/255, green: 0/255, blue: 230/255))
    .frame(height: size.height)
    .padding(.horizontal, size.horizontalPadding)
  }
  .disabled(isDisabled)
 }
}

// MARK: - Previews

#Preview("All Buttons") {
 ScrollView {
  VStack(spacing: 32) {
   VStack(alignment: .leading, spacing: 12) {
    Text("Primary Button").font(.headline)
    PrimaryButton("Enabled", size: .medium) {}
    PrimaryButton("Disabled", size: .medium, isDisabled: true) {}
   }

   VStack(alignment: .leading, spacing: 12) {
    Text("Secondary Button").font(.headline)
    SecondaryButton("Enabled", size: .medium) {}
    SecondaryButton("Disabled", size: .medium, isDisabled: true) {}
   }

   VStack(alignment: .leading, spacing: 12) {
    Text("Tertiary Button").font(.headline)
    TertiaryButton("Enabled", size: .medium) {}
    TertiaryButton("Disabled", size: .medium, isDisabled: true) {}
   }
  }
  .padding()
 }
}

