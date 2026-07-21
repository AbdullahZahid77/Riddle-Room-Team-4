import SwiftUI

struct RiddleHintPage: View {
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 58)

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppColors.orange.opacity(0.12))
                        .frame(width: 122, height: 122)

                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 86, weight: .light))
                        .foregroundStyle(AppColors.orange)
                }

                Text("Here's a hint!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.ink)
            }

            Text("I'm something you might\nfind in a music room.")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(AppColors.ink)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .frame(maxWidth: .infinity)
                .frame(height: 124)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppColors.panel)
                )
                .padding(.top, 28)
                .padding(.horizontal, 30)

            Spacer(minLength: 34)

            Button(action: onDone) {
                Text("Got it, thanks!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.purple)
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
            .padding(.bottom, 56)
        }
    }
}
