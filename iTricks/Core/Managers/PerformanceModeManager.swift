import SwiftUI

/// Estado global de "Modo Actuación". Cuando está activo, toda la app
/// oculta botones de configuración, ayudas y controles secretos para que
/// la experiencia sea indistinguible de una aplicación normal delante del público.
final class PerformanceModeManager: ObservableObject {
    static let shared = PerformanceModeManager()

    @Published private(set) var isActive = false

    private init() {}

    func enable() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isActive = true
        }
        HapticManager.shared.impact(.soft)
    }

    func disable() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isActive = false
        }
        HapticManager.shared.impact(.light)
    }

    func toggle() {
        isActive ? disable() : enable()
    }
}
