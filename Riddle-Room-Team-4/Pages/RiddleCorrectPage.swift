import SwiftUI

struct RiddleCorrectPage: View {
    let riddle: Riddle
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onNext: () -> Void
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Morning's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer()

            VStack(spacing: 18) {
                Image(systemName: "checkmark")
                    .font(.system(size: 38 * fontScale, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 66, height: 66)
                    .background(Circle().fill(AppColors.green))

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 112 * fontScale, weight: .light))
                    .foregroundStyle(AppColors.orange)

                Text("Great job!")
                    .font(.system(size: 28 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("You got it right.")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("The answer was:")
                    .font(.system(size: 15 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.purple)
                    .padding(.top, 8)

                Text(riddle.answer.capitalized)
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.green)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))

                Button(action: onNext) {
                    Text("Finish")
                        .font(.system(size: 18 * fontScale, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 54)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 14)
            }
            .padding(.horizontal, 30)

            Spacer()
        }
    }
}
