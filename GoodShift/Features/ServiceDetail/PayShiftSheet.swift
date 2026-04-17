//
//  PayShiftSheet.swift
//  GoodShift
//

import SwiftUI

struct PayShiftSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ApplicationsStore.self) private var applicationsStore

    let service: JobService
    var onPaid: (() -> Void)? = nil

    @State private var isPaying = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {

                    // Escrow icon + headline
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.12))
                                .frame(width: 88, height: 88)
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.accent)
                        }

                        VStack(spacing: 6) {
                            Text("Secure Your Shift")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))

                            Text("Pay upfront so workers know the shift is real and your funds are guaranteed.")
                                .font(.subheadline)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 8)

                    // Job summary card
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Shift Details", systemImage: "briefcase.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        Text(service.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        HStack {
                            Label(service.location.name, systemImage: "mappin.and.ellipse")
                                .font(.caption)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    .padding(14)
                    .background(Colors.swiftUIColor(.cardBackground))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Colors.swiftUIColor(.borderPrimary), lineWidth: 1))

                    // Amount breakdown
                    VStack(spacing: 0) {
                        PayRow(label: "Shift Payment", amount: service.formattedPrice)
                        Divider().padding(.vertical, 6)
                        PayRow(label: "GoodShift Fee", amount: "Deducted on completion")
                        Divider().padding(.vertical, 6)
                        HStack {
                            Text("Total to Lock Now")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            Spacer()
                            Text(service.formattedPrice)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(16)
                    .background(Colors.swiftUIColor(.cardBackground))
                    .cornerRadius(14)

                    // Safety guarantee box
                    HStack(spacing: 14) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.title2)
                            .foregroundStyle(.green)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Your money is 100% safe")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            Text("Funds are held in GoodShift's escrow and only released to the worker after you confirm the job is done.")
                                .font(.caption)
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(14)
                    .background(Color.green.opacity(0.07))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.green.opacity(0.25), lineWidth: 1))

                    // Error
                    if let error = errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                            Text(error).font(.caption).foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Pay button
                    Button {
                        Task { await pay() }
                    } label: {
                        HStack(spacing: 8) {
                            if isPaying {
                                ProgressView().tint(.white).scaleEffect(0.85)
                            } else {
                                Image(systemName: "lock.fill")
                            }
                            Text(isPaying ? "Securing…" : "Pay \(service.formattedPrice) & Lock")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(isPaying ? Color.accentColor.opacity(0.6) : Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                    }
                    .disabled(isPaying)

                    // TODO: Replace with real payment gateway (Stripe / Paymob / Fawry)
                    Text("Payment gateway integration coming soon. Tapping Pay now simulates a successful payment.")
                        .font(.caption2)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Pay for Shift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isPaying)
                }
            }
        }
    }

    private func pay() async {
        isPaying = true
        errorMessage = nil
        do {
            try await applicationsStore.lockPayment(serviceId: service.id, amount: service.price)
            onPaid?()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isPaying = false
        }
    }
}

// MARK: - Pay Row

private struct PayRow: View {
    let label: String
    let amount: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            Spacer()
            Text(amount)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.textMain))
        }
    }
}

//#Preview {
//    PayShiftSheet(service: .init(
//        title: "Barista Needed",
//        price: 450,
//        location: ServiceLocation(name: "Cairo, Maadi"),
//        description: "",
//        image: ServiceImage(localId: nil, remoteURL: nil),
//        category: .foodAndBeverage,
//        providerId: "p1"
//    ))
//    .environment(ApplicationsStore())
//}
