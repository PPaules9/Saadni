//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct BrowseJobs: View {
 @State private var searchText = ""
 
 var body: some View {
  ScrollView {
   VStack(alignment: .leading, spacing: 20) {
    
    // Header
    VStack(alignment: .leading) {
     Text("Welcome back,")
      .font(.subheadline)
      .foregroundStyle(.gray)
     Text("Pavly")
      .font(.largeTitle)
      .fontWeight(.bold)
      .foregroundStyle(.white)
     
    }
    .padding(.top)
    
 
    // Suggested Services
    VStack(spacing: 15) {
     ForEach(Service.mocks) { service in
      NavigationLink(value: service) {
       ServiceCard(service: service)
      }
     }
    }
   }
   .padding()
  }
  .searchable(text: $searchText, prompt: "Browse Jobs,...")
  .navigationDestination(for: Service.self) { service in
   ServiceDetailView(service: service)
  }
  .toolbar {
   ToolbarItem(placement: .topBarTrailing) {
    Circle() // Placeholder for Profile Image
     .fill(Color.gray.opacity(0.3))
     .frame(width: 40, height: 40)
     .overlay(
      Image(systemName: "person.fill")
       .foregroundStyle(.gray)
     )
   }
  }
 }
 
}

#Preview {
 BrowseJobs()
}
