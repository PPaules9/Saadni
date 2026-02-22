//
//  ContentView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ContentView: View {
 
 init() {
  // Customize Tab Bar Appearance for Dark Mode
  let appearance = UITabBarAppearance()
  appearance.configureWithOpaqueBackground()
  appearance.backgroundColor = UIColor.black
  
  UITabBar.appearance().standardAppearance = appearance
  UITabBar.appearance().scrollEdgeAppearance = appearance
 }
 
 var body: some View {
  TabView {
   
   Dashboard()
    .tabItem {
     Image(systemName: "bubble.left.fill")
     Text("Dashboard") // Optional
    }
   
   ChatView()
    .tabItem {
     Image(systemName: "bubble.left.fill")
     Text("Chat") // Optional
    }
   
   ProfileView()
    .tabItem {
     Image(systemName: "person.fill")
     Text("Profile") // Optional
    }
   BrowseJobs()
    .tabItem {
     Image(systemName: "magnifyingglass")
     Text("Explore") // Optional label, icons are primary in design
    }
   
   
  }
  .tint(.green) // Green accent color
 }
}

#Preview {
 ContentView()
  .preferredColorScheme(.dark)
}
