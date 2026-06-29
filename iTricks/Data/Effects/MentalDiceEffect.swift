import SwiftUI

/// "Dado mental" — Números.
///
/// Método real: el espectador "lanza" el dado zarandeando físicamente el
/// teléfono (gesto real detectado por el acelerómetro), pero la cara que
/// se muestra al final está fijada de antemano por el mago en la
/// configuración secreta. El zarandeo real hace que el resultado se
/// sienta genuino, mientras el resultado en sí está completamente controlado.
enum MentalDiceEffect: EffectModule {
    static let info = EffectInfo(
        id: "mental_dice",
        name: "Dado mental",
        category: .numbers,
        shortDescription: "El espectador zarandea el teléfono para lanzar un dado virtual. Siempre cae en el número que el mago predijo.",
        difficulty: .beginner,
        preparationTime: .seconds,
        symbol: "die.face.5.fill",
        instructions: EffectInstructions(
            whatItDoes: "El espectador sujeta el teléfono y lo zarandea físicamente para \"lanzar\" un dado virtual en pantalla. El resultado final, aunque parece depender de la fuerza y el momento del zarandeo, siempre coincide con un número que el mago anunció o escribió de antemano.",
            preparation: [
                "Antes de la actuación, anuncia o escribe el número que va a salir (por ejemplo, en una pizarra o nota cerrada).",
                "Ajusta en la configuración secreta el número exacto que quieres forzar."
            ],
            performance: [
                "Anuncia el número predicho antes de entregar el teléfono, o muéstralo escrito y tapado.",
                "Entrega el teléfono al espectador y pídele que lo zarandee con fuerza, como si lanzara un dado de verdad.",
                "Deja que la animación del dado ruede con varias caras antes de detenerse en el número forzado.",
                "Revela tu predicción y compárala con el resultado: deben coincidir exactamente."
            ],
            script: [
                "\"He anotado un número del uno al seis antes de empezar.\"",
                "\"Zarandea el teléfono como si lanzaras un dado de verdad, con la fuerza que quieras.\"",
                "\"Veamos en qué número se ha detenido… y comprobemos mi predicción.\""
            ],
            recoveryTips: [
                "Si el espectador zarandea muy suave y no se detecta movimiento, pídele que lo haga con más energía; el dado no rueda hasta detectar un zarandeo real.",
                "Si zarandea durante mucho tiempo, no pasa nada: el dado seguirá rodando visualmente hasta que decidas detenerlo en el número forzado."
            ],
            performanceTips: [
                "Deja que el dado ruede varios segundos mostrando caras distintas antes de aterrizar en la forzada, para que parezca verdaderamente aleatorio.",
                "Revela tu predicción ANTES de mostrar el resultado final en pantalla para maximizar el efecto."
            ],
            variations: [
                "Usa dos \"lanzamientos\" de dado y suma los resultados, forzando ambos números para que la suma coincida con tu predicción.",
                "Preséntalo como una prueba de telequinesis: el espectador debe \"concentrarse\" en un número antes de zarandear."
            ],
            commonMistakes: [
                "Revelar el resultado en pantalla antes de mostrar tu predicción escrita.",
                "Forzar siempre el mismo número en actuaciones consecutivas para el mismo público."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Anuncia o escribe tu predicción antes de empezar.",
                spectatorAction: "Ve la predicción sellada o escuchada, sin saber el método.",
                simulationNote: "El número que aparecerá está fijado en la configuración secreta del efecto."
            ),
            PracticeStep(
                performerAction: "Entrega el teléfono y pide que lo zarandee con fuerza.",
                spectatorAction: "Zarandea físicamente el teléfono como si lanzara un dado real.",
                simulationNote: "El acelerómetro detecta el zarandeo real, que activa la animación de rodado del dado."
            ),
            PracticeStep(
                performerAction: "Detén la animación en el número forzado y compara con tu predicción.",
                spectatorAction: "Comprueba que el resultado coincide exactamente con lo predicho.",
                simulationNote: "El resultado final no depende del zarandeo, solo su duración visual lo hace."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MentalDicePerformView()) }
    static func settingsView() -> AnyView { AnyView(MentalDiceSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct MentalDicePerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("mental_dice_forced_value") private var forcedValue = 6
    @State private var displayedValue = 1
    @State private var isRolling = false
    @State private var rollTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            Image(systemName: "die.face.\(displayedValue).fill")
                .font(.system(size: 120))
                .foregroundStyle(.blue)
                .rotation3DEffect(.degrees(isRolling ? 360 : 0), axis: (x: 1, y: 1, z: 0))
                .animation(isRolling ? .linear(duration: 0.4).repeatForever(autoreverses: false) : .default, value: isRolling)

            Text(isRolling ? "Rodando…" : "Zarandea el teléfono con fuerza")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .onAppear {
            MagicEngine.beginSession()
            sensors.startMotionUpdates()
        }
        .onChange(of: sensors.shakeDetected) { detected in
            if detected, !isRolling { startRoll() }
        }
        .onDisappear {
            rollTask?.cancel()
            MagicEngine.endSession()
        }
    }

    private func startRoll() {
        isRolling = true
        HapticManager.shared.impact(.medium)
        rollTask = Task {
            for _ in 0..<12 {
                displayedValue = Int.random(in: 1...6)
                HapticManager.shared.impact(.light)
                try? await Task.sleep(nanoseconds: 120_000_000)
            }
            displayedValue = forcedValue
            isRolling = false
            MagicEngine.performReveal()
        }
    }
}

private struct MentalDiceSettingsView: View {
    @AppStorage("mental_dice_forced_value") private var forcedValue = 6

    var body: some View {
        SecretConfigScreen(title: "Dado mental") {
            Section("Número forzado") {
                Picker("Resultado final", selection: $forcedValue) {
                    ForEach(1...6, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section {
                Text("El zarandeo real del espectador activa la animación, pero el dado siempre termina en el número configurado aquí, sin importar la fuerza o duración del zarandeo.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
