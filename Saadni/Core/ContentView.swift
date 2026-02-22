//
//  ContentView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import Foundation

struct ContentView: View {
 
 var body: some View {
  TabView {
   Tab("Dashboard", systemImage: "house") {
    NavigationStack{
     Dashboard()
    }
   }
   
   Tab("Chat", systemImage: "bubble.left.fill") {
    NavigationStack{
     ChatView()
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
  .tint(.green) // Green accent color
 }
}

#Preview {
 ContentView()
}
