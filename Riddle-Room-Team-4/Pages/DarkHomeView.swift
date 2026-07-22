import SwiftUI

struct DarkHomeView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var userData: UserData
    @State private var activeSlot: RiddleSlot? = nil
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            DarkTopBarView(isDarkMode: $isDarkMode, onSettingsTap: { showingSettings = true })
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    DarkGreetingSection(username: userData.username)
                    DarkTonightRiddleCard(onStart: { activeSlot = .night })
                    DarkMorningLockedCard()
                    DarkStreakCard()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.darkBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .fullScreenCover(item: $activeSlot) { slot in
            RiddleFlowView(slot: slot, onDismiss: { activeSlot = nil })
                .environmentObject(userData)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(userData)
        }
    }
}

private struct DarkTopBarView: View {
    @Binding var isDarkMode: Bool
    var onSettingsTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button {
                onSettingsTap?()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(AppColors.darkAccent)
            }

            Spacer()

            HStack(spacing: 18) {
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: "moon.fill")
                        .font(.title2)
                        .foregroundStyle(AppColors.darkAccent)
                }

                Button {
                } label: {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundStyle(AppColors.darkAccent)
                }
            }
        }
    }
}

private struct DarkGreetingSection: View {
    let username: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 8) {
                Text("Good evening\(username.isEmpty ? "!" : ", \(username)!")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.darkInk)

                Image(systemName: "moon.stars.fill")
                    .font(.title)
                    .foregroundStyle(AppColors.darkAccent)
            }

            Text("Ready for tonight's riddle?")
                .font(.title3)
                .foregroundStyle(AppColors.darkMuted)

            Image("thinking")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding(.top, 10)
        }
    }
}

private struct DarkTonightRiddleCard: View {
    let onStart: () -> Void

    var body: some View {
        DarkRiddleCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(AppColors.darkAccent)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tonight's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.darkInk)

                    Text("A riddle to end your day")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.darkMuted)

                    Button(action: onStart) {
                        Text("Start Night Riddle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 6)
                }
            }
        }
    }
}

private struct DarkMorningLockedCard: View {
    var body: some View {
        DarkRiddleCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(AppColors.darkRed)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Morning's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.darkInk)

                    Text("Locked until morning")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.darkMuted)

                    Button {
                    } label: {
                        Text("Locked until morning")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.darkRed)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(true)
                    .padding(.top, 6)
                }
            }
        }
    }
}

private struct DarkStreakCard: View {
    @EnvironmentObject var userData: UserData

    private let weekDayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        DarkRiddleCard {
            VStack(spacing: 14) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Streak")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.darkInk)

                        Text("Keep it going!")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.darkMuted)
                    }

                    Spacer()

                    Text("\(userData.streakDays) Days")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.darkAccent)
                }

                HStack(spacing: 0) {
                    let completion = userData.thisWeekCompletion
                    ForEach(Array(weekDayLabels.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 5) {
                            Circle()
                                .fill(completion[index] ? AppColors.darkAccent : AppColors.darkBackground)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    if completion[index] {
                                        Image(systemName: "checkmark")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(AppColors.darkBackground)
                                    }
                                }

                            Text(day)
                                .font(.caption2)
                                .foregroundStyle(AppColors.darkMuted)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

private struct DarkRiddleCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.darkPanel)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.darkAccent.opacity(0.20), lineWidth: 1)
            )
    }
}

#Preview {
    DarkHomeView()
        .environmentObject(UserData())
}
