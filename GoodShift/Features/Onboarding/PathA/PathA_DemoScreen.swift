//
//  PathA_DemoScreen.swift
//  GoodShift
//
//  The "aha moment" — user browses real sample shifts and saves 2.
//  Then sees their personalised shift list with total potential earnings.
//

import SwiftUI

struct PathA_DemoScreen: View {
    @Binding var state: OnboardingState
    let onNext: () -> Void

    @State private var showingResult = false

    private let demoShifts = Array(JobService.sampleData.prefix(3))
    private let required = 2

    private var savedCount: Int { state.pathA_savedShiftIds.count }
    private var canAdvance: Bool { savedCount >= required }

    var body: some View {
        if showingResult {
            ShiftListResultView(state: state, onNext: onNext)
        } else {
            shiftPickerView
        }
    }

    // MARK: - Shift Picker

    private var shiftPickerView: some View {
        VStack(spacing: 0) {
            OnboardingScreenHeader(
                headline: "Here are shifts\nready for you.",
                subheadline: progressLabel
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(demoShifts) { shift in
                        DemoShiftCard(
                            shift: shift,
                            isSaved: state.pathA_savedShiftIds.contains(shift.id)
                        ) {
                            toggleShift(shift.id)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            Spacer()

            BrandButton(
                canAdvance ? "See my list →" : "Pick \(required - savedCount) more",
                size: .large,
                isDisabled: !canAdvance,
                hasIcon: false,
                icon: "",
                secondary: false
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingResult = true
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .animation(.easeInOut(duration: 0.2), value: canAdvance)
        }
    }

    private var progressLabel: String {
        if savedCount == 0 {
            return "Tap a shift to save it — pick the ones that interest you."
        } else if savedCount < required {
            return "Save \(required - savedCount) more shift\(required - savedCount == 1 ? "" : "s") to continue."
        } else {
            return "You're all set! Tap to see your list."
        }
    }

    private func toggleShift(_ id: String) {
        if state.pathA_savedShiftIds.contains(id) {
            state.pathA_savedShiftIds.remove(id)
        } else {
            state.pathA_savedShiftIds.insert(id)
        }
    }
}

// MARK: - Demo Shift Card

private struct DemoShiftCard: View {
    let shift: JobService
    let isSaved: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Category icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSaved ? Color.accentColor : Color.accentColor.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: shift.category?.icon ?? "briefcase.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(isSaved ? .white : Color.accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(shift.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Colors.swiftUIColor(.textMain))
                        .lineLimit(1)

                    Text(shift.location.name)
                        .font(.system(size: 13))
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                    HStack(spacing: 8) {
                        Text("\(shift.price) EGP")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.accentColor)

                        Text("·")
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))

                        if let hours = shift.estimatedDurationHours {
                            Text("\(Int(hours))h")
                                .font(.system(size: 13))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        }
                    }
                }

                Spacer()

                // Save toggle
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 20))
                    .foregroundStyle(isSaved ? Color.accentColor : Colors.swiftUIColor(.textSecondary).opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Colors.swiftUIColor(.cardBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        isSaved ? Color.accentColor : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSaved)
    }
}

// MARK: - Shift List Result View

private struct ShiftListResultView: View {
    let state: OnboardingState
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Celebration icon
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Colors.swiftUIColor(.successGreen))

                Text("Your shift list is ready!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.textMain))
                    .multilineTextAlignment(.center)

                Text("Here's what you saved:")
                    .font(.system(size: 16))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 32)

            // Saved shifts list
            VStack(spacing: 10) {
                ForEach(state.pathA_savedShifts) { shift in
                    HStack(spacing: 12) {
                        Image(systemName: shift.category?.icon ?? "briefcase.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle().fill(Color.accentColor.opacity(0.12))
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(shift.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                            Text(shift.location.name)
                                .font(.system(size: 12))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        }

                        Spacer()

                        Text("\(shift.price) EGP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.accentColor)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.swiftUIColor(.cardBackground))
                    )
                }
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 20)

            // Total earnings
            HStack {
                Text("Total potential earnings")
                    .font(.system(size: 15))
                    .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                Spacer()
                Text("\(state.pathA_totalEarnings) EGP")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Colors.swiftUIColor(.successGreen))
            }
            .padding(.horizontal, 32)

            Spacer()

            // Share + save
            VStack(spacing: 12) {
                ShareLink(item: shareText) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share with a friend")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.accentColor)
                }

                BrandButton("Save my list", size: .large, hasIcon: false, icon: "", secondary: false) {
                    AnalyticsService.shared.track(.onboardingDemoCompleted(
                        shiftsSaved: state.pathA_savedShifts.count,
                        role: "job_seeker"
                    ))
                    onNext()
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
    }

    private var shareText: String {
        let titles = state.pathA_savedShifts.map { "• \($0.title) — \($0.price) EGP" }.joined(separator: "\n")
        return "I found these shifts on GoodShift:\n\(titles)\nTotal: \(state.pathA_totalEarnings) EGP"
    }
}
