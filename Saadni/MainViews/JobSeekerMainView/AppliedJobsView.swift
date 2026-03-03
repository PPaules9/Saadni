//
//  MyJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI


struct AppliedJobsView: View {
 var body: some View {
  NavigationStack{
   VStack(spacing: 24) {
    Spacer()
    
    Image(systemName: "magnifyingglass")
     .font(.system(size: 60))
     .foregroundStyle(.accent.opacity(0.3))
    
    VStack(spacing: 8) {
     Text("Find your next job!")
      .font(.headline)
     Text("You currently have no open applications")
      .font(.subheadline)
      .foregroundStyle(.gray)
    }
    
    BrandButton("Browse jobs", hasIcon: false, icon: "", secondary: false) {
     
    }
    Spacer()
    Spacer()
   }
   .padding(20)
   .navigationTitle("My Jobs")
  }
 }
}


#Preview {
 AppliedJobsView()
}
