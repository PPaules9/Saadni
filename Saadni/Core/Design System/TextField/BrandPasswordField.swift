//
//  BrandPasswordField.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - Password Input Component

struct BrandPasswordField: View {
    let hasTitle: Bool
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false

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
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
            }

            HStack {
                Group {
                    if !showPassword {
                        SecureField(isFocused ? "" : placeholder, text: $text)
                    } else {
                        TextField(isFocused ? "" : placeholder, text: $text)
                    }
                }
                .focused($isFocused)
                .font(Font.caption)
                .fontDesign(.monospaced)
                .fontWeight(state.textWeight)
                .frame(height: 18)
                .padding(16)
                .onSubmit {
                    isFocused = false
                }

                Spacer()

                Button {
                    showPassword.toggle()
                } label: {
                    if showPassword {
                        Image(systemName: "eye.slash")
                            .resizable()
                            .frame(width: 18, height: 12)
                            .padding(.trailing, 17)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                    } else {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 18, height: 12)
                            .padding(.trailing, 17)
                            .foregroundStyle(Colors.swiftUIColor(.textMain))
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(state.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        BrandPasswordField(hasTitle: true, title: "Basic Password Field", placeholder: "Password", text: .constant(""))
        BrandPasswordField(hasTitle: false, title: "Dummy Password Input", placeholder: "Empty", text: .constant("dummyPassword"))
    }
    .padding(16)
}
