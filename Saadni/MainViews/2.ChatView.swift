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
      .foregroundStyle(.gray)
      .padding()
     
     // Mock Chat Item Preview (as seen in screenshot design)
     HStack {
      Image("profile_placeholder") // Or system image
       .resizable()
       .aspectRatio(contentMode: .fill)
       .frame(width: 50, height: 50)
       .background(Color.gray)
       .clipShape(RoundedRectangle(cornerRadius: 10))
       .overlay(
        Image(systemName: "person.fill")
         .foregroundStyle(.white)
       )
      
      VStack(alignment: .leading) {
       Text("Pavly Hanna")
        .font(.headline)
        .foregroundStyle(.white)
       Text("Joined 6 June 2026")
        .font(.caption)
        .foregroundStyle(.gray)
      }
      
      Spacer()
      
      Image(systemName: "bubble.left.fill")
       .foregroundStyle(.green)
     }
     .padding()
     .background(Color(.systemGray6).opacity(0.3))
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
