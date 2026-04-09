//
//  WalletStore.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//

import Foundation
import FirebaseFirestore

@Observable
class WalletStore: ListenerManaging {
    // MARK: - State

    var transactions: [Transaction] = []
    var walletBalance: Double = 0.0

    // MARK: - Error States
    var isLoadingTransactions: Bool = false
    var transactionsError: AppError? = nil

    // MARK: - Listener Management (from ListenerManaging protocol)
    var activeListeners: [String: ListenerRegistration] = [:]
    var listenerSetupState: [String: Bool] = [:]

    private var currentUserId: String?

    private var db: Firestore {
        Firestore.firestore()
    }

    deinit {
        removeAllListeners()
    }

    // MARK: - Listener Management Implementation

    /// Clear all listeners and reset local data
    func removeAllListeners() {
        print("🧹 [WalletStore] Clearing all listeners and resetting state...")
        
        // Remove Firestore listeners
        activeListeners.values.forEach { $0.remove() }
        activeListeners.removeAll()
        listenerSetupState.removeAll()
        
        // Clear local data for next session
        transactions = []
        walletBalance = 0.0
        isLoadingTransactions = false
        transactionsError = nil
        
        print("🧹 [WalletStore] State cleared")
    }

    // MARK: - Setup & Teardown

    /// Guards against concurrent calls to setupListeners (e.g. two rapid logins).
    @ObservationIgnored private var isSettingUp = false

    /// Sets up real-time listener for user transactions (earnings, withdrawals, top-ups)
    /// - Parameter userId: The user ID to listen for transactions
    /// - Throws: Firestore errors during listener setup
    func setupListeners(userId: String) async throws {
        guard !isSettingUp else {
            print("⚠️ [WalletStore] Setup already in progress — skipping duplicate call")
            return
        }
        isSettingUp = true
        defer { isSettingUp = false }

        removeAllListeners()

        currentUserId = userId
        isLoadingTransactions = true
        transactionsError = nil

        let listenerId = "transactions"
        guard !isListenerActive(id: listenerId) else {
            print("⚠️ Listener already active for transactions")
            return
        }

        let listener = db.collection("transactions")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor [weak self] in
                    guard let self else { return }

                    if let error = error {
                        self.transactionsError = AppError.from(error)
                        self.isLoadingTransactions = false
                        print("❌ Error fetching transactions: \(error)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    let decoded = documents.compactMap { doc in
                        do {
                            return try Transaction.fromFirestore(id: doc.documentID, data: doc.data())
                        } catch {
                            print("⚠️ Failed to decode transaction \(doc.documentID): \(error)")
                            return nil
                        }
                    }

                    // Balance is read from User document via balanceListener — not calculated here
                    self.transactions = decoded
                    self.transactionsError = nil
                    self.isLoadingTransactions = false
                    print("✅ Loaded \(self.transactions.count) transactions")
                }
            }

        addListener(id: listenerId, listener: listener)

        // Listen to the authoritative walletBalance on the User document.
        // This is kept accurate by FieldValue.increment in addTransaction().
        let balanceListenerId = "balance"
        let balanceListener = db.collection("users").document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let data = snapshot?.data() else { return }
                let balance = data["walletBalance"] as? Double ?? 0.0
                Task { @MainActor in
                    self.walletBalance = balance
                    print("💰 [WalletStore] Balance updated: EGP \(String(format: "%.2f", balance))")
                }
            }
        
        addListener(id: balanceListenerId, listener: balanceListener)

        print("🔄 [WalletStore] Listeners setup for user: \(userId)")
    }

    // MARK: - Add Transaction

    func addTransaction(_ transaction: Transaction) async throws {
        // Use a batch write so the transaction document and the wallet balance update
        // are committed atomically. If either write fails, neither is applied — preventing
        // the balance and transaction history from going out of sync.
        let batch = db.batch()

        let txRef = db.collection("transactions").document(transaction.id)
        batch.setData(transaction.toFirestore(), forDocument: txRef)

        let userRef = db.collection("users").document(transaction.userId)
        batch.updateData(["walletBalance": FieldValue.increment(transaction.amount)], forDocument: userRef)

        try await batch.commit()
        print("✅ Transaction added atomically: \(transaction.id)")
    }

    // MARK: - Create Earning Transaction

    func createEarningTransaction(
        userId: String,
        amount: Double,
        serviceId: String,
        serviceName: String
    ) async throws {
        // Validate earning before creating transaction
        try ServiceValidator.canCreateEarning(amount: amount, forServiceWithId: serviceId)

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

    // MARK: - Retry Logic

    func retryLoadingTransactions() async {
        guard let userId = currentUserId else { return }
        do {
            try await setupListeners(userId: userId)
            print("✅ Transactions retry succeeded")
        } catch {
            transactionsError = AppError.from(error)
            print("❌ Transactions retry failed: \(error)")
        }
    }
}
