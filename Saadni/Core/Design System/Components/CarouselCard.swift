//
//  CarouselCard.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

// MARK: - Carousel Card View
struct CarouselCard: View {
 let title: String
 let subtitle: String
 let provider: String
 let price: String
 let onTapAction: () -> Void

 var body: some View {
  RoundedRectangle(cornerRadius: 16)
   .fill(Color.accent.opacity(0.1))
   .overlay(
    VStack(alignment: .leading, spacing: 12) {
     HStack {
      VStack(alignment: .leading, spacing: 8) {
       HStack(spacing: 8) {
        Image(systemName: "star.fill")
         .font(.system(size: 16, weight: .semibold))
         .foregroundStyle(.accent)

        Text(title)
         .font(.headline)
         .foregroundStyle(.primary)
         .fontDesign(.monospaced)
         .kerning(-0.5)

       }

       Text(subtitle)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fontDesign(.monospaced)
        .kerning(-0.3)

      }

      Spacer()

      VStack(alignment: .trailing, spacing: 4) {
       Text(price)
        .font(.headline)
        .foregroundStyle(.accent)
        .fontDesign(.monospaced)
        .kerning(-1)

       Text(provider)
        .font(.caption)
        .foregroundStyle(.secondary)
        .fontDesign(.monospaced)
        .kerning(-1)

      }
     }

     Spacer()

     HStack {
      Text("Learn more")
       .font(.subheadline)
       .foregroundStyle(.accent)
       .fontDesign(.monospaced)
       .kerning(-1)

      Spacer()

      Image(systemName: "arrow.right")
       .font(.system(size: 14, weight: .semibold))
       .foregroundStyle(.accent)

     }
    }
     .padding(16)
   )
   .onTapGesture(perform: onTapAction)
 }
}
