//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
 @State private var needHelpWith: String = ""
 @State private var selectedCategory: String?
 @State private var showCreateJobSheet: Bool = false

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
        selectedCategory = needHelpWith
        showCreateJobSheet = true
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
  .sheet(isPresented: $showCreateJobSheet) {
   if let category = selectedCategory {
    CreateJobSheet(selectedCategory: category, initialJobName: category)
   }
  }
 }
}

#Preview {
  HomeView()
}
