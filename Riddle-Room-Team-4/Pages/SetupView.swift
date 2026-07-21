//
//  SetupView.swift
//  Riddle-Room-Team-4
//
//  First-time onboarding — user sets their username.
//

import SwiftUI

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

struct SetupView: View {
    @EnvironmentObject var userData: UserData
    @State private var username: String = ""
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Illustration
            ZStack {
                Circle()
                    .fill(Color(hex: "51366C").opacity(0.10))
                    .frame(width: 160, height: 160)

                Image(systemName: "person.crop.circle")
                    .font(.system(size: 96 * fontScale, weight: .light))
                    .foregroundStyle(Color(hex: "51366C"))
            }

            // Welcome text
            VStack(spacing: 10) {
                Text("Welcome to Riddle Room!")
                    .font(.system(size: 28 * fontScale, weight: .bold))
                    .foregroundStyle(Color(hex: "51366C"))
                    .multilineTextAlignment(.center)

                Text("Let's set up your profile.\nWhat should we call you?")
                    .font(.system(size: 17 * fontScale, weight: .semibold))
                    .foregroundStyle(Color(hex: "51366C").opacity(0.70))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            .padding(.top, 28)
            .padding(.horizontal, 32)

            // Username card
            VStack(alignment: .leading, spacing: 10) {
                Text("Your Name")
                    .font(.system(size: 14 * fontScale, weight: .bold))
                    .foregroundStyle(Color(hex: "51366C").opacity(0.70))

                TextField("e.g. Margaret", text: $username)
                    .font(.system(size: 18 * fontScale, weight: .semibold))
                    .foregroundStyle(Color(hex: "51366C"))
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "51366C").opacity(0.20), lineWidth: 1.5)
                    )
            }
            .padding(20)
            .background(Color(hex: "FFF7ED"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 28)
            .padding(.top, 36)

            Spacer()

            // Get started button
            Button {
                let trimmed = username.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return }
                userData.username = trimmed
                userData.isSetupComplete = true
            } label: {
                Text("Get Started")
                    .font(.system(size: 18 * fontScale, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
                    .padding(.vertical, 4)
                    .background(
                        username.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color(hex: "51366C").opacity(0.40)
                            : Color(hex: "51366C")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 28)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "D3BEBA").ignoresSafeArea())
    }
}

#Preview {
    SetupView()
}
