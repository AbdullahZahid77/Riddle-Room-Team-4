import SwiftUI

struct CircleDetailView: View {
    let circleId: String
    @ObservedObject var manager: BrainCircleManager
    @EnvironmentObject var userData: UserData

    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale
    @Environment(\.colorScheme) private var colorScheme

    private var codeTextColor: Color {
        colorScheme == .dark ? AppColors.darkInk : AppColors.purple
    }

    @State private var showingHowToPlay = false
    @State private var showingMyRiddle = false
    @State private var showingFinalGuess = false

    private var circle: BrainCircle? { manager.circle(id: circleId) }

    var body: some View {
        Group {
            if let circle {
                content(circle)
            } else {
                Text("Circle not found").foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background.ignoresSafeArea())
            }
        }
    }

    @ViewBuilder
    private func content(_ circle: BrainCircle) -> some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text(circle.familyName)
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 60)

                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(AppColors.ink)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                    Button { showingHowToPlay = true } label: {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(AppColors.purple)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 52)
            .padding(.top, 12)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Status banner
                    statusBanner(circle)

                    // Code card
                    codeCard(circle)

                    // Members list
                    membersCard(circle)

                    // Action button
                    actionButton(circle)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayCircleView()
        }
        .fullScreenCover(isPresented: $showingMyRiddle) {
            if let c = manager.circle(id: circleId) {
                MyRiddleView(circle: c, manager: manager)
            }
        }
        .fullScreenCover(isPresented: $showingFinalGuess) {
            if let c = manager.circle(id: circleId) {
                FinalGuessView(circle: c, manager: manager, onDismiss: { showingFinalGuess = false })
            }
        }
    }

    // MARK: - Status banner

    @ViewBuilder
    private func statusBanner(_ circle: BrainCircle) -> some View {
        let (icon, msg, bg, fg) = bannerContent(circle)
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fg)
            Text(msg)
                .font(.system(size: 14 * fontScale, weight: .bold))
                .foregroundStyle(fg)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(bg))
    }

    private func bannerContent(_ circle: BrainCircle) -> (String, String, Color, Color) {
        if circle.finalResult == true {
            return ("checkmark.seal.fill", "Your family solved it! Amazing work!", AppColors.green.opacity(0.12), AppColors.green)
        } else if circle.finalResult == false {
            return ("xmark.circle.fill", "Incorrect guess — try the final answer again!", AppColors.red.opacity(0.10), AppColors.red)
        } else if circle.allMembersCompleted {
            return ("star.fill", "Everyone is done! Time to guess the final word.", AppColors.orange.opacity(0.12), AppColors.orange)
        } else if circle.currentUserHasCompleted {
            return ("hourglass", "You're done! Waiting for \(circle.members.count - circle.completedCount) more member(s).", AppColors.purple.opacity(0.10), AppColors.purple)
        } else {
            return ("pencil.circle.fill", "Your riddle is waiting! Tap below to start.", AppColors.purple.opacity(0.10), AppColors.purple)
        }
    }

    // MARK: - Code card

    private func codeCard(_ circle: BrainCircle) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Circle Code")
                    .font(.system(size: 11 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink.opacity(0.45))
                Text(circle.id)
                    .font(.system(size: 22 * fontScale, weight: .heavy, design: .rounded))
                    .foregroundStyle(codeTextColor)
            }
            Spacer()
            Button {
                UIPasteboard.general.string = circle.id
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.purple)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(AppColors.purple.opacity(0.10)))
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Members card

    private func membersCard(_ circle: BrainCircle) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Family Members")
                    .font(.system(size: 14 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink.opacity(0.55))
                Spacer()
                Text("\(circle.completedCount)/\(circle.members.count) done")
                    .font(.system(size: 12 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.orange)
            }
            .padding(.bottom, 10)

            VStack(spacing: 1) {
                ForEach(Array(circle.members.enumerated()), id: \.element.id) { idx, member in
                    memberRow(member, isCurrentUser: idx == circle.currentUserIndex)
                    if idx < circle.members.count - 1 {
                        Divider().padding(.horizontal, 2)
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
    }

    private func memberRow(_ member: CircleMember, isCurrentUser: Bool) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(member.hasCompleted ? AppColors.green.opacity(0.12) : AppColors.ink.opacity(0.07))
                    .frame(width: 38, height: 38)
                Image(systemName: member.hasCompleted ? "checkmark" : "clock")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(member.hasCompleted ? AppColors.green : AppColors.ink.opacity(0.40))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(member.name)
                        .font(.system(size: 15 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    if isCurrentUser {
                        Text("(You)")
                            .font(.system(size: 11 * fontScale, weight: .semibold))
                            .foregroundStyle(AppColors.purple)
                    }
                }
                Text(member.hasCompleted ? "Clue found ✓" : "Solving their riddle...")
                    .font(.system(size: 12 * fontScale, weight: .semibold))
                    .foregroundStyle(member.hasCompleted ? AppColors.green : AppColors.ink.opacity(0.40))
            }

            Spacer()
        }
        .padding(.vertical, 10)
    }

    // MARK: - Action button

    @ViewBuilder
    private func actionButton(_ circle: BrainCircle) -> some View {
        if circle.finalResult == true {
            // Already solved — show a completion message
            HStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(AppColors.orange)
                Text("Your family solved the riddle together!")
                    .font(.system(size: 15 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.panel))
        } else if circle.allMembersCompleted {
            // Guess the final word
            Button { showingFinalGuess = true } label: {
                Text("Guess the Final Word")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.orange))
            }
            .buttonStyle(.plain)
        } else if !circle.currentUserHasCompleted {
            // Do my riddle
            Button { showingMyRiddle = true } label: {
                Text("Do My Riddle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
        } else {
            // User done, waiting for others
            VStack(spacing: 8) {
                Text("You've completed your riddle!")
                    .font(.system(size: 15 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.green)
                Text("Waiting for other family members to finish their riddles before the final guess.")
                    .font(.system(size: 13 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.panel))
        }
    }
}
