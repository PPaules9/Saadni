//
//  TinderCardView.swift
//  GoodShift
//

import SwiftUI

struct TinderCardView: View {
    let text: String
    let onAccept: () -> Void
    let onReject: () -> Void

    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    private let swipeThreshold: CGFloat = 100

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Colors.swiftUIColor(.cardBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 8)

            // Quote text
            Text("\(text)")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(32)

            // Accept indicator (swipe right)
            if offset.width > 20 {
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Colors.swiftUIColor(.successGreen).opacity(0.15))
                                .frame(width: 64, height: 64)
                            Image(systemName: "checkmark")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(Colors.swiftUIColor(.successGreen))
                        }
                        .padding(24)
                    }
                    Spacer()
                }
                .opacity(min(1, Double(offset.width) / swipeThreshold))
            }

            // Reject indicator (swipe left)
            if offset.width < -20 {
                VStack {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Colors.swiftUIColor(.borderError).opacity(0.15))
                                .frame(width: 64, height: 64)
                            Image(systemName: "xmark")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(Colors.swiftUIColor(.borderError))
                        }
                        .padding(24)
                        Spacer()
                    }
                    Spacer()
                }
                .opacity(min(1, Double(-offset.width) / swipeThreshold))
            }
        }
        .frame(height: 260)
        .offset(x: offset.width)
        .rotationEffect(.degrees(Double(offset.width) / 25))
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = CGSize(width: value.translation.width, height: 0)
                    isDragging = true
                }
                .onEnded { value in
                    isDragging = false
                    let width = value.translation.width

                    if width > swipeThreshold {
                        withAnimation(.easeOut(duration: 0.25)) {
                            offset = CGSize(width: 600, height: 0)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            onAccept()
                        }
                    } else if width < -swipeThreshold {
                        withAnimation(.easeOut(duration: 0.25)) {
                            offset = CGSize(width: -600, height: 0)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            onReject()
                        }
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            offset = .zero
                        }
                    }
                }
        )
    }
}
