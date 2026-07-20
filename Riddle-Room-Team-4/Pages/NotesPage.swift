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

    @State private var page: Page = .start
    @State private var answer = ""
    @State private var wrongAttempts = 0

    var body: some View {
        Group {
            switch page {
            case .start:
                RiddleStartPage {
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
                    onBack: { page = .difficulty },
                    onHint: { page = .hint },
                    onSubmit: checkAnswer
                )
            case .hint:
                RiddleHintPage(
                    onBack: { page = .riddle },
                    onDone: { page = .riddle }
                )
            case .wrong(let attempt):
                RiddleWrongPage(
                    attempt: attempt,
                    answer: answer,
                    onBack: { page = .riddle },
                    onHint: { page = .hint },
                    onTryAgain: { page = .riddle }
                )
            case .revealAnswer:
                RiddleRevealAnswerPage(
                    onBack: { page = .riddle },
                    onNext: { page = .complete }
                )
            case .correct:
                RiddleCorrectPage(
                    onBack: { page = .riddle },
                    onNext: { page = .complete }
                )
            case .complete:
                RiddleCompletePage {
                    answer = ""
                    wrongAttempts = 0
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

private struct RiddleStartPage: View {
    let onBegin: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle")
                .padding(.top, 12)

            HStack(spacing: 10) {
                Text("1 of 1")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(AppColors.purple))

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColors.purple.opacity(0.28))
                            .frame(height: 3)

                        Capsule()
                            .fill(AppColors.purple)
                            .frame(width: geometry.size.width * 0.35, height: 3)
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(height: 26)
            }
            .padding(.top, 26)
            .padding(.horizontal, 56)

            Spacer(minLength: 28)

            ZStack {
                Circle()
                    .fill(AppColors.orange.opacity(0.08))
                    .frame(width: 176, height: 176)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 104, weight: .light))
                    .foregroundStyle(AppColors.orange)
            }
            .frame(height: 205)

            VStack(spacing: 18) {
                Text("Let's get started!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Read the riddle carefully and\nthink about the answer.")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .multilineTextAlignment(.center)
                    .lineSpacing(7)
            }
            .padding(.top, 18)

            Spacer(minLength: 42)

            Button(action: onBegin) {
                Text("Begin Riddle")
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
            .padding(.bottom, 26)
        }
    }
}

private struct DifficultyPage: View {
    let onBack: () -> Void
    let onSelectDifficulty: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Choose Difficulty", onBack: onBack)
                .padding(.top, 12)

            Text("Pick a challenge level\nthat's right for you!")
                .font(.system(size: 20, weight: .bold))
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
                    action: onSelectDifficulty
                )

                DifficultyCard(
                    title: "Intermediate",
                    subtitle: "A good challenge\nKeep your mind sharp.",
                    symbol: "star.fill",
                    symbolCount: 2,
                    color: AppColors.orange,
                    action: onSelectDifficulty
                )

                DifficultyCard(
                    title: "Advanced",
                    subtitle: "For expert puzzlers\nReady for a real challenge?",
                    symbol: "star.fill",
                    symbolCount: 3,
                    color: AppColors.purple,
                    action: onSelectDifficulty
                )
            }
            .padding(.top, 26)
            .padding(.horizontal, 24)

            Spacer(minLength: 24)

            HStack(spacing: 16) {
                Image(systemName: "info.circle")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppColors.purple)

                Text("You can change this later.")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.purple.opacity(0.22), lineWidth: 1.5)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 26)
        }
    }
}

private struct RiddleQuestionPage: View {
    @Binding var answer: String
    let onBack: () -> Void
    let onHint: () -> Void
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill()
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 42)

            VStack(spacing: 16) {
                Text("What has keys\nbut can't open\nlocks?")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.top, 46)

                TextField("Type your answer...", text: $answer)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .submitLabel(.done)
                    .onSubmit(onSubmit)
                    .padding(.horizontal, 18)
                    .frame(height: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.purple.opacity(0.18), lineWidth: 1.5)
                    )

                Button(action: onHint) {
                    HStack(spacing: 12) {
                        Image(systemName: "lightbulb")
                            .font(.title3.weight(.semibold))
                        Text("Get a hint")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundStyle(AppColors.purple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.purple.opacity(0.16), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)

                Button {
                    onSubmit()
                } label: {
                    Text("Submit Answer")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.purple)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.panel)
            )
            .padding(.horizontal, 28)

            Spacer(minLength: 54)
        }
    }
}

private struct RiddleWrongPage: View {
    let attempt: Int
    let answer: String
    let onBack: () -> Void
    let onHint: () -> Void
    let onTryAgain: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill()
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 28)

            VStack(spacing: 14) {
                Image(systemName: "xmark")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(AppColors.red)
                    .frame(width: 62, height: 62)
                    .overlay(Circle().stroke(AppColors.red.opacity(0.55), lineWidth: 2))

                Text("Not quite right.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Try again!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.bottom, 18)

                Text(answer.isEmpty ? "Your answer" : answer)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .frame(height: 58)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.18), lineWidth: 1.5))

                Button(action: onHint) {
                    HStack(spacing: 12) {
                        Image(systemName: "lightbulb")
                            .font(.title3.weight(.semibold))
                        Text("Get a hint")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundStyle(AppColors.purple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.16), lineWidth: 1.5))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)

                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 28)
            }
            .padding(.horizontal, 28)

            Spacer(minLength: 48)
        }
    }
}

