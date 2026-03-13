//
//  BrandNumericalField.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI

// MARK: - Numerical Input Field

struct BrandNumericalField: View {
    let placeholder: String = "-"
    @Binding var number: Int
    @FocusState private var isFocused: Bool
    let width: Int

    private var state: InputState {
        if isFocused { return .active }
        if number != 0 { return .filled }
        return .inactive
    }

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        return formatter
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(state.borderColor, lineWidth: 1)
                )

            TextField(placeholder, value: $number, formatter: numberFormatter)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .fontDesign(.monospaced)
                .font(.system(size: 20))
                .fontWeight(state.textWeight)
        }
        .frame(width: CGFloat(width), height: 52)
    }
}

#Preview {
    HStack(alignment: .center, spacing: 10) {
        BrandNumericalField(number: .constant(0), width: 60)
        BrandNumericalField(number: .constant(19), width: 10)
    }
    .padding(16)
}
