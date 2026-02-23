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
    let action: () -> Void

 init( _ title: String, size: ButtonSize = .medium, isDisabled: Bool = false, action: @escaping () -> Void ){
  self.title = title
  self.size = size
  self.isDisabled = isDisabled
  self.action = action
 }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: size.fontSize, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: size.height)
                .contentShape(Rectangle())
                .foregroundStyle(Colors.swiftUIColor(.textPrimary))
        }
        .glassEffect(.regular.tint(Colors.swiftUIColor(.buttonBackground)).interactive())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .padding(.horizontal, 20)
    }
}


#Preview {
 BrandButton("Enabled", size: .medium, isDisabled: false, action: {})
}
