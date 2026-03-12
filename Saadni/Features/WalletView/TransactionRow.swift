//
//  TransactionRow.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: transaction.icon)
                .font(.system(size: 24))
                .foregroundStyle(transaction.amountColor)
                .frame(width: 40, height: 40)
                .background(transaction.amountColor.opacity(0.1))
                .cornerRadius(8)

            // Description and date
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(transaction.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            // Amount
            Text(transaction.formattedAmount)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(transaction.amountColor)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 12) {
        TransactionRow(transaction: Transaction.sampleData[0])
        TransactionRow(transaction: Transaction.sampleData[1])
        TransactionRow(transaction: Transaction.sampleData[2])
    }
    .padding()
    .background(Color(.systemGray6))
}
