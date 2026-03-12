//
//  WalletSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import SwiftUI

// MARK: - Wallet Sheet
struct WalletSheet: View {
 @Environment(WalletStore.self) var walletStore

 @State private var selectedTab: String = "All"
 let tabs = ["All", "Earning", "Withdrawal", "Top Up"]

 var filteredTransactions: [Transaction] {
  if selectedTab == "All" {
   return walletStore.transactions
  }
  let typeMap: [String: TransactionType] = [
   "Earning": .earning,
   "Withdrawal": .withdrawal,
   "Top Up": .topUp
  ]
  guard let type = typeMap[selectedTab] else { return walletStore.transactions }
  return walletStore.transactions.filter { $0.type == type }
 }

 var body: some View {
  VStack(spacing: 0) {
   // Header Section
   VStack(spacing: 16) {
    // Tabs
    HStack(spacing: 12) {
    
     Spacer()

     Button(action: {}) {
      Image(systemName: "questionmark.circle")
       .font(.system(size: 24))
       .foregroundStyle(.white)
     }
    }
    .padding(.horizontal, 20)

    // Balance
    VStack(spacing: 8) {
     Text("EGP \(String(format: "%.2f", walletStore.walletBalance))")
      .font(.system(size: 48, weight: .bold))
      .foregroundStyle(.white)
      .fontDesign(.monospaced)
      .kerning(-1)

   
    }

    // Action Buttons
    HStack(spacing: 12) {
     Button(action: {}) {
      HStack(spacing: 8) {
       Image(systemName: "plus")
        .font(.system(size: 16, weight: .semibold))
       Text("Top up")
        .font(.subheadline)
        .fontWeight(.semibold)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 12)
      .foregroundStyle(.yellow)
      .overlay(
       RoundedRectangle(cornerRadius: 12)
        .stroke(Color.yellow, lineWidth: 1.5)
      )
     }

     Button(action: {}) {
      HStack(spacing: 8) {
       Image(systemName: "arrow.up")
        .font(.system(size: 16, weight: .semibold))
       Text("Withdraw")
        .font(.subheadline)
        .fontWeight(.semibold)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 12)
      .foregroundStyle(.white)
      .overlay(
       RoundedRectangle(cornerRadius: 12)
        .stroke(Color.white, lineWidth: 1.5)
      )
     }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 20)
   }
   .background(
    LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
   )

   // Recent Activities Section
   VStack(alignment: .leading, spacing: 16) {
    HStack {
     Text("Recent Activities")
      .font(.system(size: 20, weight: .bold))
      .foregroundStyle(.black)
      .fontDesign(.monospaced)
      .kerning(-0.5)

     Spacer()

     Button(action: {}) {
      Text("View Requests")
       .font(.caption)
       .foregroundStyle(.gray)
       .fontDesign(.monospaced)
       .kerning(-0.5)
     }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)

    // Filter Tabs
    ScrollView(.horizontal, showsIndicators: false) {
     HStack(spacing: 8) {
      ForEach(tabs, id: \.self) { tab in
       Button(action: { selectedTab = tab }) {
        Text(tab)
         .font(.subheadline)
         .fontWeight(.semibold)
         .foregroundStyle(selectedTab == tab ? .white : .gray)
         .fontDesign(.monospaced)
         .kerning(-0.5)
         .padding(.horizontal, 16)
         .padding(.vertical, 8)
         .background(selectedTab == tab ? Color.black : Color.clear)
         .cornerRadius(20)
       }
      }
     }
     .padding(.horizontal, 20)
    }

    // Transactions List
    VStack(spacing: 12) {
     if walletStore.transactions.isEmpty {
      VStack(spacing: 8) {
       Image(systemName: "list.dash")
        .font(.system(size: 32))
        .foregroundStyle(.gray)
       Text("No transactions yet")
        .font(.subheadline)
        .foregroundStyle(.gray)
      }
      .frame(maxWidth: .infinity)
      .padding(20)
     } else {
      ForEach(filteredTransactions) { transaction in
       TransactionRow(
        title: transaction.description,
        date: transaction.formattedDate,
        amount: transaction.formattedAmount,
        isNegative: transaction.amount < 0
       )
      }
     }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 20)
   }
   .background(Color.white)

   Spacer()
  }
  .background(Color.white)
 }
}

// MARK: - Transaction Row
struct TransactionRow: View {
 let title: String
 let date: String
 let amount: String
 let isNegative: Bool
 var hasArrow: Bool = false

 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack {
    VStack(alignment: .leading, spacing: 4) {
     if hasArrow {
      HStack(spacing: 4) {
       Image(systemName: "arrow.right")
        .font(.system(size: 14))
       Text(title)
        .font(.subheadline)
        .fontWeight(.semibold)
       }
      .foregroundStyle(.black)
     } else {
      HStack(spacing: 8) {
       RoundedRectangle(cornerRadius: 2)
        .fill(Color.gray)
        .frame(width: 4, height: 16)
       Text(title)
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.black)
      }
     }

     Text(date)
      .font(.caption)
      .foregroundStyle(.gray)
      .fontDesign(.monospaced)
      .kerning(-0.3)
    }

    Spacer()

    Text(amount)
     .font(.subheadline)
     .fontWeight(.semibold)
     .foregroundStyle(isNegative ? .red : .green)
     .fontDesign(.monospaced)
     .kerning(-0.5)
   }

   Divider()
  }
 }
}


#Preview {
 WalletSheet()
  .environment(WalletStore())
}
