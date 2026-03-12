//
//  CreateJobSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import PhotosUI

struct CreateJobSheet: View {
 @Environment(\.dismiss) var dismiss
 @Environment(AuthenticationManager.self) var authManager
 @Environment(ServicesStore.self) var servicesStore
 @State private var viewModel = CreateJobViewModel()
 let selectedCategory: String
 let initialJobName: String?
 
 var tabNames = ["Details", "Pictures", "Tools", "Price", "Review"]
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // Progress Indicator
    VStack(spacing: 12) {
     HStack(spacing: 4) {
      ForEach(0..<5, id: \.self) { index in
       RoundedRectangle(cornerRadius: 2)
        .fill(index <= viewModel.currentTab ? Color.accent : Color.gray.opacity(0.3))
        .frame(height: 1)
      }
     }
     .padding(.horizontal)
     
     HStack(spacing: 0) {
      ForEach(0..<5, id: \.self) { index in
       Text(tabNames[index])
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundStyle(index <= viewModel.currentTab ? Color.accent : Color.gray)
        .frame(maxWidth: .infinity)
      }
     }
     .padding(.horizontal)
     .padding(.bottom, 8)
    }
    .padding(.vertical, 16)
    .background(Colors.swiftUIColor(.textPrimary))
    
    // Tab Content
    Group {
     switch viewModel.currentTab {
     case 0:
      CreateJobTab1(viewModel: viewModel, selectedCategory: selectedCategory)
     case 1:
      CreateJobTab2(viewModel: viewModel)
     case 2:
      CreateJobTab3(viewModel: viewModel)
     case 3:
      CreateJobTab4(viewModel: viewModel)
     case 4:
      CreateJobTab5(viewModel: viewModel, onPublish: {
       Task {
        await publishJob()
       }
      })
     default:
      EmptyView()
     }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    // Navigation Buttons
    HStack(spacing: 12) {
     if viewModel.currentTab > 0 {
      BrandButton( "Back", hasIcon: false, icon: "", secondary: true) {
       viewModel.previousTab()
      }
     }
     
     if viewModel.currentTab < 4 {
      BrandButton(
       "Next",
       hasIcon: true,
       icon: "chevron.right",
       secondary: false
      ) {
       if viewModel.isCurrentTabValid {
        viewModel.nextTab()
       }
      }
      .disabled(!viewModel.isCurrentTabValid)
     }
    }
    .padding()
    .background(Colors.swiftUIColor(.textPrimary))
   }
   
   if viewModel.showConfetti {
    ConfettiView(onAnimationComplete: {
     dismiss()
    })
   }
  }
  .sheet(isPresented: $viewModel.showImagePicker) {
   ImagePickerSheet(selectedImage: $viewModel.selectedImage)
    .presentationDetents([.fraction(0.4), .fraction(0.6)])
  }
  .onAppear {
   if let initialName = initialJobName {
    viewModel.jobName = initialName
   }
  }
 }
 
 private func publishJob() async {
  guard viewModel.canPublish() else { return }

  let serviceLocation = ServiceLocation(
   name: viewModel.city,
   coordinate: nil
  )

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: viewModel.selectedImage
  )

  let category = ServiceCategoryType.allCases.first { $0.rawValue == selectedCategory } ?? .homeCleaning

  let service = JobService(
   title: viewModel.jobName,
   price: Double(viewModel.price) ?? 0,
   location: serviceLocation,
   description: viewModel.otherDetails,
   image: serviceImage,
   category: category,
   providerId: authManager.currentUserId ?? ""
  )

  do {
   try await servicesStore.addService(service, image: viewModel.selectedImage)

   withAnimation {
    viewModel.showConfetti = true
   }
  } catch {
   print("❌ Error publishing service: \(error)")
  }
 }
}

#Preview {
 CreateJobSheet(selectedCategory: "TV Mounting", initialJobName: nil)
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(ServicesStore())
}
