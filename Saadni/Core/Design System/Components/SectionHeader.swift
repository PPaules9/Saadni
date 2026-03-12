//
//  SectionHeader.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct SectionHeader: View {
 let title: String
 var showViewAll: Bool = false
 var onViewAllTap: (() -> Void)? = nil
 
 var body: some View {
  HStack {
   Text(title)
    .font(.title3)
    .fontWeight(.bold)
    .fontDesign(.monospaced)
    .kerning(-0.5)

   if showViewAll {
    Spacer()
    Button(action: { onViewAllTap?() }) {
     Text("View All")
      .font(.caption)
      .fontWeight(.semibold)
      .foregroundStyle(.blue)
      .fontDesign(.monospaced)
      .kerning(-0.5)

    }
   }
  }
  .padding(.horizontal)
 }
}

#Preview {
 SectionHeader(title: "Winter Refresh", showViewAll: true)
}
