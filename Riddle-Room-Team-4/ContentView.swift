//
//  ContentView.swift
//  Riddle-Room-Team-4
//
//  Root view — hosts the main tab navigation.
//  preferredColorScheme is applied here so it covers all tabs.
//


import SwiftUI

struct ContentView: View {

    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var userData: UserData

    var body: some View {
        Group {
            if !userData.isSetupComplete {
                SetupView()
            } else {
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
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .dynamicTypeSize(userData.dynamicTypeSize)
        .environment(\.appFontScale, CGFloat(userData.fontScale))
    }
}

#Preview {
    ContentView()
}
