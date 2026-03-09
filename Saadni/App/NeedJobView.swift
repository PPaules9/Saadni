//
//  NeedJobView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedJobView: View {
 var body: some View {
  TabView {
   Tab("Dashboard", systemImage: "house") {
    NavigationStack {
     HomeView()
    }
   }
   
   Tab("Chat", systemImage: "text.bubble.fill") {
    NavigationStack {
     ChatView()
    }
   }
   
   Tab("Add Job", systemImage: "plus") {
    NavigationStack {
     AddService()
    }
   }
   
   
   Tab("My Jobs", systemImage: "bag.fill") {
    NavigationStack {
     AppliedJobsView()
    }
   }
   
   Tab("Profile", systemImage: "person.fill") {
    NavigationStack {
     ProfileView()
    }
   }
   
   
  }
  .tint(.accent)
  .background(Colors.swiftUIColor(.appBackground))
 }
}

#Preview {
 NeedJobView()
}
