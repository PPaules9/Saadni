//
//  CustomJobInputSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct CustomJobInputSheet: View {
 @Binding var customJobName: String
 @Bindable var viewModel: AddServiceViewModel
 @Binding var isPresented: Bool
 let dismissParent: () -> Void
 let jobTypeLabel: String
 
 var body: some View {
  NavigationStack {
   VStack(spacing: 16) {

     BrandTextField(hasTitle: true, title: "Custom Job Name", placeholder: "Enter Job Name", text: $customJobName)


    Spacer()

    HStack(spacing: 12) {
     Button(action: {
      isPresented = false
      dismissParent()
     }) {
      Text("Cancel")
       .frame(maxWidth: .infinity)
       .padding(.vertical, 12)
       .background(Color(.systemGray6))
       .cornerRadius(100)
       .foregroundStyle(.primary)
     }

     Button(action: {
      if !customJobName.trimmingCharacters(in: .whitespaces).isEmpty {
       viewModel.selectedJobPath = "\(jobTypeLabel): \(customJobName)"
       isPresented = false
       dismissParent()
      }
     }) {
      Text("Confirm")
       .frame(maxWidth: .infinity)
       .padding(.vertical, 12)
       .background(Color.accent)
       .cornerRadius(100)
       .foregroundStyle(.white)
     }
     .disabled(customJobName.trimmingCharacters(in: .whitespaces).isEmpty)
    }
   }
   .padding(20)
   .navigationTitle("Add Custom Job")
   .navigationBarTitleDisplayMode(.inline)
   .background(Color.clear)
  }
 }
}

#Preview {
 CustomJobInputSheet(
  customJobName: .constant(""),
  viewModel: AddServiceViewModel(),
  isPresented: .constant(true),
  dismissParent: {},
  jobTypeLabel: "Flexible"
 )
}
