import SwiftUI

enum RiddleStep: Equatable {
    case difficulty
    case start
    case question
    case wrong
    case reveal
    case correct
    case complete
}

struct RiddleFlowView: View {
    var slot: RiddleSlot = .day
    var onDismiss: (() -> Void)? = nil

    @EnvironmentObject var userData: UserData

    @State private var step: RiddleStep = .difficulty
    @State private var currentRiddle = Riddle(
        id: 0, question: "", answer: "", difficulty: "easy", category: "", hints: []
    )
    @State private var answer: String = ""
    @State private var attempts: Int = 0
    @State private var hintsShown: Int = 0
    @State private var riddleSucceeded: Bool = false

    private let maxAttempts = 3
    private let maxHints = 3

    var body: some View {
        Group {
            switch step {
            case .difficulty:
                DifficultyPage(
                    onBack: goHome,
                    onSelectDifficulty: { difficulty in
                        currentRiddle = loadRiddle(difficulty: difficulty)
                        answer = ""
                        attempts = 0
                        hintsShown = 0
                        step = .start
                    }
                )

            case .start:
                RiddleStartPage(
                    currentRiddleNumber: 1,
                    totalRiddles: 1,
                    onBack: goHome,
                    onBegin: { step = .question }
                )

            case .question:
                RiddleQuestionPage(
                    riddle: currentRiddle,
                    answer: $answer,
                    attempts: attempts,
                    shownHints: Array(currentRiddle.hints.prefix(hintsShown)),
                    maxAttempts: maxAttempts,
                    maxHints: maxHints,
                    currentRiddleNumber: 1,
                    totalRiddles: 1,
                    onBack: goHome,
                    onRevealHint: {
                        if hintsShown < maxHints {
                            hintsShown += 1
                            SoundManager.shared.play("Hint")
                        }
                    },
                    onSubmit: evaluateAnswer
                )

            case .wrong:
                RiddleWrongPage(
                    attempt: attempts,
                    maxAttempts: maxAttempts,
                    answer: answer,
                    currentRiddleNumber: 1,
                    totalRiddles: 1,
                    onBack: goHome,
                    onTryAgain: {
                        answer = ""
                        step = .question
                    }
                )

            case .reveal:
                RiddleRevealAnswerPage(
                    riddle: currentRiddle,
                    currentRiddleNumber: 1,
                    totalRiddles: 1,
                    onBack: goHome,
                    onNext: {
                        markProgress()
                        step = .complete
                    }
                )

            case .correct:
                RiddleCorrectPage(
                    riddle: currentRiddle,
                    currentRiddleNumber: 1,
                    totalRiddles: 1,
                    onBack: goHome,
                    onNext: {
                        riddleSucceeded = true
                        markProgress()
                        step = .complete
                    }
                )

            case .complete:
                RiddleCompletePage(slot: slot, didSucceed: riddleSucceeded, onHome: handleComplete)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.25), value: step)
    }

    private func goHome() {
        onDismiss?()
    }

    private func markProgress() {
        switch slot {
        case .day:   userData.markDayRiddle()
        case .night: userData.markNightRiddle()
        }
    }

    private func evaluateAnswer() {
        let submitted = normalizeAnswer(answer)
        let correct = normalizeAnswer(currentRiddle.answer)
        if submitted == correct {
            SoundManager.shared.play("Correct")
            step = .correct
        } else {
            SoundManager.shared.play("Incorrect")
            attempts += 1
            step = attempts >= maxAttempts ? .reveal : .wrong
        }
    }

    private func handleComplete() {
        if let dismiss = onDismiss {
            dismiss()
        } else {
            answer = ""
            attempts = 0
            hintsShown = 0
            riddleSucceeded = false
            step = .difficulty
        }
    }
}
