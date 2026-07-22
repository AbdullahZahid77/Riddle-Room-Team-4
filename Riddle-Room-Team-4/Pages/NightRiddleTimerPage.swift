import SwiftUI

struct NightRiddleTimerPage: View {
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let unlockHour: Int
    let onStartNightRiddle: () -> Void
    let onBackHome: () -> Void
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let unlockDate = nextUnlockDate(from: context.date)
            let remainingSeconds = max(0, Int(unlockDate.timeIntervalSince(context.date)))
            let isUnlocked = remainingSeconds == 0

            VStack(spacing: 0) {
                HeaderBar(title: "Night Riddle", onBack: onBackHome)
                    .padding(.top, 12)

                ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
                    .padding(.top, 26)
                    .padding(.horizontal, 56)

                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(AppColors.purple.opacity(0.08))
                            .frame(width: 150, height: 150)

                        Image(systemName: isUnlocked ? "moon.stars.fill" : "clock.fill")
                            .font(.system(size: 76 * fontScale, weight: .light))
                            .foregroundStyle(isUnlocked ? AppColors.purple : AppColors.orange)
                    }

                    VStack(spacing: 12) {
                        Text(isUnlocked ? "Night riddle is ready!" : "Night riddle unlocks at 6 PM")
                            .font(.system(size: 26 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.ink)
                            .multilineTextAlignment(.center)

                        Text(isUnlocked ? "Start your second riddle for today." : "Come back tonight for riddle 2 of 2.")
                            .font(.system(size: 17 * fontScale, weight: .semibold))
                            .foregroundStyle(AppColors.ink)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                    }

                    Text(formattedTime(remainingSeconds))
                        .font(.system(size: 42 * fontScale, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.purple)
                        .monospacedDigit()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 86)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.panel)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.purple.opacity(0.18), lineWidth: 1.5)
                        )
                }
                .padding(.horizontal, 30)

                Spacer()

                Button(action: onStartNightRiddle) {
                    Text(isUnlocked ? "Start Night Riddle" : "Locked until 6 PM")
                        .font(.system(size: 18 * fontScale, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 54)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isUnlocked ? AppColors.purple : AppColors.purple.opacity(0.42))
                        )
                }
                .buttonStyle(.plain)
                .disabled(!isUnlocked)
                .padding(.horizontal, 30)
                .padding(.bottom, 36)
            }
        }
    }

    private func nextUnlockDate(from date: Date) -> Date {
        let calendar = Calendar.current
        let todayUnlock = calendar.date(bySettingHour: unlockHour, minute: 0, second: 0, of: date) ?? date
        return date < todayUnlock ? todayUnlock : date
    }

    private func formattedTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
