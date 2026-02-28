//
//  ContentView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
// Imports are provided by module (same target)

struct MainView: View {
 @Environment(AuthenticationManager.self) var authManager

 var body: some View {
  Group {
   switch authManager.authState {
   case .unauthenticated, .authenticating:
    AuthenticationView()
   case .authenticated:
    authenticatedContent
   }
  }
 }

 private var authenticatedContent: some View {
  TabView {
   Tab("Dashboard", systemImage: "house") {
    NavigationStack{
     DashboardView()
    }
   }

   Tab("Chat", systemImage: "text.bubble.fill") {
    NavigationStack{
     ChatView()
    }
   }

   Tab("My Jobs", systemImage: "bag.fill") {
    NavigationStack{
     MyJobs()
    }
   }


   Tab("Profile", systemImage: "person.fill") {
    NavigationStack{
     ProfileView()
    }
   }

   Tab(role: .search){
    NavigationStack{
     BrowseJobs()
    }
   }


  }
  .tint(.accent)
  .background(Colors.swiftUIColor(.appBackground))
 }
}

#Preview {
 MainView()
}
