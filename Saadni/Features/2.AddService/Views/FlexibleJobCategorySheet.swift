//
//  FlexibleJobCategorySheet.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct FlexibleJobCategorySheet: View {
 @Binding var selectedJobPath: String
 @Binding var jobType: JobType?
 @Environment(\.dismiss) var dismiss
 @State private var showCustomInput: Bool = false
 @State private var customJobName: String = ""
 
 var body: some View {
  NavigationStack {
   VStack {
    ScrollView {
     LazyVGrid(
      columns: [.init(.flexible()), .init(.flexible())],
      spacing: 16
     ) {
      ForEach(FlexibleJobCategory.allCases, id: \.self) { category in
       VStack(spacing: 8) {
        Image(systemName: category.icon)
         .font(.system(size: 32))
         .foregroundStyle(.accent)
        
        Text(category.rawValue)
         .font(.caption)
         .lineLimit(2)
         .multilineTextAlignment(.center)
         .foregroundStyle(.primary)
       }
       .frame(maxWidth: .infinity)
       .padding(16)
       .background(Colors.swiftUIColor(.textPrimary))
       .cornerRadius(30)
       .onTapGesture {
        selectedJobPath = "Flexible: \(category.rawValue)"
        jobType = nil
        dismiss()
       }
      }
      
      // Other/Custom Option
      VStack(spacing: 8) {
       Image(systemName: "plus.circle")
        .font(.system(size: 32))
        .foregroundStyle(.accent)
       
       Text("Other")
        .font(.caption)
        .foregroundStyle(.primary)
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(Colors.swiftUIColor(.textPrimary))
      .cornerRadius(30)
      .onTapGesture {
       showCustomInput = true
      }
     }
    }
    .padding(20)
   }
   .navigationTitle("Flexible Jobs")
   .navigationBarTitleDisplayMode(.inline)
   .background(Color.clear)
   .sheet(isPresented: $showCustomInput) {
    CustomJobInputSheet(
     customJobName: $customJobName,
     selectedJobPath: $selectedJobPath,
     jobType: $jobType,
     isPresented: $showCustomInput,
     dismissParent: { dismiss() },
     jobTypeLabel: "Flexible"
    )
    .presentationDetents([.fraction(0.35), .fraction(0.65)])
   }
   .toolbar{
    ToolbarItem(placement: .navigationBarTrailing) {
     Button("Cancel") {
      jobType = nil
      dismiss()
     }
    }
   }
  }
 }
}

#Preview {
 FlexibleJobCategorySheet(
  selectedJobPath: .constant(""),
  jobType: .constant(.flexibleJobs)
 )
}
