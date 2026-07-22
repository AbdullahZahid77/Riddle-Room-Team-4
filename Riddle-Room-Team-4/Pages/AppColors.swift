import SwiftUI
import UIKit

enum AppColors {
    // Adaptive — automatically switch between light and dark
    static let background = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.07, green: 0.06, blue: 0.12, alpha: 1)   // dark
            : UIColor(red: 0.945, green: 0.894, blue: 0.835, alpha: 1) // F1E4D5
    })
    static let panel = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.09, blue: 0.19, alpha: 1)   // dark
            : UIColor(red: 1.0, green: 0.969, blue: 0.929, alpha: 1)  // FFF7ED
    })
    static let ink = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.98, green: 0.94, blue: 0.89, alpha: 1)   // dark
            : UIColor(red: 0.08, green: 0.10, blue: 0.31, alpha: 1)   // light
    })

    // Fixed accent colours — same in both modes
    static let purple    = Color(red: 0.282, green: 0.212, blue: 0.486)  // 48367C
    static let deepPurple = Color(red: 0.18, green: 0.12, blue: 0.38)
    static let orange    = Color(red: 0.96, green: 0.61, blue: 0.08)
    static let green     = Color(red: 0.22, green: 0.58, blue: 0.33)
    static let red       = Color(red: 0.95, green: 0.33, blue: 0.22)
    static let darkRed   = Color(red: 0.55, green: 0.12, blue: 0.10)

    // Legacy named dark colours (kept for any remaining direct references)
    static let darkBackground = Color(red: 0.07, green: 0.06, blue: 0.12)
    static let darkPanel      = Color(red: 0.12, green: 0.09, blue: 0.19)
    static let darkInk        = Color(red: 0.98, green: 0.94, blue: 0.89)
    static let darkMuted      = Color(red: 0.78, green: 0.73, blue: 0.82)
    static let darkAccent     = Color(red: 0.72, green: 0.65, blue: 1.0)
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
