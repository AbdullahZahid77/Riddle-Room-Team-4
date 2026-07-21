//
//  UserData.swift
//  Riddle-Room-Team-4
//

import SwiftUI
import Combine

// Tracks completion of the two daily riddles for one calendar day.
struct DayProgress: Codable {
    var dayRiddleDone: Bool = false
    var nightRiddleDone: Bool = false

    var bothDone: Bool { dayRiddleDone && nightRiddleDone }
}

class UserData: ObservableObject {

    @Published var username: String {
        didSet { UserDefaults.standard.set(username, forKey: "username") }
    }

    // Set to true once the user completes setup. Drives the ContentView gate.
    @Published var isSetupComplete: Bool {
        didSet { UserDefaults.standard.set(isSetupComplete, forKey: "setupComplete") }
    }

    // Daily progress keyed by date string "yyyy-MM-dd".
    @Published var progress: [String: DayProgress] = [:]

    private let progressKey = "riddleProgress"
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.isSetupComplete = UserDefaults.standard.bool(forKey: "setupComplete")
        loadProgress()
    }

    // MARK: - Date helpers

    var todayKey: String { formatter.string(from: Date()) }

    // MARK: - Mark completion

    func markDayRiddle(date: String = "", done: Bool = true) {
        let key = date.isEmpty ? todayKey : date
        var day = progress[key] ?? DayProgress()
        day.dayRiddleDone = done
        progress[key] = day
        saveProgress()
    }

    func markNightRiddle(date: String = "", done: Bool = true) {
        let key = date.isEmpty ? todayKey : date
        var day = progress[key] ?? DayProgress()
        day.nightRiddleDone = done
        progress[key] = day
        saveProgress()
    }

    // MARK: - Queries

    func dayProgress(for date: String = "") -> DayProgress {
        let key = date.isEmpty ? todayKey : date
        return progress[key] ?? DayProgress()
    }

    // Number of consecutive days (ending today or yesterday) where both riddles were done.
    var streakDays: Int {
        var streak = 0
        var date = Date()

        // If today isn't complete yet, start the streak check from yesterday.
        if !(progress[todayKey]?.bothDone ?? false) {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        }

        while true {
            let key = formatter.string(from: date)
            guard progress[key]?.bothDone == true else { break }
            streak += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        }

        return streak
    }

    // True for each Mon–Sun day of the current week where both riddles are done.
    var thisWeekCompletion: [Bool] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)  // 1=Sun...7=Sat
        let daysFromMonday = (weekday + 5) % 7                   // 0=Mon...6=Sun

        return (0..<7).map { i in
            guard i <= daysFromMonday else { return false }       // future days = not done
            let offset = i - daysFromMonday
            let date = calendar.date(byAdding: .day, value: offset, to: today) ?? today
            return progress[formatter.string(from: date)]?.bothDone ?? false
        }
    }

    // MARK: - Persistence

    private func loadProgress() {
        guard
            let data = UserDefaults.standard.data(forKey: progressKey),
            let decoded = try? JSONDecoder().decode([String: DayProgress].self, from: data)
        else { return }
        progress = decoded
    }

    private func saveProgress() {
        guard let encoded = try? JSONEncoder().encode(progress) else { return }
        UserDefaults.standard.set(encoded, forKey: progressKey)
    }
}
