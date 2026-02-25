//
//  ImagePickerCoordinator.swift
//  Saadni
//
//  Created by Pavly Paules on 23/02/2026.
//

import SwiftUI

class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 @Binding var selectedImage: UIImage?
 let dismiss: DismissAction
 let allowsEditing: Bool

 init(
  selectedImage: Binding<UIImage?>,
  dismiss: DismissAction,
  allowsEditing: Bool
 ) {
  _selectedImage = selectedImage
  self.dismiss = dismiss
  self.allowsEditing = allowsEditing
 }

 func imagePickerController(
  _ picker: UIImagePickerController,
  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
 ) {
  let imageKey: UIImagePickerController.InfoKey = allowsEditing ? .editedImage : .originalImage

  if let image = info[imageKey] as? UIImage {
   selectedImage = image
  }
  dismiss()
 }

 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
  dismiss()
 }
}
