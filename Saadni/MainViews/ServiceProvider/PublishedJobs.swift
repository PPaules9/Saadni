//
//  PublishedJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct PublishedJobs: View {
 var body: some View {
  NavigationStack{
   VStack(spacing: 24) {
    Spacer()
    
    Image(systemName: "calendar")
     .font(.system(size: 60))
     .foregroundStyle(.accent.opacity(0.3))
    
    VStack(alignment: .center, spacing: 8) {
     Text("I didn't publish any job")
      .font(.headline)
     Text("Your published jobs will appear here")
      .font(.subheadline)
      .foregroundStyle(.gray)
    }
    
    .padding()
    Spacer()
    Spacer()
   }
   .navigationTitle("My Jobs")
  }
 }
}


#Preview{
 PublishedJobs()
}
