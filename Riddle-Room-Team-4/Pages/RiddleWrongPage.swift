import SwiftUI

struct RiddleWrongPage: View {
    let attempt: Int
    let maxAttempts: Int
    let answer: String
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onTryAgain: () -> Void
    @Environment(\.appFontScale) var fontScale

    private var attemptsRemaining: Int { maxAttempts - attempt }

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "xmark")
                    .font(.system(size: 34 * fontScale, weight: .medium))
                    .foregroundStyle(AppColors.red)
                    .frame(width: 62, height: 62)
                    .overlay(Circle().stroke(AppColors.red.opacity(0.55), lineWidth: 2))

                Text("Not quite right.")
                    .font(.system(size: 24 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.subheadline)
                    Text("\(attemptsRemaining) attempt\(attemptsRemaining == 1 ? "" : "s") remaining")
                        .font(.system(size: 14 * fontScale, weight: .bold))
                }
                .foregroundStyle(attemptsRemaining == 1 ? AppColors.red : AppColors.orange)

                Text(answer.isEmpty ? "Your answer" : answer)
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .frame(minHeight: 58)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.red.opacity(0.25), lineWidth: 1.5))
                    .padding(.top, 6)

                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(.system(size: 18 * fontScale, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 54)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(.horizontal, 28)

            Spacer()
        }
    }
}
