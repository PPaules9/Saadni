//
//  ChatView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ChatListView()
    }
}

#Preview {
    ChatView()
        .environment(ConversationsStore())
        .environment(AuthenticationManager(userCache: UserCache()))
}
