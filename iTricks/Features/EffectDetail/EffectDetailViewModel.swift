import SwiftUI
import Combine

@MainActor
final class EffectDetailViewModel: ObservableObject {
    let info: EffectInfo
    private let descriptor: EffectDescriptor

    @Published var showPerformance = false
    @Published var showInstructions = false
    @Published var showPractice = false
    @Published var showSettings = false

    init(info: EffectInfo) {
        self.info = info
        guard let descriptor = EffectRepository.shared.descriptor(for: info.id) else {
            fatalError("Efecto no registrado en EffectRepository: \(info.id)")
        }
        self.descriptor = descriptor
    }

    func performView() -> AnyView { descriptor.performView() }
    func practiceView() -> AnyView { descriptor.practiceView() }
    func settingsView() -> AnyView { descriptor.settingsView() }

    /// Reinicio rápido: reconstruye el estado del efecto para encadenar
    /// otra actuación sin salir de la pantalla.
    func quickReset() {
        MagicEngine.endSession()
        HapticManager.shared.impact(.light)
        showPerformance = false
    }
}
