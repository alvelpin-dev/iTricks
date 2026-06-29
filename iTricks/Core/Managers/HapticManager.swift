import UIKit

/// Punto único de acceso al Haptic Engine. Todos los efectos deben
/// disparar feedback a través de aquí en lugar de instanciar generadores
/// propios, para mantener una sensación consistente en toda la app.
final class HapticManager {
    static let shared = HapticManager()

    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let rigidGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    private init() {}

    enum Impact {
        case light, medium, heavy, rigid, soft
    }

    func impact(_ style: Impact) {
        let generator: UIImpactFeedbackGenerator
        switch style {
        case .light: generator = lightGenerator
        case .medium: generator = mediumGenerator
        case .heavy: generator = heavyGenerator
        case .rigid: generator = rigidGenerator
        case .soft: generator = softGenerator
        }
        generator.prepare()
        generator.impactOccurred()
    }

    func success() {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.success)
    }

    func warning() {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.warning)
    }

    func error() {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.error)
    }

    func selectionChanged() {
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }

    /// Secuencia de pulsos pensada para reforzar un "momento mágico" (la revelación).
    func magicReveal() {
        impact(.soft)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            self?.impact(.medium)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) { [weak self] in
            self?.success()
        }
    }
}
