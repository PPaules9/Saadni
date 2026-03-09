//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
 @State private var needHelpWith: String = ""
 @State private var selectedCategory: String?
 @State private var showCreateJobSheet: Bool = false

 var sections: [ServiceSection] {
  let categoryToIcon: [ServiceCategoryType: String] = [
   .airConditioner: "AirConditioner",
   .beachBabySitting: "beachBabySetting",
   .gardening: "gardening",
   .outdoorCleaning: "outdoorCleaning",
   .homeCleaning: "homeCleaning",
   .helpMoving: "helpMoving",
   .furnitureAssembly: "furnitureAssembly",
   .tvMounting: "tvMounting",
   .electricalWork: "electricWork",
   .plumbing: "plumbing",
   .carpetCleaning: "carpetCleaning",
   .kitchenInstallation: "kitchenInstallation",
   .painting: "painting",
   .cameraInstallation: "CameraInstallation",
   .doorInstallation: "doorInstallation",
   .flooringInstallation: "flooringInstallation",
   .windowInstallation: "windowInstallation",
   .curtainInstallation: "curtainInstallation",
   .petCare: "petSetting",
   .babySitting: "babySitting",
  ]

  return [
   // Summer Needs - Special Event
   ServiceSection(
    title: "☀️ Summer Needs",
    categories: [
     ServiceCategory(title: ServiceCategoryType.airConditioner.rawValue, imageName: categoryToIcon[.airConditioner] ?? "", backgroundColor: .cyan),
     ServiceCategory(title: ServiceCategoryType.beachBabySitting.rawValue, imageName: categoryToIcon[.beachBabySitting] ?? "", backgroundColor: .cyan),
     ServiceCategory(title: ServiceCategoryType.gardening.rawValue, imageName: categoryToIcon[.gardening] ?? "", backgroundColor: .green),
     ServiceCategory(title: ServiceCategoryType.outdoorCleaning.rawValue, imageName: categoryToIcon[.outdoorCleaning] ?? "", backgroundColor: .blue),
    ],
    isSpecialEvent: true
   ),

   // Essential Services
   ServiceSection(
    title: "Essential Services",
    categories: [
     ServiceCategory(title: ServiceCategoryType.homeCleaning.rawValue, imageName: categoryToIcon[.homeCleaning] ?? "", backgroundColor: .orange),
     ServiceCategory(title: ServiceCategoryType.helpMoving.rawValue, imageName: categoryToIcon[.helpMoving] ?? "", backgroundColor: .purple),
     ServiceCategory(title: ServiceCategoryType.furnitureAssembly.rawValue, imageName: categoryToIcon[.furnitureAssembly] ?? "", backgroundColor: .green),
     ServiceCategory(title: ServiceCategoryType.tvMounting.rawValue, imageName: categoryToIcon[.tvMounting] ?? "", backgroundColor: .blue),
    ]
   ),

   // Home Repairs & Installation
   ServiceSection(
    title: "Home Repairs & Installation",
    categories: [
     ServiceCategory(title: ServiceCategoryType.electricalWork.rawValue, imageName: categoryToIcon[.electricalWork] ?? "", backgroundColor: .yellow),
     ServiceCategory(title: ServiceCategoryType.plumbing.rawValue, imageName: categoryToIcon[.plumbing] ?? "", backgroundColor: .blue),
     ServiceCategory(title: ServiceCategoryType.carpetCleaning.rawValue, imageName: categoryToIcon[.carpetCleaning] ?? "", backgroundColor: .orange),
    ]
   ),

   // Interior Design & Upgrades
   ServiceSection(
    title: "Interior Design & Upgrades",
    categories: [
     ServiceCategory(title: ServiceCategoryType.kitchenInstallation.rawValue, imageName: categoryToIcon[.kitchenInstallation] ?? "", backgroundColor: .red),
     ServiceCategory(title: ServiceCategoryType.painting.rawValue, imageName: categoryToIcon[.painting] ?? "", backgroundColor: .gray),
     ServiceCategory(title: ServiceCategoryType.cameraInstallation.rawValue, imageName: categoryToIcon[.cameraInstallation] ?? "", backgroundColor: .black),
     ServiceCategory(title: ServiceCategoryType.doorInstallation.rawValue, imageName: categoryToIcon[.doorInstallation] ?? "", backgroundColor: .green),
     ServiceCategory(title: ServiceCategoryType.flooringInstallation.rawValue, imageName: categoryToIcon[.flooringInstallation] ?? "", backgroundColor: .orange),
     ServiceCategory(title: ServiceCategoryType.windowInstallation.rawValue, imageName: categoryToIcon[.windowInstallation] ?? "", backgroundColor: .gray),
     ServiceCategory(title: ServiceCategoryType.curtainInstallation.rawValue, imageName: categoryToIcon[.curtainInstallation] ?? "", backgroundColor: .purple),
    ]
   ),

   // Special Services
   ServiceSection(
    title: "Special Services",
    categories: [
     ServiceCategory(title: ServiceCategoryType.petCare.rawValue, imageName: categoryToIcon[.petCare] ?? "", backgroundColor: .brown),
     ServiceCategory(title: ServiceCategoryType.babySitting.rawValue, imageName: categoryToIcon[.babySitting] ?? "", backgroundColor: .pink),
    ]
   ),
  ]
 }
 
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
        selectedCategory = needHelpWith
        showCreateJobSheet = true
       }
      }

      VStack(spacing: 20) {
       ForEach(sections) { section in
        VStack(spacing: 12) {
         if section.isSpecialEvent {
          // Special Event Styling
          ZStack {
           RoundedRectangle(cornerRadius: 25)
            .fill(
             LinearGradient(
              gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.1)]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
             )
            )
            

           VStack(alignment: .leading, spacing: 8) {
            SectionHeader(
             title: section.title,
             showViewAll: false,
             onViewAllTap: {
              // Handle view all action
             }
            )
            .padding()

            ScrollView(.horizontal, showsIndicators: false) {
             HStack(spacing: 12) {
              ForEach(section.categories) { category in
               Button(action: {
                selectedCategory = category.title
                showCreateJobSheet = true
               }) {
                ServiceCategoryCard(
                 title: category.title,
                 imageName: category.imageName
                )
               }
              }
             }
             .padding(.horizontal)
            }
           }
          }
          .padding(.horizontal)
         } else {
          // Regular Section Styling
          SectionHeader(
           title: section.title,
           showViewAll: true,
           onViewAllTap: {
            // Handle view all action
           }
          )

          ScrollView(.horizontal, showsIndicators: false) {
           HStack(spacing: 12) {
            ForEach(section.categories) { category in
             Button(action: {
              selectedCategory = category.title
              showCreateJobSheet = true
             }) {
              ServiceCategoryCard(
               title: category.title,
               imageName: category.imageName
              )
             }
            }
           }
           .padding(.horizontal)
          }
         }
        }
       }
      }
     }
     Spacer()
      .frame(height: 60)
    }
   }
   .navigationTitle("I need help with")
  }
  .sheet(isPresented: $showCreateJobSheet) {
   if let category = selectedCategory {
    CreateJobSheet(selectedCategory: category, initialJobName: category)
   }
  }
 }
}

#Preview{
 HomeView()
}
