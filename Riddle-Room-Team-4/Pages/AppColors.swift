import SwiftUI

enum AppColors {
    static let background = Color(red: 0.945, green: 0.894, blue: 0.835)  // F1E4D5
    static let ink = Color(red: 0.08, green: 0.10, blue: 0.31)
    static let purple = Color(red: 0.282, green: 0.212, blue: 0.486)    // 48367C
    static let panel = Color(red: 1.0, green: 0.969, blue: 0.929)       // FFF7ED
    static let orange = Color(red: 0.96, green: 0.61, blue: 0.08)
    static let green = Color(red: 0.22, green: 0.58, blue: 0.33)
    static let red = Color(red: 0.95, green: 0.33, blue: 0.22)
    static let darkRed = Color(red: 0.55, green: 0.12, blue: 0.10)
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
