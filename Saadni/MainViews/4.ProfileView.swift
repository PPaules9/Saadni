//
//  ProfileView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
 @State private var addService: Bool = false
 
 var body: some View {
  ZStack{
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    ScrollView {
     // Your Services (Empty State)
     VStack(alignment: .leading, spacing: 10) {
      HStack {
       Text("My Services")
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
       Spacer()
       
       Image(systemName: "chevron.right")
        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      }
      .padding(.horizontal, 40)
      // Empty State Content
      VStack(alignment: .leading, spacing: 5) {
       Text("You haven't created any service yet.")
       HStack(spacing: 0) {
        Text("Create one by clicking on the ")
        Text("Add Service")
         .foregroundStyle(.accent)
       }
        Text("button above.")
      }
      .font(.body)
      .foregroundStyle(.gray)
      .padding(.top, 5)
      .padding(.horizontal, 40)
     }
     .padding(.vertical)
     
    }
    .navigationTitle("Profile")
    .toolbar{
     ToolbarItem(placement: .topBarTrailing) {
      BrandButton("Add Service", hasIcon: false, icon: "") {
       addService = true
      }
     }
    }
    .navigationDestination(isPresented: $addService) {
     AddService()
    }
   }
  }
 }
}

#Preview {
 ProfileView()
}
