import SwiftUI

struct MyRiddleView: View {
    let circle: BrainCircle
    @ObservedObject var manager: BrainCircleManager

    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale

    @State private var answer: String = ""
    @State private var attempts: Int = 0
    @State private var showWrong: Bool = false
    @State private var solved: Bool = false

    private let maxAttempts = 3

    private var myRiddle: BCMemberRiddle {
        circle.riddleFor(member: circle.currentUserMember)
    }

    private var attemptsLeft: Int { maxAttempts - attempts }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Your Riddle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                HStack {
                    Button { dismiss() } label: {
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

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    if solved {
                        solvedView
                    } else {
                        riddleView
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
    }

    // MARK: - Riddle view

    private var riddleView: some View {
        VStack(spacing: 20) {
            // Family context
            HStack(spacing: 8) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.purple)
                Text(circle.familyName)
                    .font(.system(size: 13 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.purple)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(AppColors.purple.opacity(0.10)))

            // Riddle question
            VStack(spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(AppColors.orange)

                Text("Your Clue Riddle")
                    .font(.system(size: 13 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink.opacity(0.50))

                Text(myRiddle.question)
                    .font(.system(size: 20 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.panel))

            // Attempts remaining
            if attempts > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption.weight(.semibold))
                    Text("\(attemptsLeft) attempt\(attemptsLeft == 1 ? "" : "s") remaining")
                        .font(.system(size: 14 * fontScale, weight: .bold))
                }
                .foregroundStyle(attemptsLeft == 1 ? AppColors.red : AppColors.orange)
            }

            // Wrong answer feedback
            if showWrong {
                HStack(spacing: 10) {
                    Image("confused")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Not quite right!")
                            .font(.system(size: 14 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.red)
                        Text("Think about the riddle again and try a different word.")
                            .font(.system(size: 12 * fontScale, weight: .semibold))
                            .foregroundStyle(AppColors.ink.opacity(0.60))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.red.opacity(0.07)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.red.opacity(0.18), lineWidth: 1))
            }

            // Exhausted all attempts → reveal
            if attempts >= maxAttempts {
                revealCard
            } else {
                // Answer input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Answer (one word)")
                        .font(.system(size: 13 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink.opacity(0.55))

                    TextField("Type your answer here...", text: $answer)
                        .font(.system(size: 16 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .onSubmit { submitAnswer() }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(AppColors.panel)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.20), lineWidth: 1.5))
                }

                Button { submitAnswer() } label: {
                    Text("Submit Answer")
                        .font(.system(size: 17 * fontScale, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).fill(
                            answer.trimmingCharacters(in: .whitespaces).isEmpty
                                ? AppColors.purple.opacity(0.35)
                                : AppColors.purple
                        ))
                }
                .buttonStyle(.plain)
                .disabled(answer.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    // MARK: - Reveal card (no attempts left)

    private var revealCard: some View {
        VStack(spacing: 12) {
            Text("You've used all your attempts.")
                .font(.system(size: 15 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink)

            VStack(alignment: .leading, spacing: 6) {
                Text("The answer was:")
                    .font(.system(size: 13 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.55))
                Text(myRiddle.answer.capitalized)
                    .font(.system(size: 22 * fontScale, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppColors.green)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.green.opacity(0.08)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.green.opacity(0.18), lineWidth: 1))

            Text("Your answer has been marked. The family riddle will unlock once everyone is done!")
                .font(.system(size: 13 * fontScale, weight: .semibold))
                .foregroundStyle(AppColors.ink.opacity(0.60))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button {
                manager.completeMyRiddle(circleId: circle.id, answer: myRiddle.answer)
                dismiss()
            } label: {
                Text("Continue")
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

    // MARK: - Solved view

    private var solvedView: some View {
        VStack(spacing: 20) {
            Image("happy")
                .resizable()
                .scaledToFit()
                .frame(height: 140)

            Text("You got it!")
                .font(.system(size: 28 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink)

            VStack(spacing: 8) {
                Text("Your word:")
                    .font(.system(size: 14 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.55))
                Text(myRiddle.answer.capitalized)
                    .font(.system(size: 32 * fontScale, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppColors.purple)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.panel))

            Text("Your clue word is now part of the family puzzle. Wait for everyone else to finish, then you'll all guess the final word together!")
                .font(.system(size: 14 * fontScale, weight: .semibold))
                .foregroundStyle(AppColors.ink.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(5)

            Button { dismiss() } label: {
                Text("Back to Family")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Logic

    private func submitAnswer() {
        let trimmed = answer.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return }
        let expected = myRiddle.answer.lowercased()
        if trimmed == expected {
            manager.completeMyRiddle(circleId: circle.id, answer: trimmed)
            withAnimation { solved = true }
        } else {
            attempts += 1
            showWrong = true
            answer = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showWrong = false
            }
        }
    }
}
