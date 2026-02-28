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
     VStack(alignment: .leading, spacing: 24) {
      // User Profile Banner
      VStack(spacing: 12) {
       HStack(spacing: 16) {
        // Profile Image
        Circle()
         .fill(Color.accent.opacity(0.2))
         .frame(width: 70, height: 70)
         .overlay(
          Image(systemName: "person.fill")
           .font(.system(size: 28))
           .foregroundStyle(.accent)
         )

        VStack(alignment: .leading, spacing: 6) {
         Text("Pavly Paules")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundStyle(.primary)

         Text("pavly@example.com")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        }

        Spacer()
       }
       .padding(16)
       .background(Color.gray.opacity(0.08))
       .cornerRadius(28)
      }
      .padding(.horizontal, 20)
      .padding(.top, 16)

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
       .padding(.horizontal, 20)
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
       .padding(.horizontal, 20)
      }
      .padding(.vertical)

      // My Account Section
      VStack(alignment: .leading, spacing: 12) {
       Text("My Account")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .padding(.horizontal, 20)

       VStack(spacing: 0) {
        ProfileMenuRow(
         icon: "person.fill",
         title: "Edit Personal Details",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "globe",
         title: "Change The Language",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "dollarsign.circle.fill",
         title: "Change The Currency",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "door.left.hand.open",
         title: "Log Out",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "trash.fill",
         title: "Delete Account",
         action: {},
         isDestructive: true
        )
       }
       .background(Color.gray.opacity(0.08))
       .cornerRadius(12)
       .padding(.horizontal, 20)
      }

      // Help and Support Section
      VStack(alignment: .leading, spacing: 12) {
       Text("Help and Support")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .padding(.horizontal, 20)

       VStack(spacing: 0) {
        ProfileMenuRow(
         icon: "questionmark.circle.fill",
         title: "Help and Support",
         action: {}
        )

        Divider()
         .padding(.vertical, 0)

        ProfileMenuRow(
         icon: "info.circle.fill",
         title: "About",
         action: {}
        )
       }
       .background(Color.gray.opacity(0.08))
       .cornerRadius(12)
       .padding(.horizontal, 20)
      }

      Spacer()
        .frame(height: 20)
     }
    }
    .scrollIndicators(.hidden)
    .navigationTitle("Profile")
    .toolbar{
     ToolbarItem(placement: .topBarTrailing) {
      BrandButton("Add Service", hasIcon: false, icon: "", secondary: false) {
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

// MARK: - Profile Menu Row
struct ProfileMenuRow: View {
 let icon: String
 let title: String
 let action: () -> Void
 var isDestructive: Bool = false

 var body: some View {
  Button(action: action) {
   HStack(spacing: 12) {
    Image(systemName: icon)
     .font(.system(size: 16, weight: .semibold))
     .foregroundStyle(isDestructive ? .red : .accent)
     .frame(width: 24)

    Text(title)
     .font(.subheadline)
     .fontWeight(.medium)
     .foregroundStyle(isDestructive ? .red : .primary)

    Spacer()

    Image(systemName: "chevron.right")
     .font(.system(size: 14, weight: .semibold))
     .foregroundStyle(.gray)
   }
   .padding(.horizontal, 16)
   .padding(.vertical, 12)
  }
 }
}

#Preview {
 ProfileView()
}
