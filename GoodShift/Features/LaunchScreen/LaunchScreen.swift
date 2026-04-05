//
//  LaunchScreen.swift
//  GoodShift
//
//  Created by Pavly Paules on 02/03/2026.
//

import SwiftUI
import Kingfisher

struct LaunchScreen: View {
 @State private var isAnimating = false
 
 var body: some View {
  ZStack {
   
   Color.accent
    .ignoresSafeArea()
   
   VStack(spacing: 40) {
		 Spacer()
		 
		 
		 VStack(spacing: 0) {
		 KFAnimatedImage(source: .provider(
			LocalFileImageDataProvider(fileURL: Bundle.main.url(forResource: "onBoarding", withExtension: "gif")!)
		 ))
		 .configure { view in view.repeatCount = .finite(count: 3) }
		 .scaledToFit()
		 .frame(width: 300, height: 300)
     
     // App Name
     Text("Saedni")
				 .font(.title)
				 .fontDesign(.monospaced)
				 .fontWeight(.regular)
				 .bold()
				 .foregroundStyle(Colors.swiftUIColor(.textMain))
     
    }
    Spacer()
    Spacer()
   }
  }
 }
}

#Preview {
 LaunchScreen()
}
