//
//  CreateJobTab3.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct CreateJobTab3: View {
    @Bindable var viewModel: CreateJobViewModel
    
    let paymentMethods = ["Cash", "In-App Wallet", "Bank Transfer"]
    let paymentTimings = ["Same Day", "Within 24 Hours", "End of Week"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Payment Amount
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Shift Pay Output (Total/Fixed)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("*").foregroundStyle(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("EGP")
                            .font(.headline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        BrandTextField(hasTitle: false, title: "", placeholder: "0.00", text: $viewModel.price)
                    }
                }
                
                // Payment Method
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Method")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ForEach(paymentMethods, id: \.self) { method in
                        Button(action: { viewModel.paymentMethod = method }) {
                            HStack {
                                Image(systemName: viewModel.paymentMethod == method ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(viewModel.paymentMethod == method ? Color.accent : Color.gray)
                                Text(method)
                                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                                Spacer()
                            }
                            .padding()
                            .background(viewModel.paymentMethod == method ? Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                            .cornerRadius(12)
                        }
                    }
                }
                
                // Payment Timing
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Timing")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ForEach(paymentTimings, id: \.self) { timing in
                        Button(action: { viewModel.paymentTiming = timing }) {
                            HStack {
                                Image(systemName: viewModel.paymentTiming == timing ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(viewModel.paymentTiming == timing ? Color.accent : Color.gray)
                                Text(timing)
                                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                                Spacer()
                            }
                            .padding()
                            .background(viewModel.paymentTiming == timing ? Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
                            .cornerRadius(12)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreateJobTab3(viewModel: CreateJobViewModel())
}
