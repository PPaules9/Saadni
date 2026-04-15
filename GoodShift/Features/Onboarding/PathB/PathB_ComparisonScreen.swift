//
//  PathB_ComparisonScreen.swift
//  GoodShift
//

import SwiftUI

struct PathB_ComparisonScreen: View {
    let onNext: () -> Void

    private struct ComparisonRow {
        let label: String
        let withApp: String
        let without: String
    }

    private let rows: [ComparisonRow] = [
        ComparisonRow(label: "Fill a shift",       withApp: "Same day",          without: "2–3 days of calls"),
        ComparisonRow(label: "Applicant quality",  withApp: "Rated & verified",  without: "Unknown"),
        ComparisonRow(label: "Payment",            withApp: "In-app, tracked",   without: "Cash, untracked"),
        ComparisonRow(label: "Admin work",         withApp: "One screen",        without: "WhatsApp chaos")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Stat headline
                VStack(spacing: 6) {
                    Text("78%")
                        .font(.system(size: 56, weight: .black))
                        .foregroundStyle(Color.accentColor)

                    Text("of businesses struggle to fill\nshort shifts reliably.*")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)

                    Text("*Industry estimate, MENA gig workforce")
                        .font(.system(size: 11))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                }

                // Comparison table
                VStack(spacing: 0) {
                    // Table header
                    HStack {
                        Text("").frame(maxWidth: .infinity, alignment: .leading)
                        Text("GoodShift")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 110, alignment: .center)
                        Text("Without")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            .frame(width: 110, alignment: .center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Colors.swiftUIColor(.selectionHighlight))

                    Divider()
                        .overlay(Colors.swiftUIColor(.textSecondary).opacity(0.1))

                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        HStack(spacing: 0) {
                            Text(row.label)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(spacing: 4) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(Colors.swiftUIColor(.successGreen))
                                Text(row.withApp)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Colors.swiftUIColor(.successGreen))
                            }
                            .frame(width: 110, alignment: .center)

                            HStack(spacing: 4) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(Colors.swiftUIColor(.borderError))
                                Text(row.without)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Colors.swiftUIColor(.borderError))
                            }
                            .frame(width: 110, alignment: .center)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(index % 2 == 0
                                    ? Colors.swiftUIColor(.cardBackground)
                                    : Colors.swiftUIColor(.appBackground))

                        if index < rows.count - 1 {
                            Divider()
                                .overlay(Colors.swiftUIColor(.textSecondary).opacity(0.08))
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Colors.swiftUIColor(.textSecondary).opacity(0.1), lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)

            Spacer()

            BrandButton("Let's fix that", size: .large, hasIcon: false, icon: "", secondary: false) {
                onNext()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PathB_ComparisonScreen {}
        .background(Colors.swiftUIColor(.appBackground))
}
