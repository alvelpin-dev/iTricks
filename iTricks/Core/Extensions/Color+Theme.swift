import SwiftUI

extension Color {
    /// Fondo primario adaptable a Light/Dark Mode, ligeramente distinto del
    /// blanco/negro puro para reducir el contraste agresivo en pantallas OLED.
    static let appBackground = Color(uiColor: .systemBackground)
    static let appSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let appGroupedBackground = Color(uiColor: .systemGroupedBackground)
    static let appLabel = Color(uiColor: .label)
    static let appSecondaryLabel = Color(uiColor: .secondaryLabel)
    static let appSeparator = Color(uiColor: .separator)
}
