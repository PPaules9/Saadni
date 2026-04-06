//
//  CreateJobSheet.swift
//  GoodShift
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
 let initialServiceImageName: String?
 
 var tabNames = ["Basic", "Location", "Pay", "Reqs", "Info"]
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // Progress Indicator
    VStack(spacing: 8) {
     HStack(spacing: 4) {
			 Button(action: {
                AnalyticsService.shared.track(.jobCreationAbandoned(lastStep: viewModel.currentTab, category: selectedCategory))
                dismiss()
             }) {
				 Image(systemName: "chevron.left")
					 .font(.system(size: 18, weight: .semibold))
					 .foregroundStyle(Colors.swiftUIColor(.textMain))
			 }
			 .padding(.trailing, 4)
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
		 .padding(.leading, 20)
     .padding(.horizontal)
     .padding(.bottom, 8)
    }
    .padding(.vertical, 8)
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

     if viewModel.currentTab < 4 {
      BrandButton(
       "Next",
       hasIcon: true,
       icon: "chevron.right",
       secondary: false
      ) {
       if viewModel.isCurrentTabValid {
        viewModel.showValidationError = false
        AnalyticsService.shared.track(.jobCreationStepCompleted(step: viewModel.currentTab + 1, category: selectedCategory))
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
     } else {
      BrandButton(
       "Review Shift(s)",
       hasIcon: true,
       icon: "checkmark",
       secondary: false
      ) {
       viewModel.showSummary = true
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
	.navigationBarBackButtonHidden()
  .alert("Address Saved", isPresented: $viewModel.showAddressSavedAlert) {
   Button("OK") {
    viewModel.nextTab()
   }
  } message: {
   Text("You can check saved address in profile tab under my Account section")
  }
  .sheet(isPresented: $viewModel.showImagePicker) {
   ImagePickerSheet(selectedImage: Binding(
    get: { viewModel.selectedImage },
    set: { newImage in
     viewModel.selectedImage = newImage
     // User picked a custom photo — clear the asset name so it gets uploaded
     if newImage != nil { viewModel.selectedAssetName = nil }
    }
   ))
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
   AnalyticsService.shared.track(.jobCreationStarted(category: selectedCategory))
   if let initialName = initialJobName {
    viewModel.jobName = initialName
   }
   if viewModel.selectedImage == nil, let imageName = initialServiceImageName {
    viewModel.selectedImage = UIImage(named: imageName)
    viewModel.selectedAssetName = imageName  // Mark as bundled asset — will skip upload
   }
   viewModel.currentUserId = authManager.currentUserId

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
  var freshUser = user
  freshUser.recalculateProfileCompletion()
  if freshUser.providerCompletionPercentage < 100 {
   profileCompletionPercentage = freshUser.providerCompletionPercentage
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

  let category = ServiceCategoryType.allCases.first { $0.rawValue == selectedCategory } ?? .foodAndBeverage
  guard let user = authManager.currentUser else { return }

  // MARK: Resolve image once — before creating any service documents
  let resolvedImage: ServiceImage

  if let assetName = viewModel.selectedAssetName {
   // Bundled asset: store the name, never upload to Storage
   resolvedImage = ServiceImage(assetName: assetName)
   viewModel.uploadState = .saving

  } else if let selectedImage = viewModel.selectedImage {
   // User-picked photo: compress once, upload once, reuse URL for all shifts
   viewModel.uploadState = .compressing
   let imageData = await Task.detached(priority: .userInitiated) {
    selectedImage.jpegData(compressionQuality: 0.7)
   }.value

   viewModel.uploadState = .uploading(progress: 0.0)

   if imageData != nil {
    do {
     // Delegate upload to the ViewModel — the View never touches StorageService directly
     if let imageURL = try await viewModel.uploadSelectedImage(userId: user.id) {
      resolvedImage = ServiceImage(remoteURL: imageURL.absoluteString)
     } else {
      resolvedImage = ServiceImage()
     }
    } catch {
     viewModel.publishError = error.localizedDescription
     viewModel.isPublishing = false
     viewModel.uploadState = .idle
     showErrorAlert = true
     return
    }
   } else {
    resolvedImage = ServiceImage()
   }
   viewModel.uploadState = .saving

  } else {
   resolvedImage = ServiceImage()
   viewModel.uploadState = .saving
  }

  let services = viewModel.createServices(category: category, user: user, serviceImage: resolvedImage)
  guard !services.isEmpty else {
   viewModel.publishError = "Could not generate any shifts. Please check the dates."
   viewModel.isPublishing = false
   viewModel.uploadState = .idle
   showErrorAlert = true
   return
  }

  do {
   for service in services {
    try await servicesStore.addService(service)
   }
   viewModel.uploadState = .completed
   viewModel.showSummary = false
   AnalyticsService.shared.track(.jobPublished(
    category: selectedCategory,
    price: Double(viewModel.price) ?? 0,
    city: viewModel.city,
    numDates: viewModel.selectedDates.count
   ))
   withAnimation {
    viewModel.showSuccessModal = true
   }
  } catch {
   let errorMessage = error.localizedDescription.isEmpty ? "Failed to publish job. Please try again." : error.localizedDescription
   viewModel.publishError = errorMessage
   viewModel.uploadState = .idle
   showErrorAlert = true
   AnalyticsService.shared.track(.jobPublishFailed(step: viewModel.currentTab + 1, error: errorMessage))
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
   
   // Delegate persistence to the ViewModel — the View never touches FirestoreService directly
   Task { await viewModel.saveNewAddressIfNeeded(for: currentUser, cache: userCache) }
   return true
  }
  return false
 }
}

#Preview {
 CreateJobSheet(selectedCategory: "Food & Beverage", initialJobName: nil, initialServiceImageName: nil)
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(ServicesStore())
  .environment(ProviderCoordinator())
}
