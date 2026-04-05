//
//  ErrorHandler.swift
//  GoodShift
//
//  Created by Claude Code on 14/03/2026.
//

import Foundation

@Observable
final class ErrorHandler {
    var currentError: AppError?
    var isPresented = false
    var retryAction: (() -> Void)?

    /// Handles an error by converting it to AppError and showing to user
    /// - Parameters:
    ///   - error: The error to handle
    ///   - retryAction: Optional closure to retry the failed operation
    func handle(_ error: Error, retryAction: (() -> Void)? = nil) {
        currentError = AppError.from(error)
        self.retryAction = retryAction
        isPresented = true

        // Log error for debugging
        print("❌ [ErrorHandler] \(currentError?.errorDescription ?? "Unknown error")")
    }

    /// Dismisses the error alert
    func dismiss() {
        isPresented = false
        retryAction = nil
        // Keep error for a moment so it can be accessed if needed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentError = nil
        }
    }

    /// Attempts to retry the failed operation
    func retry() {
        retryAction?()
        dismiss()
    }
}
