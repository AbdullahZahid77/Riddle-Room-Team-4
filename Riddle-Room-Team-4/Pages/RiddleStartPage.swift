import SwiftUI

struct RiddleStartPage: View {
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onBegin: () -> Void
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                .padding(.top, 26)
                .padding(.horizontal, 56)

            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.orange.opacity(0.08))
                    .frame(width: 176, height: 176)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 104 * fontScale, weight: .light))
                    .foregroundStyle(AppColors.orange)
            }

            VStack(spacing: 18) {
                Text("Let's get started!")
                    .font(.system(size: 28 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Read the riddle carefully and\nthink about the answer.")
                    .font(.system(size: 18 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .multilineTextAlignment(.center)
                    .lineSpacing(7)
            }
            .padding(.top, 18)

            Spacer()

            Button(action: onBegin) {
                Text("Begin Riddle")
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 54)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.purple)
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
            .padding(.bottom, 26)
        }
    }
}
