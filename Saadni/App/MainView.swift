//
//  ContentView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct MainView: View {
 
 var body: some View {
  TabView {
   Tab("Dashboard", systemImage: "house") {
    NavigationStack{
     Dashboard()
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
