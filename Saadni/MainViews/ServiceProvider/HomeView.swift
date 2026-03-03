//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
 @State private var needHelpWith: String = ""
 var body: some View {
  NavigationStack{
   VStack(spacing: 24) {
   BrandTextField(hasTitle: false, title: "I need help with...", placeholder: "cleaning, help with heavy lifting, or something else....", text: $needHelpWith)
     .padding()
    
    VStack(alignment: .center, spacing: 8) {
     Text("Summer of 2026")
      .font(.headline)
     Text("Your published jobs will appear here")
      .font(.subheadline)
      .foregroundStyle(.gray)
    }
    
    .padding()
    Spacer()
    Spacer()
   }
   .navigationTitle("I need help with")
  }
 }
}


#Preview{
 HomeView()
}
