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
		 // guard let prevents a startup crash if the GIF asset is missing from the bundle
		 if let gifURL = Bundle.main.url(forResource: "onBoarding", withExtension: "gif") {
		  KFAnimatedImage(source: .provider(LocalFileImageDataProvider(fileURL: gifURL)))
		   .configure { view in view.repeatCount = .finite(count: 3) }
		   .scaledToFit()
		   .frame(width: 300, height: 300)
		 } else {
		  Image(systemName: "bolt.fill")
		   .resizable()
		   .scaledToFit()
		   .frame(width: 100, height: 100)
		   .foregroundStyle(Colors.swiftUIColor(.textMain))
		 }
     
     // App Name
     Text("GoodShift")
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
