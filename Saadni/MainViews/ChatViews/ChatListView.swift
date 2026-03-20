//
//  ChatListView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI


// MARK: - Search Bar

struct SearchBar: View {
 @Binding var text: String
 var placeholder: String = "Search"
 
 var body: some View {
  HStack(spacing: 12) {
   Image(systemName: "magnifyingglass")
    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
   
   TextField(placeholder, text: $text)
    .textFieldStyle(.plain)
    .font(.body)
    .foregroundStyle(Colors.swiftUIColor(.textMain))
   
   if !text.isEmpty {
    Button(action: { text = "" }) {
     Image(systemName: "xmark.circle.fill")
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
    }
   }
  }
  .padding(12)
  .background(Colors.swiftUIColor(.surfaceWhite))
  .cornerRadius(12)
 }
}

// MARK: - Conversation Row

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
     Text(conversation.formattedLastMessageTime)
      .font(.caption)
      .foregroundStyle(Colors.swiftUIColor(.textSecondary))
     
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
