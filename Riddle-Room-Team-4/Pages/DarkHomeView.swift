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
                    GroupRiddleImage()
                    DarkTonightRiddleCard(onStart: { activeSlot = .night })
                    DarkMorningLockedCard()
                    DarkStreakCard()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NightSkyBackground().ignoresSafeArea())
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

private struct NightSkyBackground: View {
    private let stars: [NightSkyStar] = [
        NightSkyStar(x: 0.16, y: 0.08, size: 12, opacity: 0.90),
        NightSkyStar(x: 0.33, y: 0.11, size: 8, opacity: 0.60),
        NightSkyStar(x: 0.56, y: 0.08, size: 11, opacity: 0.78),
        NightSkyStar(x: 0.78, y: 0.12, size: 9, opacity: 0.70),
        NightSkyStar(x: 0.91, y: 0.17, size: 13, opacity: 0.82),
        NightSkyStar(x: 0.20, y: 0.20, size: 6, opacity: 0.50),
        NightSkyStar(x: 0.68, y: 0.23, size: 7, opacity: 0.52),
        NightSkyStar(x: 0.10, y: 0.32, size: 9, opacity: 0.62),
        NightSkyStar(x: 0.58, y: 0.38, size: 5, opacity: 0.38),
        NightSkyStar(x: 0.86, y: 0.31, size: 6, opacity: 0.42)
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.02, blue: 0.20),
                        Color(red: 0.16, green: 0.06, blue: 0.30),
                        Color(red: 0.06, green: 0.02, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.38, green: 0.20, blue: 0.55).opacity(0.45),
                        .clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 360
                )

                ForEach(stars) { star in
                    ShinyStar(size: star.size, opacity: star.opacity)
                        .position(
                            x: proxy.size.width * star.x,
                            y: proxy.size.height * star.y
                        )
                }
            }
        }
    }
}

private struct ShinyStar: View {
    let size: CGFloat
    let opacity: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(opacity * 0.22))
                .frame(width: size * 1.8, height: size * 1.8)
                .blur(radius: 3)

            Image(systemName: "sparkle")
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(.white.opacity(opacity))
        }
    }
}

private struct NightSkyStar: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
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
//
//                Image(systemName: "moon.stars.fill")
//                    .font(.title)
//                    .foregroundStyle(AppColors.darkAccent)
            }

            Text("Ready for tonight's riddle?")
                .font(.title3)
                .foregroundStyle(AppColors.darkMuted)

            
//            Image("happy1")
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: .infinity, maxHeight: 150)
//                .padding(.top, 10)
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
                    .padding(.top, 22)

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
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Morning's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.darkInk)

                    Text("Unlocks at 5 PM")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.darkMuted)
                }

                Spacer()

                Image(systemName: "lock.fill")
                    .font(.system(size: 38))
                    .foregroundStyle(AppColors.darkRed)
                    .padding(.trailing, 18)
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
