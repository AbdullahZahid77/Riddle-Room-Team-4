import SwiftUI

struct HowToPlayCircleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale

    private let steps: [(icon: String, color: Color, title: String, body: String)] = [
        ("person.3.fill",         AppColors.purple, "Join or Start a Circle",
         "Create a new Brain Circle with your family and friends, or join one using a 6-character invite code."),
        ("envelope.fill",          AppColors.orange, "Share the Code",
         "Send the Circle Code to your family members so they can join. Anyone with the code can enter."),
        ("lightbulb.fill",         AppColors.orange, "Solve Your Individual Riddle",
         "Each person in the family receives a unique riddle clue. Solve it to discover your secret word."),
        ("person.fill.checkmark",  AppColors.green,  "Wait for Everyone",
         "Once all family members have solved their individual riddles, the final challenge unlocks."),
        ("star.fill",              AppColors.orange, "Guess the Final Word",
         "See all the individual words your family collected. Use them as clues to guess the one big answer that connects them all!"),
        ("trophy.fill",            AppColors.green,  "Celebrate Together",
         "If your guess is correct, your family wins! Wrong guess? Don't worry — you can try again.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppColors.ink.opacity(0.35))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 4)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 44, weight: .light))
                            .foregroundStyle(AppColors.purple)

                        Text("How to Play")
                            .font(.system(size: 26 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.ink)

                        Text("Brain Circle is a team puzzle game\nfor families and friends.")
                            .font(.system(size: 14 * fontScale, weight: .semibold))
                            .foregroundStyle(AppColors.ink.opacity(0.60))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                    .padding(.top, 8)

                    // Steps
                    VStack(spacing: 12) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                            stepCard(number: idx + 1, step: step)
                        }
                    }

                    // Example
                    exampleCard

                    Button { dismiss() } label: {
                        Text("Got it!")
                            .font(.system(size: 17 * fontScale, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
    }

    private func stepCard(number: Int, step: (icon: String, color: Color, title: String, body: String)) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(step.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: step.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(step.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Step \(number)")
                        .font(.system(size: 11 * fontScale, weight: .bold))
                        .foregroundStyle(step.color)
                    Text(step.title)
                        .font(.system(size: 14 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                }
                Text(step.body)
                    .font(.system(size: 13 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.60))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.panel))
    }

    private var exampleCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(AppColors.orange)
                Text("Example")
                    .font(.system(size: 14 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
            }

            Text("A family of 3 each solves a riddle:")
                .font(.system(size: 13 * fontScale, weight: .semibold))
                .foregroundStyle(AppColors.ink.opacity(0.70))

            VStack(spacing: 6) {
                exampleRow(name: "Mum",  word: "Snow",     icon: "snowflake")
                exampleRow(name: "Dad",  word: "Scarf",    icon: "scarf")
                exampleRow(name: "Sara", word: "Carrot",   icon: "carrot")
            }

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text("Final Riddle:")
                    .font(.system(size: 12 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink.opacity(0.50))
                Text("\"Built from snow, a carrot nose, and a scarf around its neck — what stands in the garden all winter?\"")
                    .font(.system(size: 13 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(AppColors.green)
                    Text("Answer: Snowman")
                        .font(.system(size: 14 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.green)
                }
                .padding(.top, 2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.orange.opacity(0.18), lineWidth: 1.5))
    }

    private func exampleRow(name: String, word: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(AppColors.orange)
                .frame(width: 20)
            Text(name)
                .font(.system(size: 13 * fontScale, weight: .semibold))
                .foregroundStyle(AppColors.ink.opacity(0.70))
            Spacer()
            Text(word)
                .font(.system(size: 13 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.purple)
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AppColors.green)
                .font(.system(size: 12))
        }
    }
}
