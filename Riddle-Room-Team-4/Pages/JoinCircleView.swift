import SwiftUI

struct JoinCircleView: View {
    @ObservedObject var manager: BrainCircleManager
    let username: String
    let onJoined: (BrainCircle) -> Void

    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale

    @State private var codeDigits: [String] = Array(repeating: "", count: 6)
    @State private var errorMessage: String = ""
    @State private var showError = false
    @FocusState private var focusedIndex: Int?

    private var enteredCode: String { codeDigits.joined() }
    private var isComplete: Bool { codeDigits.allSatisfy { $0.count == 1 } }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColors.ink)
                        .frame(width: 40, height: 40)
                }
                Spacer()
                Text("Join a Circle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            Spacer()

            // Title
            VStack(spacing: 8) {
                Text("Join a Brain Circle")
                    .font(.system(size: 26 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Text("Enter the code you received\nfrom a friend or family member.")
                    .font(.system(size: 15 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.60))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
            .padding(.horizontal, 28)

            // 6 character boxes
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    characterBox(index: index)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)

            if showError {
                Text(errorMessage)
                    .font(.system(size: 14 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.red)
                    .padding(.top, 12)
            }

            // Join button
            Button {
                attemptJoin()
            } label: {
                Text("Join Circle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(
                        isComplete ? AppColors.purple : AppColors.purple.opacity(0.35)
                    ))
            }
            .buttonStyle(.plain)
            .disabled(!isComplete)
            .padding(.horizontal, 28)
            .padding(.top, 28)

            // Info card
            VStack(spacing: 6) {
                Text("You can join multiple circles\nand stay in them for good.")
                    .font(.system(size: 14 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
            .padding(.horizontal, 28)
            .padding(.top, 24)

            // How do invite codes work
            Button {
                // no-op for MVP
            } label: {
                HStack(spacing: 6) {
                    Text("How do invite codes work?")
                        .font(.system(size: 14 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.purple)
                    Image(systemName: "info.circle")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.purple)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .onAppear { focusedIndex = 0 }
    }

    @ViewBuilder
    private func characterBox(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            focusedIndex == index ? AppColors.purple : AppColors.ink.opacity(0.18),
                            lineWidth: focusedIndex == index ? 2 : 1
                        )
                )
                .frame(width: 46, height: 56)

            Text(codeDigits[index].uppercased())
                .font(.system(size: 22 * fontScale, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
        }
        .overlay(
            TextField("", text: $codeDigits[index])
                .focused($focusedIndex, equals: index)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.characters)
                .opacity(0.01)
                .onChange(of: codeDigits[index]) { _, newVal in
                    handleInput(newVal, at: index)
                }
        )
        .onTapGesture { focusedIndex = index }
    }

    private func handleInput(_ value: String, at index: Int) {
        let clean = value.uppercased().filter { $0.isLetter || $0.isNumber }
        if clean.isEmpty {
            codeDigits[index] = ""
            if index > 0 { focusedIndex = index - 1 }
        } else {
            codeDigits[index] = String(clean.last!)
            if index < 5 { focusedIndex = index + 1 }
            else { focusedIndex = nil }
        }
        showError = false
    }

    private func attemptJoin() {
        let code = enteredCode.uppercased()
        if let circle = manager.join(code: code, username: username) {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                onJoined(circle)
            }
        } else {
            errorMessage = "No circle found with code \"\(code)\". Check the code and try again."
            showError = true
        }
    }
}
