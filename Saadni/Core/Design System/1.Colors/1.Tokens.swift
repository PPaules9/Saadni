//
//  ColorToken.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//
import Foundation

enum ColorToken {
 // Brand colors
 case textPrimary
 case textSecondary
 case textTertiary
 
 // Alerts
 case error
 case warning
 
 
 // AppColors
 case background
 case primary
 case primaryDark
 case surfaceWhite
 
 
 
 /// Returns the hex string for this token.
 var hex: String {
  switch self {
  case .textPrimary:      return "#111111"
  case .textSecondary:    return "#888888"
  case .textTertiary:     return "#D9D9D9"
   
  case .error:        return "#E53935"
  case .warning:      return "#FACC15"
   
  case .background:   return "E8F2EE"
  case .primary:        return "#3DB562"
  case .primaryDark:     return "#2A8A47"
  case .surfaceWhite:    return "#FEFEFE"
  }
 }
}
