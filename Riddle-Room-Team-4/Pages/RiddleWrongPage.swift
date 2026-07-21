import SwiftUI

struct RiddleWrongPage: View {
    let attempt: Int
    let answer: String
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onHint: () -> Void
    let onTryAgain: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 28)

            VStack(spacing: 14) {
                Image(systemName: "xmark")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(AppColors.red)
                    .frame(width: 62, height: 62)
                    .overlay(Circle().stroke(AppColors.red.opacity(0.55), lineWidth: 2))

                Text("Not quite right.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Try again!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.bottom, 18)

                Text(answer.isEmpty ? "Your answer" : answer)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .frame(height: 58)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.18), lineWidth: 1.5))

                Button(action: onHint) {
                    HStack(spacing: 12) {
                        Image(systemName: "lightbulb")
                            .font(.title3.weight(.semibold))
                        Text("Get a hint")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundStyle(AppColors.purple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.16), lineWidth: 1.5))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)

                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 28)
            }
            .padding(.horizontal, 28)

            Spacer(minLength: 48)
        }
    }
}
