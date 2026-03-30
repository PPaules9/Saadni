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
 @Environment(ProviderCoordinator.self) var coordinator
 @Environment(UserCache.self) var userCache
 @State private var viewModel = CreateJobViewModel()
 @State private var showErrorAlert = false
 @State private var showProfileCompletionPopup = false
 @State private var profileCompletionPercentage = 0
 @State private var showEditProfile = false
 let selectedCategory: String
 let initialJobName: String?
 
 var tabNames = ["Basic", "Location", "Pay", "Reqs", "Info", "Company"]
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // Progress Indicator
    VStack(spacing: 12) {
     HStack(spacing: 4) {
      ForEach(0..<6, id: \.self) { index in
       RoundedRectangle(cornerRadius: 2)
        .fill(index <= viewModel.currentTab ? Color.accent : Color.gray.opacity(0.3))
        .frame(height: 1)
      }
     }
     .padding(.horizontal)
     
     HStack(spacing: 0) {
      ForEach(0..<6, id: \.self) { index in
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
      CreateJobTab5(viewModel: viewModel)
     case 5:
      CreateJobTab6(viewModel: viewModel, onPublish: {
       viewModel.showSummary = true
      })
     default:
      EmptyView()
     }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    // Validation Error Message
    if viewModel.showValidationError, let validationError = viewModel.currentTabValidationError {
     HStack(spacing: 8) {
      Image(systemName: "exclamationmark.circle.fill")
       .foregroundStyle(.red)
      Text(validationError)
       .font(.caption)
       .foregroundStyle(.red)
      Spacer()
     }
     .padding(12)
     .background(Color.red.opacity(0.1))
     .cornerRadius(8)
     .padding()
    }

    // Navigation Buttons
    HStack(spacing: 12) {
     if viewModel.currentTab > 0 {
      BrandButton( "Back", hasIcon: false, icon: "", secondary: true) {
       viewModel.previousTab()
      }
     }

     if viewModel.currentTab < 5 {
      BrandButton(
       "Next",
       hasIcon: true,
       icon: "chevron.right",
       secondary: false
      ) {
       if viewModel.isCurrentTabValid {
        viewModel.showValidationError = false
        if viewModel.currentTab == 1 {
         let didSave = saveAddressIfNeeded()
         if didSave {
          viewModel.showAddressSavedAlert = true
         } else {
          viewModel.nextTab()
         }
        } else {
         viewModel.nextTab()
        }
       } else {
        viewModel.showValidationError = true
       }
      }
     }
    }
    .padding()
    .background(Colors.swiftUIColor(.textPrimary))
   }
   
   if viewModel.showSuccessModal {
    JobPublishedSuccessModal(
     viewModel: viewModel,
     onComplete: navigateToMyJobs
    )
   }
  }
  .alert("Address Saved", isPresented: $viewModel.showAddressSavedAlert) {
   Button("OK") {
    viewModel.nextTab()
   }
  } message: {
   Text("You can check saved address in profile tab under my Account section")
  }
  .sheet(isPresented: $viewModel.showImagePicker) {
   ImagePickerSheet(selectedImage: $viewModel.selectedImage)
    .presentationDetents([.fraction(0.4), .fraction(0.6)])
  }
  .sheet(isPresented: $viewModel.showSummary) {
   CreateJobSummaryModal(viewModel: viewModel, onPublish: {
    handlePublish()
   })
  }
  .sheet(isPresented: $showProfileCompletionPopup) {
   ProfileCompletionPopup(
    completionPercentage: profileCompletionPercentage,
    onComplete: {
     showProfileCompletionPopup = false
     showEditProfile = true
    },
    onDismiss: {
     showProfileCompletionPopup = false
    }
   )
  }
  .sheet(isPresented: $showEditProfile) {
   EditProfileSheet()
  }
  .alert("Publishing Error", isPresented: $showErrorAlert) {
   Button("OK") {
    showErrorAlert = false
   }
  } message: {
   Text(viewModel.publishError ?? "An unknown error occurred")
  }
  .onAppear {
   if let initialName = initialJobName {
    viewModel.jobName = initialName
   }
   viewModel.currentUserId = authManager.currentUserId
   viewModel.applyCompanyInfo(authManager.currentUser)

   if let currentUser = authManager.currentUser,
      let defaultId = currentUser.defaultAddressId,
      let defaultAddress = currentUser.savedAddresses?.first(where: { $0.id == defaultId }) {
       viewModel.applyDefaultAddress(defaultAddress)
   }
  }
 }
 
 private func handlePublish() {
  UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  guard let user = authManager.currentUser else { return }

  // Check PROVIDER profile completion (posting jobs requires provider role)
  if user.providerCompletionPercentage < 100 {
   profileCompletionPercentage = user.providerCompletionPercentage
   viewModel.showSummary = false
   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    showProfileCompletionPopup = true
   }
   return
  }

  // Proceed with publish
  Task {
   await publishJob()
  }
 }

 private func publishJob() async {
  guard viewModel.isFormValid else {
   viewModel.publishError = "Please complete all required fields"
   showErrorAlert = true
   return
  }

  viewModel.isPublishing = true
  viewModel.uploadState = .compressing

  // Compress image in background thread (non-blocking)
  let selectedImage = viewModel.selectedImage
  let imageToUpload = await Task.detached(priority: .userInitiated) {
   selectedImage.flatMap { image in
    guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
    return UIImage(data: data)
   } ?? selectedImage
  }.value

  viewModel.uploadState = .uploading(progress: 0.0)

  let category = ServiceCategoryType.allCases.first { $0.rawValue == selectedCategory } ?? .foodAndBeverage
  
  let services = viewModel.createServices(category: category)
  guard !services.isEmpty else {
      viewModel.publishError = "Could not generate any shifts. Please check the dates."
      viewModel.isPublishing = false
      showErrorAlert = true
      return
  }

  do {
   viewModel.uploadState = .saving
   for service in services {
    try await servicesStore.addService(service, image: imageToUpload)
   }

   viewModel.uploadState = .completed
   viewModel.showSummary = false // Dismiss summary sheet
   saveCompanyInfoIfNeeded()
   withAnimation {
    viewModel.showSuccessModal = true
   }
  } catch {
   let errorMessage = error.localizedDescription.isEmpty ? "Failed to publish job. Please try again." : error.localizedDescription
   viewModel.publishError = errorMessage
   viewModel.uploadState = .idle
   showErrorAlert = true
   print("❌ Error publishing service: \(error)")
  }

  viewModel.isPublishing = false
 }

 private func navigateToMyJobs() {
  dismiss() // Dismiss sheet first

  // Wait for dismissal animation, then navigate
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
   coordinator.selectTab(.myJobs)
  }
 }
 
 private func saveCompanyInfoIfNeeded() {
  guard var currentUser = authManager.currentUser else { return }

  let nameChanged     = currentUser.companyName        != viewModel.companyName
  let industryChanged = currentUser.industryCategory   != viewModel.industryCategory
  let contactChanged  = currentUser.contactPersonName  != viewModel.contactPersonName
  let phoneChanged    = currentUser.contactPersonPhone != viewModel.contactPersonPhone

  guard nameChanged || industryChanged || contactChanged || phoneChanged else { return }

  if !viewModel.companyName.isEmpty        { currentUser.companyName        = viewModel.companyName }
  if !viewModel.industryCategory.isEmpty   { currentUser.industryCategory   = viewModel.industryCategory }
  if !viewModel.contactPersonName.isEmpty  { currentUser.contactPersonName  = viewModel.contactPersonName }
  if !viewModel.contactPersonPhone.isEmpty { currentUser.contactPersonPhone = viewModel.contactPersonPhone }

  Task {
   try? await FirestoreService.shared.saveUser(currentUser)
   await userCache.updateUser(currentUser)
  }
 }

 private func saveAddressIfNeeded() -> Bool {
  guard var currentUser = authManager.currentUser else { return false }
  
  let exists = (currentUser.savedAddresses ?? []).contains { addr in
   addr.address == viewModel.address &&
   addr.city == viewModel.city
  }
  
  if !exists {
   let newAddress = SavedAddress(
    address: viewModel.address,
    floor: "",
    unit: "",
    city: viewModel.city
   )
   
   if currentUser.savedAddresses == nil {
    currentUser.savedAddresses = [newAddress]
   } else {
    currentUser.savedAddresses?.append(newAddress)
   }
   
   currentUser.defaultAddressId = newAddress.id
   
   Task {
    try? await FirestoreService.shared.saveUser(currentUser)
    await userCache.updateUser(currentUser)
   }
   
   return true
  }
  return false
 }
}

#Preview {
 CreateJobSheet(selectedCategory: "Food & Beverage", initialJobName: nil)
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(ServicesStore())
  .environment(ProviderCoordinator())
}
