//
//  ChatView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ChatView: View {
	@Environment(ConversationsStore.self) var conversationsStore
	@Environment(AuthenticationManager.self) var authManager
	@State private var searchText = ""
	@State private var selectedConversation: Conversation?
	@State private var showChatDetail = false
	@State private var conversationToDelete: Conversation?
	@State private var showDeleteAlert = false
	
	var filteredConversations: [Conversation] {
		if searchText.isEmpty {
			return conversationsStore.sortedConversations
		}
		return conversationsStore.searchConversations(searchText)
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color(Colors.swiftUIColor(.appBackground))
					.ignoresSafeArea()
				
				VStack(spacing: 0) {
					
					BrandTextField(
						hasTitle: false,
						title: "",
						placeholder: "Search conversations...",
						text: $searchText
					)
					.padding()
					.onSubmit {
					}
					
					
					// Conversations List
					if conversationsStore.isLoading {
						ProgressView()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
					} else if filteredConversations.isEmpty {
						VStack(spacing: 16) {
							Image(systemName: "bubble.left")
								.font(.system(size: 48))
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							
							Text("No conversations yet")
								.font(.headline)
								.foregroundStyle(Colors.swiftUIColor(.textMain))
							
							Text("Start a conversation by clicking the chat icon on a service page")
								.font(.caption)
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								.multilineTextAlignment(.center)
								.padding(.horizontal)
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					} else {
						List {
							ForEach(filteredConversations) { conversation in
								NavigationLink(destination: ChatDetailView(conversation: conversation)) {
									ConversationRow(conversation: conversation, currentUserId: authManager.currentUserId ?? "")
								}
								.listRowBackground(Color.clear)
								.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
								// Swipe right → Delete
								.swipeActions(edge: .trailing, allowsFullSwipe: false) {
									Button(role: .destructive) {
										conversationToDelete = conversation
										showDeleteAlert = true
									} label: {
										Label("Delete", systemImage: "trash")
									}
								}
								// Swipe left → Pin / Unpin
								.swipeActions(edge: .leading, allowsFullSwipe: true) {
									Button {
										Task {
											try? await conversationsStore.pinConversation(
												conversation.id,
												isPinned: !conversation.isPinned
											)
										}
									} label: {
										Label(
											conversation.isPinned ? "Unpin" : "Pin",
											systemImage: conversation.isPinned ? "pin.slash" : "pin"
										)
									}
									.tint(.yellow)
								}
							}
						}
						.listStyle(.plain)
						.scrollContentBackground(.hidden)
					}
				}
			}
			.navigationTitle("Chats")
			.navigationBarTitleDisplayMode(.inline)
			.alert("Delete Conversation", isPresented: $showDeleteAlert, presenting: conversationToDelete) { conversation in
				Button("Delete", role: .destructive) {
					Task {
						try? await conversationsStore.deleteConversation(conversation.id)
					}
				}
				Button("Cancel", role: .cancel) {}
			} message: { _ in
				Text("This will permanently delete the conversation and all its messages. This action cannot be undone.")
			}
		}
	}
}


// MARK: - Conversation Row
#Preview {
    let mockStore = ConversationsStore()
    mockStore.conversations = [
        Conversation(id: "1", participantIds: ["", "other_user_1"], lastMessage: "Hello! Is this service still available?", lastMessageTime: Date().addingTimeInterval(-3600), lastMessageSenderId: "other_user_1"),
        Conversation(id: "2", participantIds: ["", "other_user_2"], lastMessage: "Yes, I can come over tomorrow at 10 AM.", lastMessageTime: Date().addingTimeInterval(-7200), lastMessageSenderId: ""),
        Conversation(id: "3", participantIds: ["", "other_user_3"], lastMessage: "Thanks for the great work!", lastMessageTime: Date().addingTimeInterval(-86400), lastMessageSenderId: "other_user_3"),
        Conversation(id: "4", participantIds: ["", "other_user_4"], lastMessage: "Do you have any references?", lastMessageTime: Date().addingTimeInterval(-172800), lastMessageSenderId: "other_user_4"),
        Conversation(id: "5", participantIds: ["", "other_user_5"], lastMessage: "Let me know when you arrive.", lastMessageTime: Date().addingTimeInterval(-259200), lastMessageSenderId: "")
    ]
    
    return ChatView()
        .environment(mockStore)
        .environment(ConversationsStore())
        .environment(AuthenticationManager(userCache: UserCache()))
}
