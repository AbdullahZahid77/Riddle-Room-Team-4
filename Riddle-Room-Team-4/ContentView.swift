//
//  ContentView.swift
//  Riddle-Room-Team-4
//
//  Root view — hosts the main tab navigation.
//  preferredColorScheme is applied here so it covers all tabs.
//


import SwiftUI

struct ContentView: View {

    // Shared with HomeView's dark mode toggle via @AppStorage
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            BrainCircleView()
                .tabItem {
                    Label("Brain Circle", systemImage: "brain.head.profile")
                }

            NotesPage()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
