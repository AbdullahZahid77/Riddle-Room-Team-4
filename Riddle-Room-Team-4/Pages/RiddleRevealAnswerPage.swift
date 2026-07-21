import SwiftUI

struct RiddleRevealAnswerPage: View {
    let riddle: Riddle
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onNext: () -> Void
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer()

            VStack(spacing: 14) {
                Image("confused")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)

                Text("Not quite right.")
                    .font(.system(size: 24 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("You've used all your attempts.")
                    .font(.system(size: 16 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.7))

                Text("Here is the answer:")
                    .font(.system(size: 15 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 6)

                Text(riddle.answer.capitalized)
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .frame(minHeight: 56)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))

                HStack(spacing: 14) {
                    Image(systemName: "lightbulb")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColors.orange)

                    Text("Keep practicing —\nyou'll get it next time!")
                        .font(.system(size: 15 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.orange.opacity(0.07)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.orange.opacity(0.18), lineWidth: 1.5))
                .padding(.top, 6)

                Button(action: onNext) {
                    Text("See Results")
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
            .padding(.horizontal, 28)

            Spacer()
        }
    }
}
