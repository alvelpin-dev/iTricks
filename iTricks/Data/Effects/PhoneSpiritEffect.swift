import SwiftUI

/// "Espíritu en el móvil" — Paranormal.
///
/// Método real: un motor de vibración pulsando en patrones asimétricos
/// hace que un teléfono apoyado sobre una superficie lisa se desplace
/// ("camine") por sí solo unos milímetros, un fenómeno físico real y bien
/// documentado. El mago programa el retardo antes de actuar, deja el
/// teléfono sobre la mesa y se aleja, de forma que el movimiento ocurre
/// sin que nadie lo esté tocando.
enum PhoneSpiritEffect: EffectModule {
    static let info = EffectInfo(
        id: "phone_spirit",
        name: "Espíritu en el móvil",
        category: .paranormal,
        shortDescription: "El teléfono, apoyado sobre la mesa y sin que nadie lo toque, empieza a vibrar y desplazarse solo.",
        difficulty: .intermediate,
        preparationTime: .seconds,
        symbol: "iphone.gen3.radiowaves.left.and.right",
        instructions: EffectInstructions(
            whatItDoes: "El mago coloca el teléfono sobre una mesa lisa y se aleja. Tras una pausa, el teléfono comienza a vibrar con un patrón que hace que se desplace ligeramente por la superficie, como si un espíritu lo empujara, sin que nadie lo esté tocando.",
            preparation: [
                "Elige una superficie lisa y dura (mesa de madera o cristal); sobre superficies blandas o con mucha fricción el desplazamiento no se aprecia.",
                "Practica antes el efecto a solas para comprobar cuántos milímetros se desplaza el teléfono con tu patrón de vibración y ajustar expectativas.",
                "Configura el retardo de inicio en los ajustes secretos antes de colocar el teléfono en la mesa."
            ],
            performance: [
                "Activa la cuenta atrás en los ajustes secretos antes de mostrar el teléfono.",
                "Coloca el teléfono sobre la mesa con naturalidad, en una posición y orientación concretas que recuerdes.",
                "Aléjate del teléfono y dirige la atención del público hacia otra cosa (una historia, una pregunta) durante la cuenta atrás.",
                "Cuando el patrón de vibración se active, el teléfono comenzará a vibrar y desplazarse visiblemente solo.",
                "Reacciona con sorpresa o aprovecha el momento para construir la narrativa paranormal de tu actuación."
            ],
            script: [
                "\"Dicen que este lugar tiene una energía especial. Vamos a comprobarlo.\"",
                "\"Voy a dejar el teléfono aquí, sin tocarlo, y vamos a esperar.\"",
                "\"¿Lo habéis visto? Se ha movido solo.\""
            ],
            recoveryTips: [
                "Si el teléfono no se desplaza lo suficiente, acércate y coméntalo como si la energía hubiera sido débil esta vez, sin romper el personaje.",
                "Ten siempre un plan B narrativo para los segundos de cuenta atrás en los que nada ocurre todavía."
            ],
            performanceTips: [
                "Cuanto más tiempo pase entre que sueltas el teléfono y el inicio de la vibración, más creíble resulta que nadie lo está controlando.",
                "Usa una superficie y orientación consistentes para que el desplazamiento sea siempre hacia el mismo lado y puedas anticiparlo."
            ],
            variations: [
                "Combínalo con una pregunta de sí/no: una vibración corta para sí, una larga para no, fingiendo comunicación con el espíritu.",
                "Usa el efecto como apertura de una rutina paranormal más larga, antes del Detector paranormal o el Móvil embrujado."
            ],
            commonMistakes: [
                "Quedarte demasiado cerca del teléfono cuando empieza a vibrar, lo que sugiere que lo estás controlando.",
                "Usar una superficie con demasiada fricción donde el desplazamiento no se aprecia."
            ],
            recommendedDuration: "1-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Configura la cuenta atrás en los ajustes secretos antes de mostrar el teléfono.",
                spectatorAction: "No ve nada todavía; el teléfono parece apagado o en reposo.",
                simulationNote: "El temporizador corre en segundo plano, invisible para el público."
            ),
            PracticeStep(
                performerAction: "Coloca el teléfono en la mesa y aléjate, dirigiendo la atención a otra parte.",
                spectatorAction: "Atiende a la narrativa del mago mientras el teléfono permanece quieto.",
                simulationNote: "El patrón de vibración asimétrico aún no se ha activado."
            ),
            PracticeStep(
                performerAction: "Deja que el patrón de vibración haga que el teléfono se desplace visiblemente.",
                spectatorAction: "Observa el teléfono moverse solo sobre la mesa.",
                simulationNote: "Las vibraciones asimétricas reales desplazan físicamente el dispositivo unos milímetros."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(PhoneSpiritPerformView()) }
    static func settingsView() -> AnyView { AnyView(PhoneSpiritSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct PhoneSpiritPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("phone_spirit_delay") private var delaySeconds = 8.0
    @State private var countdown: Int = 0
    @State private var isActive = false
    @State private var pulseTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: isActive ? "iphone.gen3.radiowaves.left.and.right" : "iphone.gen3")
                .font(.system(size: 72))
                .foregroundStyle(.indigo)
                .scaleEffect(isActive ? 1.1 : 1)
                .animation(Theme.AnimationCurve.snappy, value: isActive)

            if countdown > 0 {
                Text("\(countdown)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            } else {
                Text(isActive ? "Vibrando…" : "Pulsa Comenzar y coloca el teléfono")
                    .font(Theme.Typography.body)
                    .foregroundStyle(.secondary)
            }

            if countdown == 0 && !isActive {
                PrimaryButton("Comenzar cuenta atrás", symbol: "play.fill", tint: .indigo) {
                    startCountdown()
                }
                .padding(.horizontal, Theme.Spacing.md)
            }

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .onDisappear {
            pulseTask?.cancel()
            MagicEngine.endSession()
        }
    }

    private func startCountdown() {
        MagicEngine.beginSession()
        countdown = Int(delaySeconds)
        pulseTask = Task {
            while countdown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                countdown -= 1
            }
            isActive = true
            for _ in 0..<10 {
                HapticManager.shared.impact(.heavy)
                try? await Task.sleep(nanoseconds: 90_000_000)
                HapticManager.shared.impact(.rigid)
                try? await Task.sleep(nanoseconds: 220_000_000)
            }
            isActive = false
        }
    }
}

private struct PhoneSpiritSettingsView: View {
    @AppStorage("phone_spirit_delay") private var delaySeconds = 8.0

    var body: some View {
        SecretConfigScreen(title: "Espíritu en el móvil") {
            Section("Retardo antes de vibrar") {
                Slider(value: $delaySeconds, in: 3...30, step: 1)
                Text("\(Int(delaySeconds)) segundos")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Section {
                Text("El patrón alterna vibraciones fuertes y rígidas de forma asimétrica, lo que hace que el teléfono camine ligeramente sobre superficies lisas y duras. Cuanto más larga la secuencia, más se desplaza.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
