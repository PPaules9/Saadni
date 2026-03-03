//
//  LaunchScreen.swift
//  Saadni
//
//  Created by Pavly Paules on 02/03/2026.
//

import SwiftUI

struct LaunchScreen: View {
 @State private var isAnimating = false
 
 var body: some View {
  ZStack {
   
   Color.accent
    .ignoresSafeArea()
   
   Color.black.opacity(0.83) // adjust 0.2–0.6 as needed
    .ignoresSafeArea()
   
   
   
   VStack(spacing: 40) {
    Spacer()
    
    // Logo/App Icon
    VStack(spacing: 20) {
     
     Image("icon")
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
      .padding()
     
     
     // App Name
     Text("Sa3dni - ساعدني")
      .font(.system(size: 36, weight: .bold))
      .foregroundColor(.white)
     
     Text("Connecting Services & Opportunities")
      .font(.system(size: 14, weight: .medium))
      .foregroundColor(Colors.swiftUIColor(.textSecondary))
      .multilineTextAlignment(.center)
      .padding(.horizontal, 40)
    }
    
    Spacer()
    
    // Loading Indicator
    VStack(spacing: 20) {
     ProgressView()
      .scaleEffect(1.2)
      .tint(.white)
     
     Text("Loading...")
      .font(.system(size: 14, weight: .medium))
      .foregroundColor(.white)
    }
    
    Spacer()
     .frame(height: 60)
   }
  }
 }
}

#Preview {
 LaunchScreen()
}
