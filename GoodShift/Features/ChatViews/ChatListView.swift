//
//  ChatListView.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

// MARK: - State Holder (keeps FirestoreService out of the View)
@Observable private final class ConversationNameLoader {
    var name: String = "User"

    func load(otherUserId: String) async {
        if let user = try? await FirestoreService.shared.fetchUser(id: otherUserId) {
            name = user.displayName ?? user.email
        }
    }
}

struct ConversationRow: View {
 let conversation: Conversation
 let currentUserId: String
 @State private var nameLoader = ConversationNameLoader()
 
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
     Text(nameLoader.name)
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
  .task {
   guard let otherUserId = conversation.otherParticipantId(currentUserId: currentUserId) else { return }
   await nameLoader.load(otherUserId: otherUserId)
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
