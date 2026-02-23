//
//  AddService.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI

struct AddService: View {
 var body: some View {
  ZStack{
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   
   NavigationStack{
    VStack{
     Image("")
      .resizable()
      .scaledToFit()
      .frame(width: 300, height: 300)
      .padding()
     
     
     
    }
    .navigationTitle("Add Service")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar{
     ToolbarItem(placement: .topBarLeading) {
      Button("Close") {
       
      }
     }
     
     ToolbarItem(placement: .topBarTrailing) {
      Button{
       
      } label: {
       Text("Publish")
        .tint(.green)
      }
     }
     
    }
   }
  }
 }
}
#Preview {
 AddService()
}
