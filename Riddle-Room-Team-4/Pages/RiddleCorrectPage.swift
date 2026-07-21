import SwiftUI

struct RiddleCorrectPage: View {
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

            Spacer(minLength: 30)

            VStack(spacing: 18) {
                Image(systemName: "checkmark")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 66, height: 66)
                    .background(Circle().fill(AppColors.green))

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 112, weight: .light))
                    .foregroundStyle(AppColors.orange)

                Text("Great job!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("You got it right.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Answer:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.purple)
                    .padding(.top, 10)

                Text("A piano")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))

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
            .padding(.horizontal, 30)

            Spacer(minLength: 26)
        }
    }
}
