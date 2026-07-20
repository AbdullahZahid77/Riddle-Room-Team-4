//
//  BrainCircleView.swift
//  Riddle-Room-Team-4
//
//  Brain Circle / Friends page.
//

import SwiftUI
import UIKit

struct BrainCircleView: View {
    @State private var isShowingCircleCode = false

    private let circleCode = "ABX7GQ9"

    var body: some View {
        Group {
            if isShowingCircleCode {
                CircleReadyView(
                    circleCode: circleCode,
                    onBack: { isShowingCircleCode = false }
                )
            } else {
                startJoinView
            }
        }
        .animation(.easeInOut, value: isShowingCircleCode)
    }

    private var startJoinView: some View {
        VStack(spacing: 28) {
            header

            VStack(spacing: 18) {
                circleOption(
                    title: "Start a Circle",
                    subtitle: "Create a new Brain Circle\nand invite others.",
                    action: { isShowingCircleCode = true }
                )

                circleOption(
                    title: "Join a Circle",
                    subtitle: "Enter a code to join an\nexisting Circle.",
                    action: { }
                )
            }

            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 18) {
            HStack {
                Button {
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundStyle(.indigo)
                }

                Spacer()

                Button {
                } label: {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundStyle(.indigo)
                }
            }

            VStack(spacing: 14) {
                Text("Brain Circle")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.indigo)

                Text("Stay connected with your\nfriends and family while\nexercising your brain together.")
                    .font(.system(size: 19, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .foregroundStyle(.indigo)
            }
        }
    }

    private func circleOption(title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Image(systemName: "person.3")
                    .font(.system(size: 42))
                    .foregroundStyle(.indigo)
                    .frame(width: 64)

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))

                    Text(subtitle)
                        .font(.system(size: 15, weight: .semibold))
                        .lineSpacing(6)
                }
                .foregroundStyle(.indigo)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.indigo)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.indigo.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct CircleReadyView: View {
    let circleCode: String
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: 26) {
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.orange)
                        .padding(.top, 8)

                    Text("Your Brain Circle\nis ready!")
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .foregroundStyle(.indigo)

                    brainDoorIllustration
                        .padding(.vertical, 4)

                    Text("Share this code with your\nfamily and friends.")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .foregroundStyle(.indigo.opacity(0.75))

                    codeCard

                    ShareLink(item: "Join my Brain Circle with code: \(circleCode)") {
                        Label("Share Code", systemImage: "square.and.arrow.up")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Text("This code will never expire.")
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(.indigo.opacity(0.75))
                        .padding(.top, 20)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private var topBar: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.indigo)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "lightbulb")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.indigo)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 28)
        .padding(.bottom, 12)
    }

    private var brainDoorIllustration: some View {
        ZStack {
            ForEach(0..<10) { index in
                SparkleDot(index: index)
            }

            Image(systemName: "door.left.hand.open")
                .font(.system(size: 126))
                .foregroundStyle(.purple)
                .offset(x: -18)

            Image(systemName: "brain.head.profile")
                .font(.system(size: 76))
                .foregroundStyle(.pink)
                .offset(x: 32, y: 8)
        }
        .frame(height: 210)
        .frame(maxWidth: .infinity)
    }

    private var codeCard: some View {
        VStack(spacing: 6) {
            Text("Circle Code")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.indigo.opacity(0.7))

            HStack(spacing: 18) {
                Spacer()

                Text(circleCode)
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundStyle(.indigo)
                    .minimumScaleFactor(0.7)

                Button {
                    UIPasteboard.general.string = circleCode
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.indigo)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.indigo.opacity(0.12), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct SparkleDot: View {
    let index: Int

    private var color: Color {
        index.isMultiple(of: 2) ? .orange : .purple.opacity(0.45)
    }

    private var size: CGFloat {
        [8, 5, 7, 10, 4, 6, 9, 5, 7, 4][index]
    }

    private var offset: CGSize {
        [
            CGSize(width: -125, height: -56),
            CGSize(width: 112, height: -68),
            CGSize(width: -94, height: 48),
            CGSize(width: 124, height: 44),
            CGSize(width: -40, height: -86),
            CGSize(width: 74, height: 82),
            CGSize(width: 8, height: -96),
            CGSize(width: -132, height: 14),
            CGSize(width: 136, height: -2),
            CGSize(width: 46, height: -108)
        ][index]
    }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(offset)
    }
}

#Preview {
    BrainCircleView()
}
