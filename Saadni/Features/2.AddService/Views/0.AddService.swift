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
 @State private var title: String = ""
 @State private var price: String = ""
 @State private var position: String = ""
 @State private var description: String = ""
 @State private var selectedImage: UIImage?
 @State private var showImagePicker: Bool = false
 @State private var showMapSheet: Bool = false
 @State private var mapPosition: MapCameraPosition = .region(
  MKCoordinateRegion(
   center: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
   span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
  )
 )
 @State private var selectedLocation: CLLocationCoordinate2D?
 @State private var selectedLocationName: String = ""

 // Job Selection States
 @State private var jobType: JobType? = nil
 @State private var selectedJobPath: String = ""
 @State private var showJobTypeSheet: Bool = false
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    ScrollView {
     VStack(spacing: 0) {
      // Image Picker Section
      Group {
       if let image = selectedImage {
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
       showImagePicker = true
      }
      
      // Form Fields
      VStack(spacing: 8) {
       // Title and Price Row
       HStack(spacing: 8) {
        BrandTextField(
         hasTitle: false,
         title: "Title",
         placeholder: "Title",
         text: $title
        )
        .frame(maxWidth: .infinity)
        
        BrandTextField(
         hasTitle: false,
         title: "Price",
         placeholder: "Price",
         text: $price
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
       Button(action: { showJobTypeSheet = true }) {
        HStack {
         Text(selectedJobPath.isEmpty ? "Select Job Type" : selectedJobPath)
          .foregroundStyle(selectedJobPath.isEmpty ? Colors.swiftUIColor(.textSecondary) : Colors.swiftUIColor(.textMain))
         Spacer()
         Image(systemName: "chevron.right")
          .foregroundStyle(.gray)
        }
        .padding(16)
        .background(selectedJobPath.isEmpty ? Colors.swiftUIColor(.textPrimary) : Color.clear)
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
        text: $position
       )
       .padding(.horizontal, 20)
       
       // MapView
       ZStack(alignment: .bottomTrailing) {
        Map(position: $mapPosition)
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
        showMapSheet = true
       }
       
       // Description Field
       BrandTextEditor(
        hasTitle: false,
        title: "Description",
        placeholder: "Description",
        text: $description
       )
       .padding(.horizontal, 20)
       .padding(.top, 8)
      }
     }
    }
    .padding(.bottom)
    .navigationTitle("Add Service")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
     ToolbarItem(placement: .topBarTrailing) {
      BrandButton("Publish", hasIcon: false, icon: "") {
       // Publish action
      }

     }
    }
   }
  }
  .sheet(isPresented: $showImagePicker) {
   ImagePickerSheet(selectedImage: $selectedImage)
    .presentationDetents([.fraction(0.3), .fraction(0.55)])
  }
 
  // Step 1 Sheet: Job Type Selection
  .sheet(isPresented: $showJobTypeSheet) {
   JobTypeSelectionSheet(
    showSheet: $showJobTypeSheet,
    jobType: $jobType
   )
   .presentationDetents([.fraction(0.25)])
  }
  // Step 2 Sheet: Job Category Selection
  .sheet(isPresented: .constant(jobType != nil)) {
   if let jobType = jobType {
    JobCategorySheet(
     jobType: jobType,
     selectedJobPath: $selectedJobPath,
     jobType_: $jobType
    )
   }
  }
  
  
  .sheet(isPresented: $showMapSheet) {
   MapSelectionSheet(
    mapPosition: $mapPosition,
    selectedLocation: $selectedLocation,
    selectedLocationName: $selectedLocationName,
    position: $position
   )
  }
  
  
 }
}



#Preview {
 AddService()
}
