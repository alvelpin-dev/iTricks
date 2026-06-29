import SwiftUI

/// Constantes tipográficas y de espaciado compartidas por toda la app,
/// inspiradas en las guías de Human Interface Guidelines de iOS 26.
enum Theme {
    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 12
        static let md: CGFloat = 20
        static let lg: CGFloat = 32
        static let xl: CGFloat = 48
    }

    enum Radius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 20
        static let large: CGFloat = 28
    }

    enum AnimationCurve {
        static let standard = Animation.spring(response: 0.45, dampingFraction: 0.85)
        static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.9)
        static let gentle = Animation.easeInOut(duration: 0.4)
    }

    enum Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title2, design: .rounded, weight: .semibold)
        static let headline = Font.system(.headline, design: .default, weight: .semibold)
        static let body = Font.system(.body, design: .default, weight: .regular)
        static let caption = Font.system(.caption, design: .default, weight: .medium)
    }
}
