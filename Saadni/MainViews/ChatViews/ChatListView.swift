//
//  ChatListView.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct ChatListView: View {
    @Environment(ConversationsStore.self) var conversationsStore
    @Environment(AuthenticationManager.self) var authManager
    @State private var searchText = ""
    @State private var selectedConversation: Conversation?
    @State private var showChatDetail = false

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
                    // Search Bar
                    SearchBar(text: $searchText, placeholder: "Search conversations...")
                        .padding()

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
                                    ConversationRow(conversation: conversation)
                                }
                                .listRowBackground(Color(UIColor(hex: "#FEFEFE")))
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

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
        .background(Color(UIColor(hex: "#FEFEFE")))
        .cornerRadius(12)
    }
}

// MARK: - Conversation Row

struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Avatar placeholder
                Circle()
                    .fill(Color(UIColor(hex: "#37857D")))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color(UIColor(hex: "#FEFEFE")))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    // User name would go here
                    Text("User")
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
                            .fill(Color(UIColor(hex: "#37857D")))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(12)
    }
}

#Preview {
    ChatListView()
        .environment(ConversationsStore())
        .environment(AuthenticationManager(userCache: UserCache()))
}
