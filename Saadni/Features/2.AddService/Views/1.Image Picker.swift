//
//  Image Picker.swift
//  Saadni
//
//  Created by Pavly Paules on 23/02/2026.
//

import SwiftUI

// MARK: - Image Source (Identifiable wrapper)
enum ImageSource: Identifiable {
 case camera
 case photoLibrary
 
 var id: String {
  switch self {
  case .camera:
   return "camera"
  case .photoLibrary:
   return "photoLibrary"
  }
 }
 
 var sourceType: UIImagePickerController.SourceType {
  switch self {
  case .camera:
   return .camera
  case .photoLibrary:
   return .photoLibrary
  }
 }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
 @Binding var selectedImage: UIImage?
 @Environment(\.dismiss) var dismiss
 
 let sourceType: UIImagePickerController.SourceType
 let allowsEditing: Bool
 
 init(
  selectedImage: Binding<UIImage?>,
  sourceType: UIImagePickerController.SourceType = .photoLibrary,
  allowsEditing: Bool = false
 ) {
  self._selectedImage = selectedImage
  self.sourceType = sourceType
  self.allowsEditing = allowsEditing
 }
 
 func makeUIViewController(context: Context) -> UIImagePickerController {
  let picker = UIImagePickerController()
  picker.delegate = context.coordinator
  picker.sourceType = sourceType
  picker.allowsEditing = allowsEditing
  return picker
 }
 
 func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
 
 func makeCoordinator() -> ImagePickerCoordinator {
  ImagePickerCoordinator(
   selectedImage: $selectedImage,
   dismiss: dismiss,
   allowsEditing: allowsEditing
  )
 }
}




struct ImagePickerSheet: View {
 @Binding var selectedImage: UIImage?
 @State private var selectedSource: ImageSource?
 @Environment(\.dismiss) var dismiss
 
 var body: some View {
  VStack(spacing: 16) {
   Text("Choose Photo Source")
    .font(.headline)
    .fontDesign(.rounded)
   
   VStack(alignment: .leading, spacing: 8){
    // Camera button
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
     BrandButton("Take a Photo", hasIcon: true, icon: "camera.fill") {
      selectedSource = .camera
     }
    }
    
    BrandButton("Choose from Library", hasIcon: true, icon: "photo.fill") {
     selectedSource = .photoLibrary
     
    }
   }
  }
  .padding()
  .sheet(item: $selectedSource) { source in
   ImagePicker(selectedImage: $selectedImage, sourceType: source.sourceType)
  }
  .onChange(of: selectedImage) { oldValue, newValue in
   if newValue != nil {
    dismiss()
   }
  }
 }
}

#Preview {
 @Previewable @State var selectedImage: UIImage?
 ImagePickerSheet(selectedImage: $selectedImage)
}
