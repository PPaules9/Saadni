//
//  BrowseJobs.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct BrowseJobs: View {
 @State private var searchText = ""
 
 var body: some View {
  ZStack{
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   ScrollView {
    VStack(spacing: 15) {
     ForEach(Service.mocks) { service in
      //      NavigationLink(value: service) {
      //       ServiceCard(service: service)
      //      }
     }
    }
    .padding()
   }
   .searchable(text: $searchText, prompt: "Browse gigs....")
   .navigationDestination(for: Service.self) { service in
    ServiceDetailView(service: service)
   }
  }
 }
}

#Preview {
 BrowseJobs()
}
