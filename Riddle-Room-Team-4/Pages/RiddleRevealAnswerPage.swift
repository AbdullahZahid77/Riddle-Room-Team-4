import SwiftUI

struct RiddleRevealAnswerPage: View {
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 28)

            VStack(spacing: 12) {
                Image(systemName: "xmark")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(AppColors.red)
                    .frame(width: 62, height: 62)
                    .overlay(Circle().stroke(AppColors.red.opacity(0.55), lineWidth: 2))

                Text("Not quite right.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("That's not the answer.")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Here is the answer:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 4)

                HStack {
                    Text("A piano")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.green)

                    Spacer()

                    Image(systemName: "pianokeys")
                        .font(.system(size: 38, weight: .regular))
                        .foregroundStyle(AppColors.ink)
                }
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))
                .padding(.top, 4)

                HStack(spacing: 14) {
                    Image(systemName: "lightbulb")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(AppColors.red)

                    Text("Tip: Think about things\nthat have keys for notes,\nnot for locks!")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 104)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.red.opacity(0.045)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.red.opacity(0.18), lineWidth: 1.5))
                .padding(.top, 12)

                Button(action: onNext) {
                    Text("Next Riddle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            .padding(.horizontal, 28)

            Spacer(minLength: 28)
        }
    }
}
