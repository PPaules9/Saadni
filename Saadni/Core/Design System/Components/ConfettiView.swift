//
//  ConfettiView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct ConfettiView: View {
 @State private var isAnimating = false
 let onAnimationComplete: () -> Void
 
 var body: some View {
  ZStack {
   ForEach(0..<50, id: \.self) { index in
    ConfettiPiece(
     delay: Double(index) * 0.02,
     isAnimating: $isAnimating
    )
   }
  }
  .ignoresSafeArea()
  .onAppear {
   isAnimating = true
   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    onAnimationComplete()
   }
  }
 }
}

struct ConfettiPiece: View {
 let delay: Double
 @Binding var isAnimating: Bool
 @State private var randomX = CGFloat.random(in: -200...200)
 @State private var randomY = CGFloat.random(in: 0...600)
 @State private var randomRotation = Double.random(in: 0...360)
 @State private var opacity = 1.0
 
 let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .yellow]
 let randomColor = [Color.blue, .green, .orange, .purple, .pink, .red, .yellow].randomElement() ?? .blue
 
 var body: some View {
  RoundedRectangle(cornerRadius: 2)
   .fill(randomColor)
   .frame(width: CGFloat.random(in: 4...8), height: CGFloat.random(in: 4...8))
   .offset(x: isAnimating ? randomX : 0, y: isAnimating ? randomY : 0)
   .opacity(isAnimating ? 0 : opacity)
   .rotationEffect(.degrees(isAnimating ? randomRotation + 360 : randomRotation))
   .animation(
    .easeIn(duration: 2.0).delay(delay),
    value: isAnimating
   )
 }
}

#Preview {
 ConfettiView(onAnimationComplete: {})
}
