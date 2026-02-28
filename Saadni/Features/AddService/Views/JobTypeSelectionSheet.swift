//
//  JobTypeSelectionSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct JobTypeSelectionSheet: View {
 @Binding var showSheet: Bool
 @Binding var jobType: JobType?
 
 var body: some View {
  VStack(spacing: 16) {
   Text("What type of job?")
    .font(.headline)
    .padding(.top, 12)
   
   HStack(spacing: 12) {
    Button(action: {
     jobType = .flexibleJobs
     showSheet = false
    }) {
     VStack(spacing: 8) {
      Image(systemName: "briefcase")
       .font(.system(size: 24))
       .foregroundStyle(.accent)
      Text("Flexible Job")
       .font(.subheadline)
       .foregroundStyle(.primary)
     }
     .frame(maxWidth: .infinity)
     .padding(.vertical, 20)
     .background(Colors.swiftUIColor(.textPrimary))
     .cornerRadius(30)
    }
    
    Button(action: {
     jobType = .shift
     showSheet = false
    }) {
     VStack(spacing: 8) {
      Image(systemName: "clock")
       .font(.system(size: 24))
       .foregroundStyle(.accent)
      Text("Shift Job")
       .font(.subheadline)
       .foregroundStyle(.primary)
     }
     .frame(maxWidth: .infinity)
     .padding(.vertical, 20)
     .background(Colors.swiftUIColor(.textPrimary))
     .cornerRadius(30)
    }
   }
   
   Spacer()
  }
  .padding(20)
  .background(Color.clear)
 }
}

#Preview {
 JobTypeSelectionSheet(showSheet: .constant(true), jobType: .constant(nil))
}
