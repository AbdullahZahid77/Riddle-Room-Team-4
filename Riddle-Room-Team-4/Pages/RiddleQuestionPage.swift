import SwiftUI

struct RiddleQuestionPage: View {
    let riddle: Riddle
    @Binding var answer: String
    let attempts: Int
    let shownHints: [String]
    let maxAttempts: Int
    let maxHints: Int
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onRevealHint: () -> Void
    let onSubmit: () -> Void

    private var attemptsRemaining: Int { maxAttempts - attempts }
    private var canGetHint: Bool { shownHints.count < maxHints }
    private var canSubmit: Bool {
        !answer.trimmingCharacters(in: .whitespaces).isEmpty && attempts < maxAttempts
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    // Category badge
                    Text(riddle.category)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppColors.purple)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(AppColors.purple.opacity(0.10)))
                        .overlay(Capsule().stroke(AppColors.purple.opacity(0.20), lineWidth: 1))
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(riddle.question)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.bottom, 4)

                    // Attempts warning
                    if attempts > 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.caption.weight(.semibold))
                            Text("\(attemptsRemaining) attempt\(attemptsRemaining == 1 ? "" : "s") remaining")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundStyle(attemptsRemaining == 1 ? AppColors.red : AppColors.orange)
                    }

                    // Answer field
                    TextField("Type your answer...", text: $answer)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.ink)
                        .submitLabel(.done)
                        .onSubmit { if canSubmit { onSubmit() } }
                        .padding(.horizontal, 18)
                        .frame(height: 58)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.18), lineWidth: 1.5))

                    // Inline hints revealed so far
                    if !shownHints.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(shownHints.enumerated()), id: \.offset) { index, hint in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(AppColors.orange)
                                        .padding(.top, 2)

                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Hint \(index + 1)")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(AppColors.orange)
                                        Text(hint)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(AppColors.ink)
                                            .lineSpacing(4)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.orange.opacity(0.07)))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.orange.opacity(0.18), lineWidth: 1))
                            }
                        }
                    }

                    // Hint button
                    Button(action: onRevealHint) {
                        HStack(spacing: 12) {
                            Image(systemName: "lightbulb")
                                .font(.title3.weight(.semibold))
                            Text(canGetHint
                                 ? "Get a hint (\(maxHints - shownHints.count) left)"
                                 : "No more hints")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundStyle(canGetHint ? AppColors.purple : AppColors.ink.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    canGetHint ? AppColors.purple.opacity(0.18) : AppColors.ink.opacity(0.10),
                                    lineWidth: 1.5
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!canGetHint)

                    // Submit button
                    Button {
                        onSubmit()
                    } label: {
                        Text("Submit Answer")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(canSubmit ? AppColors.purple : AppColors.purple.opacity(0.35))
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSubmit)
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
    }
}
