//
//  BrandTextEditor.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - TextEditor Field

struct BrandTextEditor: View {
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
                    .font(.caption2)
                    .fontDesign(.monospaced)
                    .fontWeight(.regular)
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.caption2)
                        .fontDesign(.monospaced)
                        .fontWeight(.regular)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }

                TextEditor(text: $text)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .font(.caption2)
                    .fontDesign(.monospaced)
                    .fontWeight(state.textWeight)
                    .frame(minHeight: 132, alignment: .top)
            }
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(state.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        BrandTextEditor(hasTitle: true, title: "Basic TextEditor", placeholder: "Type here...", text: .constant(""))
        BrandTextEditor(hasTitle: true, title: "TextEditor With Content", placeholder: "Type here...", text: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."))
    }
    .padding(16)
}
