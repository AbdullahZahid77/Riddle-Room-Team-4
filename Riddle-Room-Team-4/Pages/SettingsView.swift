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

struct SettingsView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale
    @State private var showingResetAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Settings")
                    .font(.system(size: 20 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)

                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.ink.opacity(0.35))
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 52)
            .padding(.top, 16)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: Sound
                    SettingsCard {
                        VStack(spacing: 0) {
                            SectionHeader(icon: "speaker.wave.2.fill", title: "Sound")

                            Divider()
                                .padding(.vertical, 14)

                            // Music toggle
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Background Music")
                                        .font(.system(size: 16 * fontScale, weight: .semibold))
                                        .foregroundStyle(AppColors.ink)
                                    Text("Coming soon")
                                        .font(.system(size: 12 * fontScale, weight: .medium))
                                        .foregroundStyle(AppColors.ink.opacity(0.38))
                                }
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { !userData.isMusicMuted },
                                    set: { userData.isMusicMuted = !$0 }
                                ))
                                .tint(AppColors.purple)
                                .disabled(true)
                                .opacity(0.45)
                            }

                            Divider()
                                .padding(.vertical, 14)

                            // SFX volume
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Sound Effects")
                                        .font(.system(size: 16 * fontScale, weight: .semibold))
                                        .foregroundStyle(AppColors.ink)
                                    Spacer()
                                    Text("Coming soon")
                                        .font(.system(size: 12 * fontScale, weight: .medium))
                                        .foregroundStyle(AppColors.ink.opacity(0.38))
                                }
                                HStack(spacing: 10) {
                                    Image(systemName: "speaker.fill")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(AppColors.ink.opacity(0.38))
                                    Slider(value: $userData.sfxVolume, in: 0...1)
                                        .tint(AppColors.purple)
                                        .disabled(true)
                                        .opacity(0.45)
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(AppColors.ink.opacity(0.38))
                                }
                            }
                        }
                    }

                    // MARK: Text Size
                    SettingsCard {
                        VStack(spacing: 0) {
                            SectionHeader(icon: "textformat.size", title: "Text Size")

                            Divider()
                                .padding(.vertical, 14)

                            HStack(spacing: 12) {
                                Text("A")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(AppColors.ink.opacity(0.5))
                                Slider(value: $userData.fontScale, in: 0.8...1.5)
                                    .tint(AppColors.purple)
                                Text("A")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(AppColors.ink)
                            }

                            // Live preview card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("PREVIEW")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(AppColors.purple.opacity(0.6))
                                    .tracking(1.2)

                                Text("Ready for today's riddle?")
                                    .font(.system(size: 22 * fontScale, weight: .bold))
                                    .foregroundStyle(AppColors.ink)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text("Choose a difficulty and test your mind with a fun daily challenge.")
                                    .font(.system(size: 14 * fontScale, weight: .regular))
                                    .foregroundStyle(AppColors.ink.opacity(0.65))
                                    .lineSpacing(4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AppColors.purple.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.purple.opacity(0.14), lineWidth: 1)
                            )
                            .padding(.top, 14)
                        }
                    }

                    // MARK: Reset
                    SettingsCard {
                        Button { showingResetAlert = true } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 17 * fontScale, weight: .semibold))
                                    .foregroundStyle(AppColors.red)
                                    .frame(width: 30)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Reset App Data")
                                        .font(.system(size: 16 * fontScale, weight: .semibold))
                                        .foregroundStyle(AppColors.red)
                                    Text("Clears your name, progress and streak")
                                        .font(.system(size: 12 * fontScale, weight: .medium))
                                        .foregroundStyle(AppColors.red.opacity(0.65))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13 * fontScale, weight: .semibold))
                                    .foregroundStyle(AppColors.red.opacity(0.4))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 36)
            }
        }
        .background(Color(hex: "D3BEBA").ignoresSafeArea())
        .alert("Reset App Data", isPresented: $showingResetAlert) {
            Button("Reset", role: .destructive) {
                userData.resetAll()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will clear your name, progress, and streak. The setup screen will appear on next launch.")
        }
    }
}

// MARK: - Internal components

private struct SectionHeader: View {
    let icon: String
    let title: String
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.purple)
                .frame(width: 28, height: 28)
                .background(Circle().fill(AppColors.purple.opacity(0.12)))

            Text(title)
                .font(.system(size: 13 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink.opacity(0.55))
                .tracking(0.8)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SettingsCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "FFF7ED"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
