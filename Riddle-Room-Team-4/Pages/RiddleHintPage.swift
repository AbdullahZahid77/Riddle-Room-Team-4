import SwiftUI

struct RiddleHintPage: View {
    let hint: String
    let hintNumber: Int
    let totalHints: Int
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Morning's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 40)

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.orange.opacity(0.12))
                        .frame(width: 122, height: 122)

                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 72, weight: .light))
                        .foregroundStyle(AppColors.orange)
                }

                VStack(spacing: 4) {
                    Text("Hint \(hintNumber) of \(totalHints)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppColors.orange.opacity(0.8))

                    Text("Here's a hint!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                }
            }

            Text(hint)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColors.ink)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
                .padding(.top, 28)
                .padding(.horizontal, 30)

            Spacer(minLength: 34)

            Button(action: onDone) {
                Text("Got it, thanks!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
            .padding(.bottom, 56)
        }
    }
}
