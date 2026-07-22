import SwiftUI
import UIKit

struct StartCircleView: View {
    @ObservedObject var manager: BrainCircleManager
    let username: String
    let onOpenCircle: (BrainCircle) -> Void

    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale

    @State private var familyName: String = ""
    @State private var previewCode: String = ""
    @State private var step: Step = .naming
    @State private var didCopy = false

    enum Step { case naming, ready }

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
                Text(step == .naming ? "Start a Circle" : "Your Brain Circle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            if step == .naming {
                namingView
            } else {
                readyView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
    }

    // MARK: - Naming step

    private var namingView: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("happy")
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .padding(.bottom, 24)

            VStack(spacing: 8) {
                Text("Name Your Circle")
                    .font(.system(size: 26 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Text("Give your family circle a name so\neveryone knows where they belong.")
                    .font(.system(size: 15 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
            .padding(.horizontal, 28)

            VStack(alignment: .leading, spacing: 8) {
                Text("Family Circle Name")
                    .font(.system(size: 13 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink.opacity(0.65))
                TextField("e.g. The Smith Family", text: $familyName)
                    .font(.system(size: 16 * fontScale, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(AppColors.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.20), lineWidth: 1.5))
            }
            .padding(.horizontal, 28)
            .padding(.top, 32)

            Spacer()

            Button {
                // Generate code for preview only — circle not committed yet
                previewCode = BrainCircleManager.previewCode()
                step = .ready
            } label: {
                Text("Create Circle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(
                        familyName.trimmingCharacters(in: .whitespaces).isEmpty
                            ? AppColors.purple.opacity(0.35)
                            : AppColors.purple
                    ))
            }
            .buttonStyle(.plain)
            .disabled(familyName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Ready step

    private var readyView: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Text("is ready!")
                        .font(.system(size: 28 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                    Image("happy")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)

                    Text("Share this code with your\nfamily and friends.")
                        .font(.system(size: 17 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.70))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)

                    // Code card
                    VStack(spacing: 8) {
                        Text("Circle Code")
                            .font(.system(size: 13 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.ink.opacity(0.55))
                        HStack(spacing: 16) {
                            Spacer()
                            Text(previewCode)
                                .font(.system(size: 38 * fontScale, weight: .heavy, design: .rounded))
                                .foregroundStyle(AppColors.purple)
                                .minimumScaleFactor(0.7)
                            Button {
                                UIPasteboard.general.string = previewCode
                                didCopy = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { didCopy = false }
                            } label: {
                                Image(systemName: didCopy ? "checkmark.circle.fill" : "doc.on.doc")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(didCopy ? AppColors.green : AppColors.purple)
                                    .frame(width: 44, height: 44)
                            }
                        }
                        Text("This code will never expire.")
                            .font(.system(size: 12 * fontScale, weight: .medium))
                            .foregroundStyle(AppColors.ink.opacity(0.45))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.panel))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.purple.opacity(0.15), lineWidth: 1.5))
                    .padding(.horizontal, 4)

                    // Share button
                    ShareLink(item: "Join my Brain Circle on Riddle Room!\nUse code: \(previewCode)") {
                        Label("Share Code", systemImage: "square.and.arrow.up")
                            .font(.system(size: 17 * fontScale, weight: .bold))
                            .foregroundStyle(AppColors.purple)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple.opacity(0.10)))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.purple.opacity(0.25), lineWidth: 1.5))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }

            // Fixed bottom button — always visible
            Button {
                let circle = manager.commitCircle(code: previewCode, familyName: familyName, username: username)
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    onOpenCircle(circle)
                }
            } label: {
                Text("Go to My Circle")
                    .font(.system(size: 17 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.purple))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
            .padding(.top, 12)
        }
    }
}
