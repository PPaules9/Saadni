//
//  BrandTextField.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - Basic TextField Component

struct BrandTextField: View {
    let hasTitle: Bool
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    private var state: InputState {
        if isFocused { return .active }
        if !text.isEmpty { return .filled }
        return .inactive
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if hasTitle {
                Text(title)
                    .font(Font.caption)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            TextField(isFocused ? "" : placeholder, text: $text)
                .focused($isFocused)
                .font(Font.caption)
                .fontDesign(.monospaced)
                .fontWeight(state.textWeight)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(state.borderColor, lineWidth: 1)
                )
                .onSubmit {
                    isFocused = false
                }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        BrandTextField(hasTitle: false, title: "Basic TextField", placeholder: "Example", text: .constant(""))
        BrandTextField(hasTitle: true, title: "TextField with content", placeholder: "", text: .constant("Content"))
    }
    .padding(16)
}
