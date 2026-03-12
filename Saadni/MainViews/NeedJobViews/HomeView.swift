//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
 @State private var needHelpWith: String = ""
 @Environment(JobSeekerCoordinator.self) var coordinator

 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()

   VStack(spacing: 0) {
    ScrollView {
     VStack(spacing: 24) {
      BrandTextField(
       hasTitle: false,
       title: "I need help with...",
       placeholder: "cleaning, help with heavy lifting, or something else....",
       text: $needHelpWith
      )
      .padding()
      .onSubmit {
       if !needHelpWith.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        // Use coordinator to present sheet
        coordinator.presentSheet(.createJob(
         category: needHelpWith,
         initialJobName: needHelpWith
        ))
        needHelpWith = ""
       }
      }
     }
     Spacer()
      .frame(height: 60)
    }
   }
   .navigationTitle("I need help with")
   .fontDesign(.monospaced)
  }
 }
}

#Preview {
  HomeView()
}
