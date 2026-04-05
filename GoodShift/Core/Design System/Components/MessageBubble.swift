//
//  MessageBubble.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct MessageBubble: View {
	let message: Message
	let isFromCurrentUser: Bool
	let senderName: String?
	
	var body: some View {
		VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 2) {
			
			// Message bubble
			HStack(spacing: 8) {
				if isFromCurrentUser {
					Spacer(minLength: 60)
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text(message.content)
						.font(.body)
						.foregroundStyle(
							isFromCurrentUser
							? Colors.swiftUIColor(.surfaceWhite)
							: Color.black
						)
						.lineLimit(nil)
						.multilineTextAlignment(.leading)
					
					HStack(spacing: 4) {
						Text(message.formattedTime)
							.font(.caption2)
							.foregroundStyle(
								isFromCurrentUser
								? Colors.swiftUIColor(.surfaceWhite).opacity(0.5)
								: Colors.swiftUIColor(.textSecondary)
							)
						
						if isFromCurrentUser && message.isRead {
							Image(systemName: "checkmark.circle.fill")
								.font(.caption2)
								.foregroundStyle(Colors.swiftUIColor(.primary))
						}
					}
				}
				.padding(12)
				.background(
					isFromCurrentUser
					? Colors.swiftUIColor(.primary)
					: Colors.swiftUIColor(.surfaceWhite)
				)
				.cornerRadius(22)
				
				if !isFromCurrentUser {
					Spacer(minLength: 60)
				}
			}
			.padding(.horizontal, 16)
		}
		.frame(maxWidth: .infinity, alignment: isFromCurrentUser ? .trailing : .leading)
	}
}

#Preview {
	VStack(spacing: 16) {
		MessageBubble(
			message: Message(
				id: "1",
				conversationId: "conv_1",
				senderId: "user_1",
				senderName: "You",
				senderPhotoURL: nil,
				content: "Hey! How are you doing?",
				createdAt: Date(),
				isRead: true,
				participantIds: ["user_1", "user_2"]
			),
			isFromCurrentUser: true,
			senderName: nil
		)
		
		MessageBubble(
			message: Message(
				id: "2",
				conversationId: "conv_1",
				senderId: "user_2",
				senderName: "Ali",
				senderPhotoURL: nil,
				content: "I'm doing great! How about you? This is a longer message to show how the bubble wraps text properly.",
				createdAt: Date().addingTimeInterval(-300),
				isRead: false,
				participantIds: ["user_1", "user_2"]
			),
			isFromCurrentUser: false,
			senderName: "Ali"
		)
		
		MessageBubble(
			message: Message(
				id: "3",
				conversationId: "conv_1",
				senderId: "user_1",
				senderName: "You",
				senderPhotoURL: nil,
				content: "All good here too! 😊",
				createdAt: Date().addingTimeInterval(-100),
				isRead: true,
				participantIds: ["user_1", "user_2"]
			),
			isFromCurrentUser: true,
			senderName: nil
		)
	}
	.padding()
	.background(Colors.swiftUIColor(.appBackground))
}
