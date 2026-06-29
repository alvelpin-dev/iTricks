import Foundation

/// Contenido íntegro de la pantalla de instrucciones de un efecto.
/// Todo el texto debe ser real y específico del efecto, nunca relleno genérico.
struct EffectInstructions: Equatable {
    /// Qué ve y experimenta el espectador.
    let whatItDoes: String
    /// Pasos de preparación previa a la actuación.
    let preparation: [String]
    /// Pasos de ejecución durante la actuación.
    let performance: [String]
    /// Frases o guion orientativo a decir durante el efecto.
    let script: [String]
    /// Qué hacer si algo falla a mitad de la actuación.
    let recoveryTips: [String]
    /// Consejos de presentación y actuación.
    let performanceTips: [String]
    /// Variaciones o finales alternativos del efecto.
    let variations: [String]
    /// Errores comunes que cometen los magos al aprender el efecto.
    let commonMistakes: [String]
    /// Duración recomendada de la actuación completa.
    let recommendedDuration: String
}
