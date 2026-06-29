import SwiftUI
import Combine

/// Detecta los gestos ocultos que solo el mago conoce para revelar
/// controles de configuración sin que el público los perciba.
/// Cada efecto puede usar uno o varios `SecretGesture` simultáneamente.
final class SecretInputManager: ObservableObject {
    enum SecretGesture {
        case tripleTap
        case longPress(minimumDuration: Double)
        case sequence(taps: Int, withinSeconds: Double)
    }

    /// Solo debe mutarse a través de `registerTap`/`registerLongPress`/`lock()`.
    /// No es `private(set)` porque SwiftUI necesita un `Binding` de doble vía
    /// para cerrar la sheet de configuración al deslizarla hacia abajo.
    @Published var isUnlocked = false

    private var tapTimestamps: [Date] = []
    private var lockTimer: Timer?

    /// Registra un toque para la detección de secuencia/triple toque.
    /// Llamar desde `onTapGesture` de una zona invisible de la pantalla.
    func registerTap(requiredTaps: Int = 3, window: Double = 1.2) {
        let now = Date()
        tapTimestamps.removeAll { now.timeIntervalSince($0) > window }
        tapTimestamps.append(now)

        if tapTimestamps.count >= requiredTaps {
            unlock()
            tapTimestamps.removeAll()
        }
    }

    /// Llamar desde un `onLongPressGesture` para revelar la configuración.
    func registerLongPress() {
        unlock()
    }

    private func unlock() {
        HapticManager.shared.impact(.rigid)
        withAnimation(.easeInOut(duration: 0.25)) {
            isUnlocked = true
        }
        scheduleAutoLock()
    }

    func lock() {
        lockTimer?.invalidate()
        withAnimation(.easeInOut(duration: 0.2)) {
            isUnlocked = false
        }
    }

    /// El acceso oculto se cierra solo tras un tiempo de inactividad para
    /// que nunca quede expuesto por accidente delante del público.
    private func scheduleAutoLock(after seconds: Double = 20) {
        lockTimer?.invalidate()
        lockTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            self?.lock()
        }
    }

    deinit {
        lockTimer?.invalidate()
    }
}

/// Modificador de vista que añade una zona de toque invisible para
/// desbloquear la configuración secreta de un efecto sin alterar el diseño visible.
struct SecretUnlockZone: ViewModifier {
    @ObservedObject var manager: SecretInputManager
    var requiredTaps: Int = 3

    func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 64, height: 64)
                .contentShape(Rectangle())
                .onTapGesture {
                    manager.registerTap(requiredTaps: requiredTaps)
                }
                .accessibilityHidden(true)
        }
    }
}

extension View {
    /// Añade una esquina superior derecha invisible que, al tocarla
    /// `requiredTaps` veces, desbloquea la configuración secreta del efecto.
    func secretUnlockZone(_ manager: SecretInputManager, requiredTaps: Int = 3) -> some View {
        modifier(SecretUnlockZone(manager: manager, requiredTaps: requiredTaps))
    }
}
