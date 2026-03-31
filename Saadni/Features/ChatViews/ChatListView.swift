//
//  ChatListView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI


struct ConversationRow: View {
 let conversation: Conversation
 let currentUserId: String
 @State private var otherUserName: String = "User"
 @State private var isLoadingName = false
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack(spacing: 12) {
    // Avatar placeholder
    Circle()
     .fill(Colors.swiftUIColor(.primary))
     .frame(width: 48, height: 48)
     .overlay(
      Image(systemName: "person.fill")
       .foregroundStyle(Colors.swiftUIColor(.surfaceWhite))
     )
    
    VStack(alignment: .leading, spacing: 4) {
     Text(otherUserName)
      .font(.headline)
      .foregroundStyle(Colors.swiftUIColor(.textMain))
     
     Text(conversation.lastMessagePreview)
      .font(.caption)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      .lineLimit(1)
    }
    
    Spacer()
    
    VStack(alignment: .trailing, spacing: 4) {
     HStack(spacing: 4) {
      if conversation.isPinned {
       Image(systemName: "pin.fill")
        .font(.caption2)
        .foregroundStyle(Colors.swiftUIColor(.primary))
        .rotationEffect(.degrees(45))
      }
      Text(conversation.formattedLastMessageTime)
       .font(.caption)
       .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     }

     // Unread indicator (optional)
     if conversation.id.count > 5 {
      Circle()
       .fill(Colors.swiftUIColor(.primary))
       .frame(width: 10, height: 10)
     }
    }
   }
  }
  .padding(8)
  .onAppear {
   loadOtherUserName()
  }
 }
 
 private func loadOtherUserName() {
  guard let otherUserId = conversation.otherParticipantId(currentUserId: currentUserId) else { return }
  
  isLoadingName = true
  Task {
   do {
    if let user = try await FirestoreService.shared.fetchUser(id: otherUserId) {
     await MainActor.run {
			 otherUserName = user.displayName ?? user.email
     }
    }
   } catch {
    print("⚠️ Failed to load user name: \(error)")
   }
   isLoadingName = false
  }
 }
}

#Preview {
    ConversationRow(
        conversation: Conversation(
            id: "preview_conversation_id",
            participantIds: ["current_user_id", "other_user_id"],
            lastMessage: "Hey, how can I help you today?",
            lastMessageTime: Date(),
            lastMessageSenderId: "other_user_id"
        ),
        currentUserId: "current_user_id"
    )
}
