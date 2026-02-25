//
//  ChatView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ChatView: View {
 var body: some View {
  ZStack{
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    VStack {
     Spacer()
     
     Text("Start a conversation on the\nservice page clicking the chat icon")
      .multilineTextAlignment(.center)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .padding()
     
     // Mock Chat Item Preview (as seen in screenshot design)
     HStack {
      Image("profile_placeholder") // Or system image
       .resizable()
       .aspectRatio(contentMode: .fill)
       .frame(width: 50, height: 50)
       .background(Color(.systemGray5))
       .clipShape(RoundedRectangle(cornerRadius: 10))
       .overlay(
        Image(systemName: "person.fill")
         .foregroundStyle(Colors.swiftUIColor(.textMain))
       )
      
      VStack(alignment: .leading) {
       Text("Pavly Hanna")
        .font(.headline)
        .foregroundStyle(Colors.swiftUIColor(.textMain))
       Text("Joined 6 June 2026")
        .font(.caption)
        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      }
      
      Spacer()
      
      Image(systemName: "bubble.left.fill")
       .foregroundStyle(.accent)
     }
     .padding()
     .background(Colors.swiftUIColor(.textPrimary))
     .clipShape(RoundedRectangle(cornerRadius: 20))
     .padding(.horizontal)
     
     Spacer()
    }
    .navigationTitle("Chats")
    .navigationBarTitleDisplayMode(.inline)
   }
  }
 }
}



#Preview {
 ChatView()
}
