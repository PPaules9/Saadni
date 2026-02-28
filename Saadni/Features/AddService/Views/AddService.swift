//
//  AddService.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddService: View {
 @Environment(\.dismiss) var dismiss
 @Environment(ServicesStore.self) var servicesStore
 @State private var viewModel = AddServiceViewModel()
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    ScrollView {
     VStack(spacing: 0) {
      // Image Picker Section
      Group {
       if let image = viewModel.selectedImage {
        Image(uiImage: image)
         .resizable()
         .scaledToFill()
         .frame(maxWidth: .infinity, maxHeight: 200)
         .clipped()
         .clipShape(RoundedRectangle(cornerRadius: 24))

       } else {
        ZStack{
         RoundedRectangle(cornerRadius: 24)
          .fill(Color(Colors.swiftUIColor(.textPrimary)))
         
         VStack(spacing: 12) {
          Image(systemName: "camera")
           .font(.system(size: 48))
           .foregroundStyle(Colors.swiftUIColor(.textSecondary))
         }
        }
       }
      }
      .frame(height: 200)
      .padding()
      .onTapGesture {
       viewModel.showImagePicker = true
      }
      
      // Form Fields
      VStack(spacing: 8) {
       // Title and Price Row
       HStack(spacing: 8) {
        BrandTextField(
         hasTitle: false,
         title: "Title",
         placeholder: "Title",
         text: $viewModel.title
        )
        .frame(maxWidth: .infinity)
        
        BrandTextField(
         hasTitle: false,
         title: "Price",
         placeholder: "Price",
         text: $viewModel.price
        )
        .keyboardType(.numberPad)
        .frame(maxWidth: 100)
        .overlay(
         HStack{
          Spacer()
          Text("EGP")
           .font(.caption)
           .foregroundStyle(Colors.swiftUIColor(.textSecondary))
         }
          .padding(.trailing, 16)
        )
       }
         
       .padding(.horizontal, 20)

       // Job Type Selection Button
       Button(action: { viewModel.showJobTypeSheet = true }) {
        HStack {
         Text(viewModel.jobTypeDisplayName)
          .foregroundStyle(viewModel.jobType == nil ? Colors.swiftUIColor(.textSecondary) : Colors.swiftUIColor(.textMain))
         Spacer()
         Image(systemName: "chevron.right")
          .foregroundStyle(.gray)
        }
        .padding(16)
        .background(viewModel.jobType == nil ? Colors.swiftUIColor(.textPrimary) : Color.clear)
        .overlay(
         RoundedRectangle(cornerRadius: 100)
          .fill(Color.clear)
          .stroke(.gray.opacity(0.3), lineWidth: 1)
         )
        .cornerRadius(100)
       }
       .padding(.horizontal, 20)
       
       
       // Location Field
       BrandTextField(
        hasTitle: false,
        title: "Location",
        placeholder: "Location",
        text: $viewModel.selectedLocationName
       )
       .padding(.horizontal, 20)
       
       // MapView
       ZStack(alignment: .bottomTrailing) {
        Map(position: $viewModel.mapPosition)
         .mapStyle(.standard)
         .clipShape(RoundedRectangle(cornerRadius: 24))

        VStack(alignment: .trailing, spacing: 8) {
         Link("Legal", destination: URL(string: "https://www.apple.com")!)
          .font(.caption)
          .foregroundStyle(.blue)
          .padding(12)
        }
        .padding(12)
       }
       .frame(height: 200)
       .padding(.horizontal, 20)
       .padding(.vertical, 8)
       .onTapGesture {
        viewModel.showMapSheet = true
       }
       
       // Description Field
       BrandTextEditor(
        hasTitle: false,
        title: "Description",
        placeholder: "Description",
        text: $viewModel.description
       )
       .padding(.horizontal, 20)
       .padding(.top, 8)
      }
     }
     
     VStack(spacing: 16){
      BrandButton("Publish", hasIcon: true, icon: "list.bullet.rectangle.portrait", secondary: false) {

        if viewModel.jobType == .flexibleJobs,
           let category = viewModel.selectedFlexibleCategory {
         if let service = viewModel.createFlexibleJobService(category: category) {
          print("✅ Created Flexible Job: \(service.title)")
          servicesStore.addFlexibleJob(service)
          dismiss()
         }
        } else if viewModel.jobType == .shift {
         if let service = viewModel.createShiftService() {
          print("✅ Created Shift: \(service.shiftName)")
          servicesStore.addShift(service)
          dismiss()
         }
        }
       }
       .disabled(!viewModel.isFormValid)  // ← Disable if form invalid!

       
       
     
      BrandButton("Draft", hasIcon: true, icon: "archivebox", secondary: true) {
       if viewModel.jobType == .flexibleJobs,
          let category = viewModel.selectedFlexibleCategory {
        if let service = viewModel.createFlexibleJobDraft(category: category) {
         print("✅ Saved Flexible Job Draft: \(service.title)")
         servicesStore.addFlexibleJob(service)
         dismiss()
        }
       } else if viewModel.jobType == .shift {
        if let service = viewModel.createShiftDraft() {
         print("✅ Saved Shift Draft: \(service.shiftName)")
         servicesStore.addShift(service)
         dismiss()
        }
       }
      }
     }
     .padding()
    }
    .padding(.bottom)
    .navigationTitle("Add Service")
    .navigationBarTitleDisplayMode(.inline)

   }
  }
  .sheet(isPresented: $viewModel.showImagePicker) {
   ImagePickerSheet(selectedImage: $viewModel.selectedImage)
    .presentationDetents([.fraction(0.3), .fraction(0.55)])
  }
 
  // Step 1 Sheet: Job Type Selection
  .sheet(isPresented: $viewModel.showJobTypeSheet) {
   JobTypeSelectionSheet(
    showSheet: $viewModel.showJobTypeSheet,
    jobType: $viewModel.jobType
   )
   .presentationDetents([.fraction(0.25)])
   .onDisappear {
    if viewModel.jobType != nil {
     viewModel.showJobCategorySheet = true
    }
   }
  }
  // Step 2 Sheet: Job Category Selection
  .sheet(isPresented: $viewModel.showJobCategorySheet) {
   JobCategorySheet(viewModel: viewModel)
  }
  
  
  .sheet(isPresented: $viewModel.showMapSheet) {
   MapSelectionSheet(
    mapPosition: $viewModel.mapPosition,
    selectedLocation: $viewModel.selectedLocation,
    selectedLocationName: $viewModel.selectedLocationName,
    position: $viewModel.selectedLocationName
   )
  }
  
  
 }
}



#Preview {
 AddService()
}
