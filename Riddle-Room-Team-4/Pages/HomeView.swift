//
//  HomeView.swift
//  Riddle-Room-Team-4
//
//  Homepage — designed for adults 65+, large text, clear contrast.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {

    // Persisted dark/light mode preference — shared with ContentView
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack(spacing: 0) {
            // Top bar: menu + theme toggle + bell
            TopBarView(isDarkMode: $isDarkMode)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

            // Scrollable cards
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    GreetingSection()
                    TodayRiddleCard()
                    TonightRiddleCard()
                    StreakCard()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - Top Bar
struct TopBarView: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        HStack {
            // Hamburger — future: opens side drawer
            Button {
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            Spacer()

            HStack(spacing: 18) {
                // Toggle light / dark mode
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }

                // Bell — future: notifications sheet
                Button {
                } label: {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

// MARK: - Greeting
struct GreetingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 8) {
                Text("Good morning!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Image(systemName: "sun.max.fill")
                    .font(.title)
                    .foregroundStyle(.yellow)
            }
            Text("Ready for today's riddle?")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Today's Riddle Card
struct TodayRiddleCard: View {
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

                    // Start button — future: navigate to riddle view
                    Button {
                    } label: {
                        Text("Start Riddle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.indigo)
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
    var body: some View {
        RiddleCard {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.indigo)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tonight's Riddle")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text("Unlocks at 6:00 PM")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Streak Card
struct StreakCard: View {

    // Placeholder data — replace with real model later
    let streakDays = 5
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let completedCount = 5

    var body: some View {
        RiddleCard {
            VStack(spacing: 14) {
                HStack(spacing: 16) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Streak")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Keep it going!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(streakDays) Days")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }

                // Week day progress circles
                HStack(spacing: 0) {
                    ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 5) {
                            Circle()
                                .fill(index < completedCount ? Color.orange : Color(.systemGray5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    if index < completedCount {
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
// Wraps any content in a rounded, background-coloured card.
// The card height is flexible — it grows with its content.
struct RiddleCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
}
