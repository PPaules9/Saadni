//
//  JobCategorySheet.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct JobCategorySheet: View {
 let jobType: JobType
 @Binding var selectedJobPath: String
 @Binding var jobType_: JobType?
 
 var body: some View {
  Group {
   if jobType == .flexibleJobs {
    FlexibleJobCategorySheet(
     selectedJobPath: $selectedJobPath,
     jobType: $jobType_
    )
   } else if jobType == .shift {
    AddShift(
     selectedJobPath: $selectedJobPath,
     jobType: $jobType_
    )
   }
  }
 }
}

#Preview {
 JobCategorySheet(
  jobType: .flexibleJobs,
  selectedJobPath: .constant(""),
  jobType_: .constant(.flexibleJobs)
 )
}
