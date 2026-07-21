import SwiftUI

struct NotesPage: View {
    private enum Page {
        case start
        case difficulty
        case riddle
        case hint
        case wrong(attempt: Int)
        case revealAnswer
        case correct
        case complete
    }

    private let totalDailyRiddles = 2

    @State private var page: Page = .start
    @State private var answer = ""
    @State private var wrongAttempts = 0
    @State private var currentRiddleNumber = 1

    var body: some View {
        Group {
            switch page {
            case .start:
                RiddleStartPage(
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles
                ) {
                    page = .difficulty
                }
            case .difficulty:
                DifficultyPage(
                    onBack: { page = .start },
                    onSelectDifficulty: {
                        answer = ""
                        wrongAttempts = 0
                        page = .riddle
                    }
                )
            case .riddle:
                RiddleQuestionPage(
                    answer: $answer,
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles,
                    onBack: { page = .difficulty },
                    onHint: { page = .hint },
                    onSubmit: checkAnswer
                )
            case .hint:
                RiddleHintPage(
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles,
                    onBack: { page = .riddle },
                    onDone: { page = .riddle }
                )
            case .wrong(let attempt):
                RiddleWrongPage(
                    attempt: attempt,
                    answer: answer,
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles,
                    onBack: { page = .riddle },
                    onHint: { page = .hint },
                    onTryAgain: { page = .riddle }
                )
            case .revealAnswer:
                RiddleRevealAnswerPage(
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles,
                    onBack: { page = .riddle },
                    onNext: finishCurrentRiddle
                )
            case .correct:
                RiddleCorrectPage(
                    currentRiddleNumber: currentRiddleNumber,
                    totalRiddles: totalDailyRiddles,
                    onBack: { page = .riddle },
                    onNext: finishCurrentRiddle
                )
            case .complete:
                RiddleCompletePage {
                    answer = ""
                    wrongAttempts = 0
                    currentRiddleNumber = 1
                    page = .start
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
    }

    private func checkAnswer() {
        let cleanedAnswer = normalizedAnswer(answer)
        let correctAnswers = ["piano", "keyboard"]

        if correctAnswers.contains(cleanedAnswer) {
            page = .correct
        } else {
            wrongAttempts += 1
            page = wrongAttempts >= 3 ? .revealAnswer : .wrong(attempt: wrongAttempts)
        }
    }

    private func finishCurrentRiddle() {
        answer = ""
        wrongAttempts = 0

        if currentRiddleNumber < totalDailyRiddles {
            currentRiddleNumber += 1
            page = .start
        } else {
            page = .complete
        }
    }

    private func normalizedAnswer(_ value: String) -> String {
        let lowercaseValue = value.lowercased()
        let lettersAndSpaces = lowercaseValue.map { character in
            character.isLetter || character.isWhitespace ? character : " "
        }
        let words = String(lettersAndSpaces)
            .split(separator: " ")
            .map(String.init)
            .filter { !["a", "an", "the"].contains($0) }

        return words.joined(separator: " ")
    }
}

#Preview {
    NotesPage()
}
