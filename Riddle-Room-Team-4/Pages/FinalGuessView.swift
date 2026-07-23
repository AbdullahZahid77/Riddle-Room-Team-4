import SwiftUI

struct FinalGuessView: View {
    let circle: BrainCircle
    @ObservedObject var manager: BrainCircleManager
    let onDismiss: () -> Void

    @Environment(\.appFontScale) var fontScale
    @Environment(\.colorScheme) private var colorScheme

    private var clueTextColor: Color {
        colorScheme == .dark ? AppColors.darkInk : AppColors.purple
    }

    @State private var guess: String = ""
    @State private var submitted = false
    @State private var correct: Bool = false
    @State private var showWrong = false
    @State private var attempts = 0

    private let maxAttempts = 3

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Final Guess")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                HStack {
                    Button { onDismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppColors.ink)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 52)
            .padding(.top, 12)

            if submitted {
                resultView
            } else {
                guessView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
    }

    // MARK: - Guess view

    private var guessView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Context
                VStack(spacing: 4) {
                    Text("All clues collected!")
                        .font(.system(size: 22 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    Text("Your family found their words.\nNow guess what connects them all.")
                        .font(.system(size: 14 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.60))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }

                // Collected words
                VStack(spacing: 0) {
                    HStack {
                        Text("Clue Words")
                            .font(.system(size: 12 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.ink.opacity(0.45))
                        Spacer()
                    }
                    .padding(.bottom, 10)

                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(circle.members) { member in
                            clueWordTile(member: member)
                        }
                    }
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))

                // Final riddle question
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "questionmark.bubble.fill")
                            .foregroundStyle(AppColors.purple)
                        Text("Family Riddle")
                            .font(.system(size: 13 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.purple)
                    }
                    Text(circle.riddleSet.groupRiddle.question)
                        .font(.system(size: 17 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .lineSpacing(7)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.purple.opacity(0.14), lineWidth: 1.5))

                // Attempts warning
                if attempts > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.caption.weight(.semibold))
                        Text("\(maxAttempts - attempts) attempt\(maxAttempts - attempts == 1 ? "" : "s") remaining")
                            .font(.system(size: 14 * fontScale, weight: .bold))
                    }
                    .foregroundStyle(maxAttempts - attempts == 1 ? AppColors.red : AppColors.orange)
                }

                // Wrong answer banner
                if showWrong {
                    HStack(spacing: 10) {
                        Image("confused")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                        Text("Not quite — think about how all the words connect!")
                            .font(.system(size: 13 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.red.opacity(0.07)))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.red.opacity(0.18), lineWidth: 1))
                }

                // Answer input or exhausted
                if attempts >= maxAttempts {
                    exhaustedView
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your guess")
                            .font(.system(size: 13 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.ink.opacity(0.55))

                        TextField("Type the final answer...", text: $guess)
                            .font(.system(size: 16 * fontScale, weight: .semibold))
                            .foregroundStyle(AppColors.ink)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.done)
                            .onSubmit { submitGuess() }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(AppColors.panel)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.20), lineWidth: 1.5))
                    }

                    Button { submitGuess() } label: {
                        Text("Submit Final Guess")
                            .font(.system(size: 17 * fontScale, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(RoundedRectangle(cornerRadius: 12).fill(
                                guess.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? AppColors.orange.opacity(0.35)
                                    : AppColors.orange
                            ))
                    }
                    .buttonStyle(.plain)
                    .disabled(guess.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
    }

    private func clueWordTile(member: CircleMember) -> some View {
        VStack(spacing: 4) {
            Text(member.submittedAnswer.isEmpty ? "?" : member.submittedAnswer.capitalized)
                .font(.system(size: 18 * fontScale, weight: .heavy, design: .rounded))
                .foregroundStyle(member.submittedAnswer.isEmpty ? AppColors.ink.opacity(0.30) : clueTextColor)
            Text(member.name.components(separatedBy: " ").first ?? member.name)
                .font(.system(size: 11 * fontScale, weight: .semibold))
                .foregroundStyle(AppColors.ink.opacity(0.45))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.purple.opacity(0.07)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.purple.opacity(0.14), lineWidth: 1))
    }

    private var exhaustedView: some View {
        VStack(spacing: 12) {
            Text("All attempts used.")
                .font(.system(size: 15 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink)
            VStack(alignment: .leading, spacing: 6) {
                Text("The answer was:")
                    .font(.system(size: 13 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.55))
                Text(circle.riddleSet.groupRiddle.answer.capitalized)
                    .font(.system(size: 24 * fontScale, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppColors.green)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.green.opacity(0.08)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.green.opacity(0.18), lineWidth: 1))

            Button {
                manager.submitFinalGuess(circleId: circle.id, guess: "")
                correct = false
                submitted = true
            } label: {
                Text("See Results")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
    }

    // MARK: - Result view

    private var resultView: some View {
        VStack(spacing: 28) {
            Spacer()

            if correct {
                Image("trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)

                VStack(spacing: 10) {
                    Text("Your family got it!")
                        .font(.system(size: 30 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    Text("You all worked together and solved the\nBrain Circle challenge!")
                        .font(.system(size: 16 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }

                VStack(spacing: 4) {
                    Text("The answer was:")
                        .font(.system(size: 13 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.50))
                    Text(circle.riddleSet.groupRiddle.answer.capitalized)
                        .font(.system(size: 34 * fontScale, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppColors.purple)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
            } else {
                Image("confused")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)

                VStack(spacing: 10) {
                    Text("Not quite this time!")
                        .font(.system(size: 26 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    Text("Your family gave it a great go.\nBetter luck next challenge!")
                        .font(.system(size: 15 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.60))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }

                VStack(spacing: 4) {
                    Text("The answer was:")
                        .font(.system(size: 13 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.50))
                    Text(circle.riddleSet.groupRiddle.answer.capitalized)
                        .font(.system(size: 28 * fontScale, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppColors.green)
                }
                .padding(18)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
            }

            Button { onDismiss() } label: {
                Text("Back to Family")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 28)
    }

    // MARK: - Logic

    private func submitGuess() {
        let trimmed = guess.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let isCorrect = manager.submitFinalGuess(circleId: circle.id, guess: trimmed)
        if isCorrect {
            SoundManager.shared.play("Correct")
            correct = true
            submitted = true
        } else {
            SoundManager.shared.play("Incorrect")
            attempts += 1
            showWrong = true
            guess = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showWrong = false
            }
        }
    }
}
