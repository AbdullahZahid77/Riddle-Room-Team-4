//
//  Riddle_Room_Team_4App.swift
//  Riddle-Room-Team-4
//
//  Created by Abdullah Zahid on 20/7/2026.
//

import SwiftUI
import SwiftData

@main
struct Riddle_Room_Team_4App: App {
    @StateObject private var userData = UserData()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
        }
        .modelContainer(sharedModelContainer)
    }
}
