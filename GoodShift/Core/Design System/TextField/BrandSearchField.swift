//
//  BrandSearchField.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - Search Input Field

struct BrandSearchField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var onSettings: (() -> Void)? = nil

    private var state: InputState {
        if isFocused { return .active }
        if !text.isEmpty { return .filled }
        return .inactive
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundStyle(Colors.swiftUIColor(.textMain))

            TextField(placeholder, text: $text)
                .focused($isFocused)
                .font(.caption2)
                .fontDesign(.monospaced)
                .fontWeight(state.textWeight)
                .frame(height: 20)
                .padding(.leading, 8)
                .onSubmit {
                    isFocused = false
                }

            Spacer()

            Button {
                onSettings?()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(state.borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        BrandSearchField(placeholder: "Search....", text: .constant(""))
        BrandSearchField(placeholder: "Search....", text: .constant("Deadpool"))
    }
    .padding(16)
}
