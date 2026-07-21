import SwiftUI

struct RiddleCompletePage: View {
    let slot: RiddleSlot
    let didSucceed: Bool
    let onHome: () -> Void
    @Environment(\.appFontScale) var fontScale

    private var nextUpMessage: String {
        switch slot {
        case .day:   return "Come back tonight\nfor the night riddle!"
        case .night: return "Come back tomorrow\nfor a new riddle!"
        }
    }

    private var nextUpIcon: String {
        switch slot {
        case .day:   return "moon.stars.fill"
        case .night: return "sun.max.fill"
        }
    }

    private var nextUpIconColor: Color {
        switch slot {
        case .day:   return .indigo
        case .night: return .orange
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Riddle Complete")
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                HStack {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColors.ink)
                        .frame(width: 44, height: 44)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 48)
            .padding(.top, 12)

            Spacer(minLength: 38)

            Image(systemName: "brain.head.profile")
                .font(.system(size: 132 * fontScale, weight: .light))
                .foregroundStyle(didSucceed ? AppColors.orange : AppColors.ink.opacity(0.35))

            if didSucceed {
                Text("Well done!")
                    .font(.system(size: 30 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 24)

                Text("You've completed today's riddle.")
                    .font(.system(size: 17 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 10)
            } else {
                Text("Nice try!")
                    .font(.system(size: 30 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 24)
            }

            HStack(spacing: 20) {
                Image(systemName: nextUpIcon)
                    .font(.system(size: 42 * fontScale, weight: .light))
                    .foregroundStyle(nextUpIconColor)

                Text(nextUpMessage)
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .lineSpacing(5)

                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(minHeight: 92)
            .padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.42)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.ink.opacity(0.12), lineWidth: 1.5))
            .padding(.horizontal, 28)
            .padding(.top, 28)

            Spacer(minLength: 28)

            Button(action: onHome) {
                Text("Back to Home")
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
            .padding(.bottom, 36)
        }
    }
}
