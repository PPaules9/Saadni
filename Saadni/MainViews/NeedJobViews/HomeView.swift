//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
 @State private var needHelpWith: String = ""
 @Environment(JobSeekerCoordinator.self) var coordinator

 // Service Categories
 let categories: [(title: String, services: [(name: String, displayName: String)])] = [
  ("Cleaning Services", [
   ("homeCleaning", "Home Cleaning"),
   ("carpetCleaning", "Carpet Cleaning"),
   ("outdoorCleaning", "Outdoor Cleaning")
  ]),
  ("Installation & Mounting", [
   ("doorInstallation", "Door Installation"),
   ("windowInstallation", "Window Installation"),
   ("tvMounting", "TV Mounting"),
   ("kitchenInstallation", "Kitchen Installation"),
   ("flooringInstallation", "Flooring Installation"),
   ("curtainInstallation", "Curtain Installation"),
   ("CameraInstallation", "Camera Installation")
  ]),
  ("Repairs & Maintenance", [
   ("electricWork", "Electric Work"),
   ("plumbing", "Plumbing"),
   ("painting", "Painting"),
   ("AirConditioner", "Air Conditioner"),
   ("gardening", "Gardening")
  ]),
  ("Assembly & Other", [
   ("furnitureAssembly", "Furniture Assembly"),
   ("IkeaAssemply", "IKEA Assembly"),
   ("babySitting", "Baby Sitting"),
   ("petSetting", "Pet Setting"),
   ("helpMoving", "Help Moving"),
   ("beachBabySetting", "Beach Baby Setting")
  ])
 ]

 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()

   VStack(spacing: 0) {
    ScrollView {
     VStack(spacing: 24) {
      BrandTextField(
       hasTitle: false,
       title: "I need help with...",
       placeholder: "cleaning, help with heavy lifting, or something else....",
       text: $needHelpWith
      )
      .padding()
      .onSubmit {
       if !needHelpWith.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        coordinator.presentSheet(.createJob(
         category: needHelpWith,
         initialJobName: needHelpWith
        ))
        needHelpWith = ""
       }
      }

      // Service Categories Sections
      ForEach(categories, id: \.title) { category in
       VStack(alignment: .leading, spacing: 12) {
        Text(category.title)
         .font(.system(size: 16, weight: .semibold, design: .default))
         .foregroundStyle(Colors.swiftUIColor(.textMain))
         .padding(.horizontal)

        ScrollView(.horizontal, showsIndicators: false) {
         HStack(spacing: 12) {
          ForEach(category.services, id: \.name) { service in
           Button(action: {
            coordinator.presentSheet(.createJob(
             category: service.displayName,
             initialJobName: service.displayName
            ))
           }) {
            ZStack {
             Image(service.name)
              .resizable()
              .aspectRatio(contentMode: .fill)
                                    .frame(width: 240)

             LinearGradient(
              gradient: Gradient(colors: [
               Color.black.opacity(0.8),
               Color.black.opacity(0.4),
               Color.black.opacity(0)
              ]),
              startPoint: .bottom,
              endPoint: .center
             )

             VStack {
              Spacer()
              HStack {
               Spacer()
               Text(service.displayName)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundStyle(.white)
                .lineLimit(2)
                .padding(12)
              }
             }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 130)
            .contentShape(Rectangle())
           }
           .buttonStyle(.plain)
          }
         }
         .padding(.horizontal)
        }
       }
      }
     }
    }
   }
   .navigationTitle("I need help with")
   .fontDesign(.monospaced)
  }
 }
}

#Preview {
  HomeView()
  .environment(JobSeekerCoordinator())
}