private struct RiddleRevealAnswerPage: View {
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill()
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 28)

            VStack(spacing: 12) {
                Image(systemName: "xmark")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(AppColors.red)
                    .frame(width: 62, height: 62)
                    .overlay(Circle().stroke(AppColors.red.opacity(0.55), lineWidth: 2))

                Text("Not quite right.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("That's not the answer.")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Here is the answer:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 4)

                HStack {
                    Text("A piano")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.green)

                    Spacer()

                    Image(systemName: "pianokeys")
                        .font(.system(size: 38, weight: .regular))
                        .foregroundStyle(AppColors.ink)
                }
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))
                .padding(.top, 4)

                HStack(spacing: 14) {
                    Image(systemName: "lightbulb")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(AppColors.red)

                    Text("Tip: Think about things\nthat have keys for notes,\nnot for locks!")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 104)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.red.opacity(0.045)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.red.opacity(0.18), lineWidth: 1.5))
                .padding(.top, 12)

                Button(action: onNext) {
                    Text("Next Riddle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            .padding(.horizontal, 28)

            Spacer(minLength: 28)
        }
    }
}

private struct RiddleCorrectPage: View {
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill()
                .padding(.top, 26)
                .padding(.horizontal, 82)

            Spacer(minLength: 30)

            VStack(spacing: 18) {
                Image(systemName: "checkmark")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 66, height: 66)
                    .background(Circle().fill(AppColors.green))

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 112, weight: .light))
                    .foregroundStyle(AppColors.orange)

                Text("Great job!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("You got it right.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                Text("Answer:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.purple)
                    .padding(.top, 10)

                Text("A piano")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.green.opacity(0.08)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.green.opacity(0.18), lineWidth: 1.5))

                Button(action: onNext) {
                    Text("Next Riddle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            .padding(.horizontal, 30)

            Spacer(minLength: 26)
        }
    }
}

private struct RiddleCompletePage: View {
    let onHome: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Riddle Complete")
                    .font(.system(size: 18, weight: .bold))
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
                .font(.system(size: 132, weight: .light))
                .foregroundStyle(AppColors.orange)

            Text("Well done!")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(AppColors.ink)
                .padding(.top, 24)

            Text("You've completed today's riddle.")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.ink)
                .padding(.top, 10)

            HStack(spacing: 20) {
                Image(systemName: "sun.max")
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(AppColors.orange)

                Text("Come back tomorrow\nfor a new riddle!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .lineSpacing(5)

                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(height: 92)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.42)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.ink.opacity(0.12), lineWidth: 1.5))
            .padding(.horizontal, 28)
            .padding(.top, 28)

            Spacer(minLength: 28)

            Button(action: onHome) {
                Text("Back to Home")
                    .font(.system(size: 18, weight: .bold))
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

private struct RiddleHintPage: View {
    let onBack: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill()
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

private struct ProgressPill: View {
    var body: some View {
        HStack(spacing: 10) {
            Text("1 of 1")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Capsule().fill(AppColors.purple))

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.purple.opacity(0.28))
                        .frame(height: 3)

                    Capsule()
                        .fill(AppColors.purple)
                        .frame(width: geometry.size.width * 0.35, height: 3)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 26)
        }
    }
}

private struct HeaderBar: View {
    let title: String
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColors.ink)

            HStack {
                Button {
                    onBack?()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColors.ink)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Spacer()

                Image(systemName: "lightbulb")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AppColors.ink)
                    .frame(width: 44, height: 44)
                    .accessibilityLabel("Hint")
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
    }
}

private struct DifficultyCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let symbolCount: Int
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    ForEach(0..<symbolCount, id: \.self) { _ in
                        Image(systemName: symbol)
                    }
                }
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(color)
                .frame(width: 86, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(color)

                    Text(subtitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.ink)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 20)
            }
            .padding(.leading, 24)
            .padding(.trailing, 18)
            .frame(height: 108)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.035))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.24), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

private enum AppColors {
    static let background = Color(red: 0.99, green: 0.965, blue: 0.94)
    static let ink = Color(red: 0.08, green: 0.10, blue: 0.31)
    static let purple = Color(red: 0.36, green: 0.22, blue: 0.72)
    static let panel = Color(red: 0.965, green: 0.94, blue: 0.98)
    static let orange = Color(red: 0.96, green: 0.61, blue: 0.08)
    static let green = Color(red: 0.22, green: 0.58, blue: 0.33)
    static let red = Color(red: 0.95, green: 0.33, blue: 0.22)
}

#Preview {
    NotesPage()
}
