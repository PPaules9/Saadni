//
//  ProfileMenuRow.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ProfileMenuRow: View {
 let icon: String
 let title: String
 let action: () -> Void
 var isDestructive: Bool = false

 var body: some View {
  Button(action: action) {
   HStack(spacing: 12) {
    Image(systemName: icon)
     .font(.system(size: 16, weight: .semibold))
     .foregroundStyle(isDestructive ? .red : .accent)
     .frame(width: 24)

    Text(title)
     .font(.subheadline)
     .fontWeight(.medium)
     .foregroundStyle(isDestructive ? .red : .primary)
     .fontDesign(.monospaced)
    Spacer()

    Image(systemName: "chevron.right")
     .font(.system(size: 14, weight: .semibold))
     .foregroundStyle(.gray)
   }
   .padding(.horizontal, 16)
   .padding(.vertical, 12)
  }
 }
}

#Preview {
 ProfileMenuRow(icon: "trash", title: "Anythingfornow", action: {}, isDestructive: false)
}
