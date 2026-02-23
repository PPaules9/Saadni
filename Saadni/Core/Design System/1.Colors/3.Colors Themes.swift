//
//  ColorTheme.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import Foundation

public enum ColorTheme {
 case `default`
 // Future: .highContrast, .branded, etc.
}


struct ColorPalette {
 let theme: ColorTheme
 
 /// Returns the appropriate token for a semantic color.
 /// - Parameters:
 ///   - semantic: The semantic role (e.g., textPrimary)
 ///   - isDarkMode: Whether dark mode is active
 
 func token(for semantic: SemanticColor, isDarkMode: Bool) -> ColorToken {
  switch (theme, semantic, isDarkMode) {
   
   // Text colors
  case (.default, .textPrimary, false):
   return .surfaceWhite
  case(.default, .textPrimary, true):
   return .textPrimary
   
  case (.default, .textSecondary, false):
   return .textSecondary
  case (.default, .textSecondary, true):
   return .textSecondary
   
  case (.default, .backgroundColor , false):
   return .background
  case (.default, .backgroundColor , true):
   return .background
   
   
  case (.default, .buttonBackground, false):
   return .primary
  case (.default, .buttonBackground, true):
   return .primaryDark
   
   
  case (.default, .borderPrimary, false):
   return .textPrimary
  case (.default, .borderPrimary, true):
   return .surfaceWhite
   
  case (.default, .borderError, false):
   return .error
   case (.default, .borderError, true):
   return .error
  
  case (.default, .borderWarning, false):
   return .warning
  case (.default, .borderWarning, true):
   return .warning
  }
 }
}
