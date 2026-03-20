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
 let categories: [(title: String, categoryEnum: String, services: [(name: String, displayName: String)])] = [
  ("Food & Beverage", ServiceCategoryType.foodAndBeverage.rawValue, [
   ("homeCleaning", "Cashier at fast food (McDonald's, KFC, Hardee's, Burger King)"),
   ("outdoorCleaning", "Barista / counter staff (Starbucks, Costa, Cilantro, Dunkin')"),
   ("carpetCleaning", "Waiter / runner at cafés and restaurants"),
   ("beachBabySetting", "Food delivery support (sorting orders in dark kitchens)"),
   ("helpMoving", "Event catering server (weddings, corporate events)"),
   ("homeCleaning", "Food truck helper")
  ]),
  ("Retail & Malls", ServiceCategoryType.retailAndMalls.rawValue, [
   ("doorInstallation", "Retail sales associate (clothing, accessories, electronics)"),
   ("tvMounting", "Mall cashier"),
   ("furnitureAssembly", "Stock replenishment / shelf stacker"),
   ("outdoorCleaning", "Fitting room attendant"),
   ("beachBabySetting", "Gift wrapper during holidays"),
   ("carpetCleaning", "Promotional stand attendant")
  ]),
  ("Logistics & Warehousing", ServiceCategoryType.logisticsAndWarehousing.rawValue, [
   ("helpMoving", "Warehouse picker & packer (Amazon, Noon, Jumia)"),
   ("furnitureAssembly", "Order sorter"),
   ("electricWork", "Inventory counter"),
   ("helpMoving", "Loading/unloading helper"),
   ("outdoorCleaning", "Last-mile delivery assistant (on bike or foot)")
  ]),
  ("Cleaning & Maintenance", ServiceCategoryType.cleaningAndMaintenance.rawValue, [
   ("homeCleaning", "Home cleaning shift"),
   ("carpetCleaning", "Office cleaning shift"),
   ("outdoorCleaning", "Post-event venue cleaning"),
   ("doorInstallation", "Car wash attendant"),
   ("homeCleaning", "Building common area cleaning")
  ]),
  ("Petrol & Automotive", ServiceCategoryType.petrolAndAutomotive.rawValue, [
   ("tvMounting", "Petrol station attendant (benzena)"),
   ("outdoorCleaning", "Car wash & detailing assistant"),
   ("doorInstallation", "Parking lot attendant")
  ]),
  ("Security & Crowd Management", ServiceCategoryType.securityAndCrowdManagement.rawValue, [
   ("doorInstallation", "Event security / door check"),
   ("beachBabySetting", "Parking enforcement helper"),
   ("tvMounting", "Mall entrance checker")
  ]),
  ("Hospitality & Events", ServiceCategoryType.hospitalityAndEvents.rawValue, [
   ("furnitureAssembly", "Event setup & teardown crew"),
   ("beachBabySetting", "Exhibition / trade fair helper"),
   ("homeCleaning", "Hotel housekeeping shift"),
   ("carpetCleaning", "Hotel breakfast service assistant"),
   ("tvMounting", "Venue usher")
  ]),
  ("Moving & Labour", ServiceCategoryType.movingAndLabour.rawValue, [
   ("helpMoving", "Moving crew helper (furniture removals)"),
   ("furnitureAssembly", "IKEA-style furniture assembly helper"),
   ("electricWork", "Construction site labourer (light tasks)")
  ]),
  ("Community & Outdoor", ServiceCategoryType.communityAndOutdoor.rawValue, [
   ("beachBabySetting", "Flyer & leaflet distributor"),
   ("tvMounting", "Mystery shopper"),
   ("outdoorCleaning", "Street promoter / brand ambassador"),
   ("doorInstallation", "Queue management helper")
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
       title: "I need help hire...",
       placeholder: "e.g., a barista, a cashier, an event helper...",
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
          ForEach(category.services, id: \.displayName) { service in
           Button(action: {
            coordinator.presentSheet(.createJob(
             category: category.categoryEnum,
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
