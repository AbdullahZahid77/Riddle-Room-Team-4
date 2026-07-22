import SwiftUI

struct DifficultyPage: View {
    let onBack: () -> Void
    let onSelectDifficulty: (RiddleDifficulty) -> Void
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Choose Difficulty", onBack: onBack)
                .padding(.top, 12)

            Text("Pick a challenge level\nthat's right for you!")
                .font(.system(size: 20 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink)
                .multilineTextAlignment(.center)
                .lineSpacing(7)
                .padding(.top, 26)

            VStack(spacing: 18) {
                DifficultyCard(
                    title: "Beginner",
                    subtitle: "A gentle start\nPerfect for warming up!",
                    symbol: "star.fill",
                    symbolCount: 1,
                    color: AppColors.green,
                    action: { onSelectDifficulty(.easy) }
                )

                DifficultyCard(
                    title: "Intermediate",
                    subtitle: "A good challenge\nKeep your mind sharp.",
                    symbol: "star.fill",
                    symbolCount: 2,
                    color: AppColors.orange,
                    action: { onSelectDifficulty(.medium) }
                )

                DifficultyCard(
                    title: "Advanced",
                    subtitle: "For expert puzzlers\nReady for a real challenge?",
                    symbol: "star.fill",
                    symbolCount: 3,
                    color: AppColors.purple,
                    action: { onSelectDifficulty(.hard) }
                )
            }
            .padding(.top, 26)
            .padding(.horizontal, 24)

            Spacer()

            HStack(spacing: 16) {
                Image(systemName: "info.circle")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppColors.purple)

                Text("You can change this any time.")
                    .font(.system(size: 14 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(minHeight: 48)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.purple.opacity(0.22), lineWidth: 1.5)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 26)
        }
    }
}
