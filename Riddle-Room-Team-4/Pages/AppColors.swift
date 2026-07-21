import SwiftUI

enum AppColors {
    static let background = Color(red: 0.99, green: 0.965, blue: 0.94)
    static let ink = Color(red: 0.08, green: 0.10, blue: 0.31)
    static let purple = Color(red: 0.36, green: 0.22, blue: 0.72)
    static let panel = Color(red: 0.965, green: 0.94, blue: 0.98)
    static let orange = Color(red: 0.96, green: 0.61, blue: 0.08)
    static let green = Color(red: 0.22, green: 0.58, blue: 0.33)
    static let red = Color(red: 0.95, green: 0.33, blue: 0.22)
}

// MARK: - App-wide font scale environment key
// Set at root in ContentView; read in every page via @Environment(\.appFontScale).
struct AppFontScaleKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    var appFontScale: CGFloat {
        get { self[AppFontScaleKey.self] }
        set { self[AppFontScaleKey.self] = newValue }
    }
}
