//
//  Dashboard.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI

struct Dashboard: View {
 var body: some View {
  NavigationStack{
   VStack{
    Text("1- Summary for latest Jobs done by user")
    Text("2- How much he made tell now")
    Text("3- Next Jobs (Upcoming) if he reserve one")
    
   }
   .navigationTitle("Dashboard")
  }
 }
}

#Preview {
 Dashboard()
}
