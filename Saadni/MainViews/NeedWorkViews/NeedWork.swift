//
//  NeedWork.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct NeedWork: View {
 var body: some View {
  TabView {
   Tab("Home", systemImage: "house") {
    NavigationStack {
     DashboardView()
    }
   }
   
   Tab("Chat", systemImage: "text.bubble.fill") {
    NavigationStack {
     ChatView()
    }
   }
   
   Tab("My Jobs", systemImage: "bag.fill") {
    NavigationStack {
     AppliedJobs()
    }
   }
   
   Tab("Profile", systemImage: "person.fill") {
    NavigationStack {
     ProfileView()
    }
   }
   
   Tab(role: .search) {
    NavigationStack {
     BrowseJobs()
    }
   }
  }
  .tint(.accent)
  .background(Colors.swiftUIColor(.appBackground))
 }
}

#Preview {
 NeedWork()
}
