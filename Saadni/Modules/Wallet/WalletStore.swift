//
//  WalletStore.swift
//  Saadni
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

@Observable
class WalletStore {
    // MARK: - State

    var transactions: [Transaction] = []
    var walletBalance: Double = 0.0

    // MARK: - Error States
    var isLoadingTransactions: Bool = false
    var transactionsError: String? = nil
    var retryTransactionsAction: (() async -> Void)? = nil

    private var transactionsListener: ListenerRegistration?

    private var db: Firestore {
        Firestore.firestore()
    }

    deinit {
        stopListening()
    }

    // MARK: - Setup & Teardown

    /// Sets up real-time listener for user transactions (earnings, withdrawals, top-ups)
    /// - Parameter userId: The user ID to listen for transactions
    /// - Throws: Firestore errors during listener setup
    /// - Note: This method sets up async snapshot listener but returns immediately.
    ///         The listener continues running in the background and updates state via SwiftUI @Observable
    func setupListeners(userId: String) async throws {
        stopListening()

        isLoadingTransactions = true
        transactionsError = nil

        transactionsListener = db.collection("transactions")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.transactionsError = "Failed to load wallet. Check your connection."
                    self.isLoadingTransactions = false
                    self.retryTransactionsAction = { [weak self] in
                        try? await self?.setupListeners(userId: userId)
                    }
                    print("❌ Error fetching transactions: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.transactions = documents.compactMap { doc in
                        do {
                            return try Transaction.fromFirestore(id: doc.documentID, data: doc.data())
                        } catch {
                            print("⚠️ Failed to decode transaction \(doc.documentID): \(error)")
                            return nil
                        }
                    }

                    // Calculate balance from all transactions
                    self.walletBalance = self.transactions.reduce(0.0) { $0 + $1.amount }

                    self.transactionsError = nil
                    self.isLoadingTransactions = false
                    print("✅ Loaded \(self.transactions.count) transactions, balance: EGP \(String(format: "%.2f", self.walletBalance))")
                }
            }

        print("🔄 [WalletStore] Listener setup for user: \(userId)")
    }

    func stopListening() {
        transactionsListener?.remove()
        print("🧹 [WalletStore] Listener stopped")
    }

    // MARK: - Add Transaction

    func addTransaction(_ transaction: Transaction) async throws {
        try await FirestoreService.shared.saveTransaction(transaction)

        // Also update User.walletBalance for redundancy
        try await db.collection("users")
            .document(transaction.userId)
            .updateData([
                "walletBalance": FieldValue.increment(transaction.amount)
            ])

        print("✅ Transaction added: \(transaction.id)")
    }

    // MARK: - Create Earning Transaction

    func createEarningTransaction(
        userId: String,
        amount: Double,
        serviceId: String,
        serviceName: String
    ) async throws {
        let transaction = Transaction(
            userId: userId,
            amount: amount,
            type: .earning,
            description: "Payment for: \(serviceName)",
            serviceId: serviceId,
            serviceName: serviceName
        )

        try await addTransaction(transaction)
        print("✅ Earning transaction created: \(amount) EGP for service: \(serviceId)")
    }

    // MARK: - Create Withdrawal Transaction

    func createWithdrawal(userId: String, amount: Double) async throws {
        // Validate sufficient balance
        guard walletBalance >= amount else {
            throw NSError(domain: "WalletStore", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])
        }

        let transaction = Transaction(
            userId: userId,
            amount: -amount,  // Negative for withdrawal
            type: .withdrawal,
            description: "Withdrawal to bank account"
        )

        try await addTransaction(transaction)
        print("✅ Withdrawal created: \(amount) EGP")
    }

    // MARK: - Create Top Up Transaction

    func createTopUp(userId: String, amount: Double) async throws {
        let transaction = Transaction(
            userId: userId,
            amount: amount,
            type: .topUp,
            description: "Top up wallet via payment"
        )

        try await addTransaction(transaction)
        print("✅ Top up created: \(amount) EGP")
    }

    // MARK: - Get Earnings Total

    func getTotalEarnings() -> Double {
        return transactions
            .filter { $0.type == .earning }
            .reduce(0.0) { $0 + $1.amount }
    }

    // MARK: - Get Withdrawals Total

    func getTotalWithdrawals() -> Double {
        return transactions
            .filter { $0.type == .withdrawal }
            .reduce(0.0) { $0 + abs($1.amount) }
    }

    // MARK: - Delete Transaction (for admin/corrections)

    func deleteTransaction(_ transactionId: String) async throws {
        try await FirestoreService.shared.deleteTransaction(id: transactionId)
        print("✅ Transaction deleted: \(transactionId)")
    }
}
