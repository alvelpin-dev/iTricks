import SwiftUI

/// Paso individual de una práctica guiada.
struct PracticeStep: Identifiable {
    let id = UUID()
    /// Lo que debe hacer el mago en este paso.
    let performerAction: String
    /// Lo que está experimentando o haciendo el espectador.
    let spectatorAction: String
    /// Descripción de cómo se simula el resultado en modo práctica.
    let simulationNote: String
}

/// Información estática y descriptiva de un efecto. Es el "qué es",
/// independiente de cómo se renderiza o ejecuta (eso lo aporta `EffectModule`).
struct EffectInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let category: EffectCategory
    let shortDescription: String
    let difficulty: DifficultyLevel
    let preparationTime: PreparationTime
    let symbol: String
    let instructions: EffectInstructions
    let practiceSteps: [PracticeStep]

    static func == (lhs: EffectInfo, rhs: EffectInfo) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Protocolo que debe implementar cada efecto nuevo. Mantiene la metadata
/// (`EffectInfo`) desacoplada de las vistas concretas, de forma que añadir
/// un efecto nuevo solo requiere crear un tipo que lo implemente y
/// registrarlo en `EffectRepository`.
protocol EffectModule {
    /// Metadata mostrada en listas, detalle e instrucciones.
    static var info: EffectInfo { get }

    /// Vista principal que ve el mago al pulsar "Comenzar" (modo actuación real).
    static func performView() -> AnyView

    /// Vista de configuración secreta del efecto (parámetros que solo el mago ajusta).
    static func settingsView() -> AnyView

    /// Vista de modo práctica paso a paso.
    static func practiceView() -> AnyView
}

/// Envoltorio que erasura el tipo de un `EffectModule` para poder almacenarlos
/// homogéneamente en `EffectRepository` sin generics.
struct EffectDescriptor: Identifiable {
    let info: EffectInfo
    let performView: () -> AnyView
    let settingsView: () -> AnyView
    let practiceView: () -> AnyView

    var id: String { info.id }

    init<M: EffectModule>(_ module: M.Type) {
        self.info = module.info
        self.performView = module.performView
        self.settingsView = module.settingsView
        self.practiceView = module.practiceView
    }
}
