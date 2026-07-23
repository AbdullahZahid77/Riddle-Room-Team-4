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

                }
            }
        }
        .dynamicTypeSize(userData.dynamicTypeSize)
        .environment(\.appFontScale, CGFloat(userData.fontScale))
        .onAppear {
            SoundManager.shared.startMusic()
            SoundManager.shared.setMusicMuted(userData.isMusicMuted)
            SoundManager.shared.setSFXVolume(userData.sfxVolume)
            SoundManager.shared.setMusicVolume(userData.musicVolume)
            SoundManager.shared.installWindowTapSound()
        }
        .onChange(of: userData.isMusicMuted) { _, muted in
            SoundManager.shared.setMusicMuted(muted)
        }
        .onChange(of: userData.sfxVolume) { _, vol in
            SoundManager.shared.setSFXVolume(vol)
        }
        .onChange(of: userData.musicVolume) { _, vol in
            SoundManager.shared.setMusicVolume(vol)
        }
    }
}

#Preview {
    ContentView()
}
