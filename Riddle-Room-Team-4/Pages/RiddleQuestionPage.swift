import SwiftUI

struct RiddleQuestionPage: View {
    @Binding var answer: String
    let currentRiddleNumber: Int
    let totalRiddles: Int
    let onBack: () -> Void
    let onHint: () -> Void
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Today's Riddle", onBack: onBack)
                .padding(.top, 12)

            ProgressPill(currentRiddle: currentRiddleNumber, totalRiddles: totalRiddles)
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
