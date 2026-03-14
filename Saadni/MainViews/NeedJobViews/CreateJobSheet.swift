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
 @Environment(JobSeekerCoordinator.self) var coordinator
 @State private var viewModel = CreateJobViewModel()
 @State private var showErrorAlert = false
 let selectedCategory: String
 let initialJobName: String?
 
 var tabNames = ["Details", "Pictures", "Tools", "Price", "Schedule", "Review"]
 
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
    if let validationError = viewModel.currentTabValidationError {
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
        viewModel.nextTab()
       }
      }
      .disabled(!viewModel.isCurrentTabValid)
     }
    }
    .padding()
    .background(Colors.swiftUIColor(.textPrimary))
   }
   
   if viewModel.showSuccessModal {
    JobPublishedSuccessModal(
     jobTitle: viewModel.jobName,
     jobPrice: "EGP \(viewModel.price)",
     jobImage: viewModel.selectedImage,
     onComplete: navigateToMyJobs
    )
   }
  }
  .sheet(isPresented: $viewModel.showImagePicker) {
   ImagePickerSheet(selectedImage: $viewModel.selectedImage)
    .presentationDetents([.fraction(0.4), .fraction(0.6)])
  }
  .sheet(isPresented: $viewModel.showSummary) {
   VStack(spacing: 0) {
    // Header
    VStack(spacing: 8) {
     Text("Review Your Job")
      .font(.headline)
      .fontWeight(.semibold)
     Text("Preview and publish your job posting")
      .font(.caption)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Colors.swiftUIColor(.textPrimary))

    // Summary Content
    ScrollView {
     VStack(spacing: 16) {
      if let image = viewModel.selectedImage {
       Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .frame(height: 180)
        .cornerRadius(12)
        .clipped()
      }

      VStack(alignment: .leading, spacing: 8) {
       Text("Job Details").font(.subheadline).fontWeight(.semibold).foregroundStyle(Color.accent)
       VStack(alignment: .leading, spacing: 4) {
        Text("Job Name").font(.caption2).foregroundStyle(Colors.swiftUIColor(.textSecondary))
        Text(viewModel.jobName).font(.subheadline).fontWeight(.semibold)
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding(8)
       .background(Colors.swiftUIColor(.appBackground))
       .cornerRadius(8)
      }
     }
     .padding()
    }

    // Progress UI during upload
    if case .compressing = viewModel.uploadState {
     VStack(spacing: 8) {
      ProgressView().tint(.accent)
      Text("Compressing image...").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .frame(maxWidth: .infinity)
     .padding()
     .background(Color.accent.opacity(0.1))
     .cornerRadius(8)
     .padding()
    } else if case .uploading(let progress) = viewModel.uploadState {
     VStack(spacing: 8) {
      ProgressView(value: progress).tint(.accent)
      Text("Uploading image... \(Int(progress * 100))%").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .frame(maxWidth: .infinity)
     .padding()
     .background(Color.accent.opacity(0.1))
     .cornerRadius(8)
     .padding()
    } else if case .saving = viewModel.uploadState {
     VStack(spacing: 8) {
      ProgressView().tint(.accent)
      Text("Saving job details...").font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }
     .frame(maxWidth: .infinity)
     .padding()
     .background(Color.accent.opacity(0.1))
     .cornerRadius(8)
     .padding()
    }

    // Action Buttons
    HStack(spacing: 12) {
     BrandButton("Cancel", isDisabled: viewModel.isPublishing, hasIcon: false, icon: "", secondary: true) {
      viewModel.showSummary = false
     }

     BrandButton(viewModel.isPublishing ? "Publishing..." : "Publish", isDisabled: viewModel.isPublishing, hasIcon: true, icon: "paperplane.fill", secondary: false) {
      Task {
       await publishJob()
      }
     }
    }
    .padding()
    .background(Colors.swiftUIColor(.textPrimary))
   }
   .background(Colors.swiftUIColor(.appBackground))
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
  }
 }
 
 private func publishJob() async {
  guard viewModel.canPublish() else {
   viewModel.publishError = "Please complete all required fields"
   showErrorAlert = true
   return
  }

  viewModel.isPublishing = true
  viewModel.uploadState = .compressing

  let serviceLocation = ServiceLocation(
   name: viewModel.city,
   coordinate: nil
  )

  // Compress image in background thread (non-blocking)
  let selectedImage = viewModel.selectedImage
  let imageToUpload = await Task.detached(priority: .userInitiated) {
   selectedImage.flatMap { image in
    guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
    return UIImage(data: data)
   } ?? selectedImage
  }.value

  viewModel.uploadState = .uploading(progress: 0.0)

  let serviceImage = ServiceImage(
   localId: UUID().uuidString,
   remoteURL: nil,
   localImage: imageToUpload
  )

  let category = ServiceCategoryType.allCases.first { $0.rawValue == selectedCategory } ?? .homeCleaning

  let service = JobService(
   title: viewModel.jobName,
   price: Double(viewModel.price) ?? 0,
   location: serviceLocation,
   description: viewModel.otherDetails,
   image: serviceImage,
   category: category,
   providerId: authManager.currentUserId ?? "",
   address: viewModel.address,
   floor: viewModel.floor,
   unit: viewModel.unit,
   someoneAround: viewModel.aroundOption != .noOne,
   specialTools: viewModel.toolsNeeded == .yes ? viewModel.toolsDescription : nil,
   serviceDate: viewModel.getServiceDate(),
   estimatedDurationHours: viewModel.getEstimatedDurationHours(),
   status: .published
  )

  do {
   viewModel.uploadState = .saving
   try await servicesStore.addService(service, image: imageToUpload)

   viewModel.uploadState = .completed
   viewModel.showSummary = false // Dismiss summary sheet
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
}

#Preview {
 CreateJobSheet(selectedCategory: "TV Mounting", initialJobName: nil)
  .environment(UserCache())
  .environment(AuthenticationManager(userCache: UserCache()))
  .environment(ServicesStore())
}
