//
//  JobCategorySheet.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import SwiftUI

struct JobCategorySheet: View {
 @Bindable var viewModel: AddServiceViewModel
 @Environment(\.dismiss) var dismiss

 var body: some View {
  Group {
   if viewModel.jobType == .flexibleJobs {
    FlexibleJobCategorySheet(viewModel: viewModel, parentDismiss: dismiss)
   } else if viewModel.jobType == .shift {
    AddShift(viewModel: viewModel, parentDismiss: dismiss)
   }
  }
 }
}

#Preview {
 let vm = AddServiceViewModel()
 vm.jobType = .flexibleJobs
 return JobCategorySheet(viewModel: vm)
}
