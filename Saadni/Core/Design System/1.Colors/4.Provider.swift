//
//  Provider.swift
//  Saadni
//
//  Created by Pavly Paules on 23/02/2026.
//


import SwiftUI
import UIKit

// MARK: - UIColor Extension for Hex Support
extension UIColor {
 /// Initializes a UIColor from a hex string (e.g., "#37857D" or "37857D")
 convenience init(hex: String) {
  let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
  var int: UInt64 = 0
  Scanner(string: hexString).scanHexInt64(&int)
  let a, r, g, b: UInt64
  switch hexString.count {
  case 3: // RGB (12-bit)
   (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
  case 6: // RGB (24-bit)
   (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
  case 8: // ARGB (32-bit)
   (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
  default:
   (a, r, g, b) = (255, 0, 0, 0)
  }
  
  self.init(
   red: CGFloat(r) / 255,
   green: CGFloat(g) / 255,
   blue: CGFloat(b) / 255,
   alpha: CGFloat(a) / 255
  )
 }
}




// MARK: - SwiftUI
/// Returns a SwiftUI Color for the specified semantic color.
/// Automatically adapts to light/dark mode.


/// Provides SwiftUI Color instances for semantic colors.
public protocol ColorProvidingSwiftUI {
 func color(_ semantic: SemanticColor) -> Color
}



/// Default SwiftUI color provider with automatic dark mode support.
public final class DefaultColorProviderSwiftUI: ColorProvidingSwiftUI {
 
 private let theme: ColorTheme
 private let palette: ColorPalette
 
 public init(theme: ColorTheme = .default) {
  self.theme = theme
  self.palette = ColorPalette(theme: theme)
 }
 
 /// Returns a dynamic SwiftUI Color that adapts to light/dark mode.
 public func color(_ semantic: SemanticColor) -> Color {
  // Create a dynamic UIColor that adapts to traitCollection.userInterfaceStyle
  let uiColor: UIColor = UIColor(dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
   let isDark = (traitCollection.userInterfaceStyle == .dark)
   let token = self.palette.token(for: semantic, isDarkMode: isDark)
   return UIColor(hex: token.hex)
  })
  return Color(uiColor)
  
 }
}



public enum Colors {
 private static let swiftUIProvider = DefaultColorProviderSwiftUI()
 
 public static func swiftUIColor(_ semantic: SemanticColor) -> Color {
  swiftUIProvider.color(semantic)
 }
}









//MARK: - Example Use into app
/*
 import SwiftUI
 
 struct ContentView: View {
   var body: some View {
     VStack {
        Text("Hello")
        .foregroundColor(Colors.swiftUIColor(.textPrimary))
 
        Button("Tap Me") {// action}
         .foregroundColor(Colors.swiftUIColor(.textOnAccent))
         .background(Colors.swiftUIColor(.backgroundAccent))
     }
      .background(Colors.swiftUIColor(.backgroundSurface))
   }
 }
 
 */
