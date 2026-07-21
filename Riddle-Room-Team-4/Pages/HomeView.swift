//
//  HomeView.swift
//  Riddle-Room-Team-4
//
//  Homepage — designed for adults 65+, large text, clear contrast.
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

// MARK: - Home View
struct HomeView: View {

    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var userData: UserData
    @State private var activeSlot: RiddleSlot? = nil
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(isDarkMode: $isDarkMode, onSettingsTap: { showingSettings = true })
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    GreetingSection(username: userData.username)
                    TodayRiddleCard(onStart: { activeSlot = .day })
                    TonightRiddleCard(onStart: { activeSlot = .night })
                    StreakCard()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "D3BEBA").ignoresSafeArea())
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

// MARK: - Top Bar
struct TopBarView: View {
    @Binding var isDarkMode: Bool
    var onSettingsTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button {
                onSettingsTap?()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "51366C"))
            }

            Spacer()

            HStack(spacing: 18) {
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "51366C"))
                }

                Button {
                } label: {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "51366C"))
                }
            }
        }
    }
}

// MARK: - Greeting
struct GreetingSection: View {
    let username: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 8) {
                Text("Good morning\(username.isEmpty ? "!" : ", \(username)!")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Image(systemName: "sun.max.fill")
                    .font(.title)
                    .foregroundStyle(.yellow)
            }
            Text("Ready for today's riddle?")
                .font(.title3)
                .foregroundStyle(.secondary)

            Image("happy1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding(.top, 10)
        }
    }
}

// MARK: - Today's Riddle Card
struct TodayRiddleCard: View {
    let onStart: () -> Void

    var body: some View {
        RiddleCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text("A fresh riddle to start your day")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button(action: onStart) {
                        Text("Start Riddle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "51366C"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 6)
                }
            }
        }
    }
}

// MARK: - Tonight's Riddle Card
struct TonightRiddleCard: View {
    let onStart: () -> Void

    var body: some View {
        RiddleCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(hex: "51366C"))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tonight's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text("A riddle to end your day")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button(action: onStart) {
                        Text("Start Night Riddle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "51366C"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 6)
                }
            }
        }
    }
}

// MARK: - Streak Card
struct StreakCard: View {
    @EnvironmentObject var userData: UserData

    private let weekDayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        RiddleCard {
            VStack(spacing: 14) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Streak")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Keep it going!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(userData.streakDays) Days")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "51366C"))
                }

                HStack(spacing: 0) {
                    let completion = userData.thisWeekCompletion
                    ForEach(Array(weekDayLabels.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 5) {
                            Circle()
                                .fill(completion[index] ? Color(hex: "51366C") : Color(.systemGray5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    if completion[index] {
                                        Image(systemName: "checkmark")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                    }
                                }
                            Text(day)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Card Shell
struct RiddleCard<Content: View>: View {
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

#Preview {
    HomeView()
        .environmentObject(UserData())
}
