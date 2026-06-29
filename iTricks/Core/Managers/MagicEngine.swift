import Foundation

/// Orquestador transversal que coordina los managers de bajo nivel
/// (haptics, sonido, sensores) para componer "momentos mágicos" reutilizables
/// por varios efectos, evitando que cada vista repita la misma coreografía.
struct MagicEngine {
    /// Coreografía estándar de revelación: vibración + sonido + posibilidad
    /// de animación en la vista llamante (la animación SwiftUI se dispara
    /// fuera de aquí, este método solo sincroniza el feedback físico).
    static func performReveal(sound: SoundManager.EffectSound = .reveal) {
        HapticManager.shared.magicReveal()
        SoundManager.shared.play(sound)
    }

    /// Coreografía de "tensión" antes de una revelación (usada mientras
    /// el espectador piensa en una carta, número o palabra).
    static func performBuildUp() {
        HapticManager.shared.impact(.light)
        SoundManager.shared.play(.whoosh, volume: 0.6)
    }

    /// Marca el inicio de una sesión de efecto: limpia estado de sensores
    /// previos y prepara el haptic engine para una respuesta inmediata.
    static func beginSession() {
        SensorManager.shared.stopAll()
    }

    /// Marca el final de una sesión de efecto, liberando sensores activos.
    static func endSession() {
        SensorManager.shared.stopAll()
        SoundManager.shared.stop()
    }
}
