//
//  C.swift
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
 ///
 func token(for semantic: SemanticColor, isDarkMode: Bool) -> ColorToken {
  switch (theme, semantic, isDarkMode) {
   
   // Text colors
  case (.default, .textPrimary, false):
   return .primary
  case(.default, .textPrimary, true):
   return .lineLight
   
  case (.default, .textSecondary, false):
   return .secondary
  case (.default, .textTertiary, false):
   return .tertiary
   
  case (.default, .buttonTextWhite, false):
   return .white
  case (.default, .buttonTextBlack, false):
   return .black
  case (.default, .buttonColors, false):
   return .primary
   
  case (.default, .backgroundLight, false):
   return .white
   
  case (.default, .borderPrimary, false):
   return .black
  case (.default, .borderError, false):
   return .error
  case (.default, .borderSuccess, false):
   return .primary
   
  case (.default, .textSuccess, false):
   return .success
  case (.default, .textError, false):
   return .error
  case (.default, .textWarning, false):
   return .warning
   
  case(.default, .textFieldText, false):
   return .lineLight
  case(.default, .placeholderColor, false):
   return .lineLight
  case(.default, .textFieldHeadline, false):
   return .lineLight
  case(.default, .textFieldBorderInActive, false):
   return .lineLight
  case(.default, .textFieldBorderError, false):
   return .lineLight
  case(.default, .textFieldBorderSelected, false):
   return .lineLight
   
  case(.default, .lineLight, false):
   return .lineLight
  case(.default, .lineDark, false):
   return .lineDark
   
  default:
   return .primary
  }
 }
}
