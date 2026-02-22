//
//  ProfileView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
          
             
             // Your Services (Empty State)
             VStack(alignment: .leading, spacing: 10) {
              HStack {
               Text("Your services")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
               
               Image(systemName: "plus.circle.fill")
                .foregroundStyle(Color.green)
                .font(.title2)
              }
              
              // Empty State Content
              VStack(alignment: .leading, spacing: 5) {
               Text("You haven't created any service yet.")
               HStack(spacing: 0) {
                Text("Create one clicking on the ")
                Image(systemName: "plus.circle.fill")
                 .foregroundStyle(.gray)
                Text(" button.")
               }
              }
              .font(.body)
              .foregroundStyle(.gray)
              .padding(.top, 5)
             }
             .padding(.vertical)

            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
