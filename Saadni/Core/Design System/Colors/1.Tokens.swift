//
//  Tokens.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//
import Foundation

enum ColorToken {
 // Brand colors
 case primary
 case secondary
 case tertiary
 
 // Alerts
 case success
 case error
 case warning
 
 
 // AdditionalColors
 case white
 case lineDark
 case lineLight
 case black
 
 
 /// Returns the hex string for this token.
 var hex: String {
  switch self {
  case .primary:      return "#37857D"
  case .secondary:    return "#F2FFF6"
  case .tertiary:     return "#141720"
   
  case .success:      return "#00C566"
  case .error:        return "#E53935"
  case .warning:      return "#FACC15"
   
  case .white:        return "#FEFEFE"
  case .lineDark:     return "#282837"
  case .lineLight:    return "#D9D9D9"
  case .black:        return "#111111"
  }
 }
}
