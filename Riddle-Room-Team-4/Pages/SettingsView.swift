import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    @Environment(\.appFontScale) var fontScale
    @Environment(\.colorScheme) var colorScheme
    @State private var showingResetAlert = false

    // Bypass UIColor adaptive (which reads system trait, not SwiftUI preferredColorScheme)
    private var textColor: Color {
        colorScheme == .dark
            ? Color(red: 0.98, green: 0.94, blue: 0.89)   // beige
            : Color(red: 0.08, green: 0.10, blue: 0.31)   // dark navy
    }
    private var bgColor: Color {
        colorScheme == .dark
            ? Color(red: 0.07, green: 0.06, blue: 0.12)
            : Color(red: 0.945, green: 0.894, blue: 0.835)
    }
    private var panelColor: Color {
        colorScheme == .dark
            ? Color(red: 0.12, green: 0.09, blue: 0.19)
            : Color(red: 1.0, green: 0.969, blue: 0.929)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Settings")
                    .font(.system(size: 20 * fontScale, weight: .bold))
                    .foregroundStyle(textColor)

                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(textColor.opacity(0.35))
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 52)
            .padding(.top, 16)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: Sound
                    SettingsCard(panelColor: panelColor) {
                        VStack(spacing: 0) {
                            SectionHeader(icon: "speaker.wave.2.fill", title: "Sound", textColor: textColor)

                            Divider()
                                .padding(.vertical, 14)

                            // Music toggle
                            HStack {
                                Text("Background Music")
                                    .font(.system(size: 16 * fontScale, weight: .semibold))
                                    .foregroundStyle(textColor)
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { !userData.isMusicMuted },
                                    set: { userData.isMusicMuted = !$0 }
                                ))
                                .tint(AppColors.purple)
                            }

                            // Music volume slider
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Music Volume")
                                    .font(.system(size: 14 * fontScale, weight: .semibold))
                                    .foregroundStyle(textColor.opacity(0.70))
                                HStack(spacing: 10) {
                                    Image(systemName: "music.note")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(textColor.opacity(0.45))
                                    Slider(value: $userData.musicVolume, in: 0...1)
                                        .tint(AppColors.purple)
                                        .disabled(userData.isMusicMuted)
                                        .opacity(userData.isMusicMuted ? 0.40 : 1)
                                    Image(systemName: "music.note.list")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(textColor.opacity(0.45))
                                }
                            }
                            .padding(.top, 4)

                            Divider()
                                .padding(.vertical, 14)

                            // SFX volume
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Sound Effects Volume")
                                    .font(.system(size: 16 * fontScale, weight: .semibold))
                                    .foregroundStyle(textColor)
                                HStack(spacing: 10) {
                                    Image(systemName: "speaker.fill")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(textColor.opacity(0.55))
                                    Slider(value: $userData.sfxVolume, in: 0...1)
                                        .tint(AppColors.purple)
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(textColor.opacity(0.55))
                                }
                            }
                        }
                    }

                    // MARK: Text Size
                    SettingsCard(panelColor: panelColor) {
                        VStack(spacing: 0) {
                            SectionHeader(icon: "textformat.size", title: "Text Size", textColor: textColor)

                            Divider()
                                .padding(.vertical, 14)

                            HStack(spacing: 12) {
                                Text("A")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(textColor.opacity(0.5))
                                Slider(value: $userData.fontScale, in: 0.8...1.3)
                                    .tint(AppColors.purple)
                                Text("A")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(textColor)
                            }

                            // Live preview card
                            VStack(alignment: .leading, spacing: 8) {
                                Text("PREVIEW")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(AppColors.purple.opacity(0.6))
                                    .tracking(1.2)

                                Text("Ready for today's riddle?")
                                    .font(.system(size: 22 * fontScale, weight: .bold))
                                    .foregroundStyle(textColor)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text("Choose a difficulty and test your mind with a fun daily challenge.")
                                    .font(.system(size: 14 * fontScale, weight: .regular))
                                    .foregroundStyle(textColor.opacity(0.65))
                                    .lineSpacing(4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(panelColor.opacity(0.6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.purple.opacity(0.14), lineWidth: 1)
                            )
                            .padding(.top, 14)
                        }
                    }

                    // MARK: Reset
                    SettingsCard(panelColor: panelColor) {
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
        .background(bgColor.ignoresSafeArea())
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
    let textColor: Color
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
                .foregroundStyle(textColor.opacity(0.55))
                .tracking(0.8)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SettingsCard<Content: View>: View {
    let panelColor: Color
    let content: () -> Content

    init(panelColor: Color, @ViewBuilder content: @escaping () -> Content) {
        self.panelColor = panelColor
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(panelColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
