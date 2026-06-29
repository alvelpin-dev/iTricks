import SwiftUI

/// "El Dado Virtual Controlado" — Números.
///
/// Método real (integrado en la app): el estado de "No molestar" no es
/// legible por apps normales (no hay API pública para ello). En su
/// lugar, un triple toque oculto "arma" el resultado forzado para
/// exactamente un lanzamiento; tras usarlo, se desarma automáticamente,
/// así que no hay que recordar desactivar nada antes de entregar el
/// teléfono al espectador.
enum ControlledVirtualDiceEffect: EffectModule {
    static let info = EffectInfo(
        id: "controlled_virtual_dice",
        name: "El Dado Virtual Controlado",
        category: .numbers,
        shortDescription: "Un dado virtual. Cuando lo lanza el espectador sale al azar; cuando tú lo armas en secreto, aciertas tu predicción.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "die.face.6.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres el efecto y lanzas un dado virtual. El espectador intenta repetir el resultado: por mucho que lo lance él, sale un número al azar genuino. Pero cuando tú lo lanzas, armado en secreto, siempre sale el número que predijiste.",
            preparation: [
                "Anuncia o anota tu predicción antes de empezar a lanzar el dado tú mismo.",
                "Configura el número forzado en los ajustes secretos.",
                "Practica el triple toque que arma el lanzamiento forzado hasta poder hacerlo sin que se note."
            ],
            performance: [
                "Antes de tu lanzamiento, da un triple toque discreto en cualquier parte de la pantalla para armar el resultado forzado.",
                "Lanza el dado: el resultado coincidirá con tu predicción anunciada.",
                "El armado se consume automáticamente tras ese lanzamiento, así que no necesitas desactivar nada.",
                "Entrega el teléfono al espectador y deja que lance varias veces: el resultado será realmente aleatorio cada vez."
            ],
            script: [
                "\"He anotado un número del uno al seis antes de empezar.\"",
                "\"Voy a lanzar yo primero...\"",
                "\"Ahora intenta tú, a ver si tienes la misma suerte.\""
            ],
            recoveryTips: [
                "Si lanzas sin armar el resultado por error, simplemente preséntalo como un \"lanzamiento de calentamiento\" y repite, armando esta vez correctamente.",
                "El armado se desarma solo después de un lanzamiento, así que no hay riesgo de que el espectador también obtenga el número forzado por error."
            ],
            performanceTips: [
                "Deja que el espectador lance varias veces seguidas para que perciba claramente que el resultado cambia cada vez.",
                "Da el triple toque mientras hablas o gesticulas, nunca en silencio justo antes de lanzar."
            ],
            variations: [
                "Usa la misma estructura para forzar una carta o cualquier otro resultado, no solo un número de dado.",
                "Combínalo con la Calculadora tóxica digital para una rutina de \"control numérico\" más larga."
            ],
            commonMistakes: [
                "Olvidar armar el resultado antes de tu propio lanzamiento.",
                "Dar el triple toque de forma demasiado visible justo antes de lanzar."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Anuncia tu predicción y da un triple toque discreto para armar el resultado.",
                spectatorAction: "Escucha la predicción sin saber el método.",
                simulationNote: "El armado afecta solo al próximo lanzamiento, y se consume automáticamente tras usarlo."
            ),
            PracticeStep(
                performerAction: "Lanza el dado tú mismo, acertando siempre gracias al armado.",
                spectatorAction: "Ve que el resultado coincide exactamente con la predicción.",
                simulationNote: "El número forzado se muestra una sola vez; el siguiente lanzamiento ya es aleatorio."
            ),
            PracticeStep(
                performerAction: "Entrega el teléfono al espectador sin necesitar desactivar nada.",
                spectatorAction: "Lanza varias veces obteniendo resultados realmente aleatorios.",
                simulationNote: "El armado de un solo uso elimina el riesgo de dejarlo activado por error."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ControlledVirtualDicePerformView()) }
    static func settingsView() -> AnyView { AnyView(ControlledVirtualDiceSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct ControlledVirtualDicePerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("controlled_dice_forced_value") private var forcedValue = 6
    @State private var displayedValue = 1
    @State private var isArmed = false
    @State private var isRolling = false
    @State private var rollTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            Image(systemName: "die.face.\(displayedValue).fill")
                .font(.system(size: 110))
                .foregroundStyle(.blue)
                .rotation3DEffect(.degrees(isRolling ? 360 : 0), axis: (x: 1, y: 1, z: 0))
                .animation(isRolling ? .linear(duration: 0.4).repeatForever(autoreverses: false) : .default, value: isRolling)

            if isArmed {
                Label("Armado", systemImage: "checkmark.seal.fill")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.blue)
            }

            PrimaryButton("Lanzar", symbol: "die.face.5", tint: .blue) {
                roll()
            }
            .padding(.horizontal, Theme.Spacing.lg)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .onTapGesture(count: 3) {
            isArmed = true
            HapticManager.shared.impact(.rigid)
        }
        .onDisappear { rollTask?.cancel() }
    }

    private func roll() {
        guard !isRolling else { return }
        isRolling = true
        let wasArmed = isArmed
        isArmed = false
        HapticManager.shared.impact(.medium)

        rollTask = Task {
            for _ in 0..<10 {
                displayedValue = Int.random(in: 1...6)
                HapticManager.shared.impact(.light)
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
            displayedValue = wasArmed ? forcedValue : Int.random(in: 1...6)
            isRolling = false
            MagicEngine.performReveal()
        }
    }
}

private struct ControlledVirtualDiceSettingsView: View {
    @AppStorage("controlled_dice_forced_value") private var forcedValue = 6

    var body: some View {
        SecretConfigScreen(title: "El Dado Virtual Controlado") {
            Section("Número forzado") {
                Picker("Resultado al armar", selection: $forcedValue) {
                    ForEach(1...6, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
            }
            Section {
                Text("Toca tres veces en cualquier parte de la pantalla de actuación para armar el próximo lanzamiento. El armado se consume automáticamente tras un solo lanzamiento.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
