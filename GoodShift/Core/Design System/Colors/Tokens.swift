//
//  ColorToken.swift
//  GoodShift
//
//  Created by Pavly Paules on 22/02/2026.
//
import Foundation
import SwiftUI

enum ColorToken {
 // Brand colors
 case textPrimary
 case textSecondary
 case textTertiary
 
 // Alerts
 case error
 case warning
 
 
 // AppColors
 case backgroundLight
 case backgroundDark
 
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
   
  case .backgroundLight:   return "E8F2EE"
  case .backgroundDark:   return "#1C1D1F"
   
  case .primary:        return "#37857D"
  case .primaryDark:     return "#2A8A47"
  case .surfaceWhite:    return "#FEFEFE"
  }
 }
}

extension Color {
    init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        if hexString.count == 6 {
            hexString = "FF" + hexString // Add alpha if not present
        }
        guard let hexValue = UInt64(hexString, radix: 16) else { return nil }
        let red = Double((hexValue & 0x00FF0000) >> 16) / 255.0
        let green = Double((hexValue & 0x0000FF00) >> 8) / 255.0
        let blue = Double(hexValue & 0x000000FF) / 255.0
        let alpha = Double((hexValue & 0xFF000000) >> 24) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct ColorTokensPreview: View {
    let tokens: [ColorToken] = [
        .textPrimary, .textSecondary, .textTertiary,
        .error, .warning,
        .backgroundLight, .backgroundDark,
        .primary, .primaryDark, .surfaceWhite
    ]
    var body: some View {
        List(tokens, id: \.self) { token in
            HStack(spacing: 16) {
                Color(hex: token.hex)?
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))
                Text("\(String(describing: token))")
                Spacer()
                Text(token.hex).font(.caption).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Color Tokens")
    }
}

#Preview {
    NavigationStack {
        ColorTokensPreview()
    }
}
