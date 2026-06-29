import SwiftUI

/// "El Detector de Mentiras Háptico" — Paranormal.
///
/// Método real (integrado en la app): los botones de volumen no son
/// interceptables por una app normal en primer plano (no existe API
/// pública para ello), así que el disparador real son dos zonas táctiles
/// ocultas a los lados de la pantalla, donde el mago ya tiene los dedos
/// al sostener el teléfono. Mantener pulsada la zona de "mentira" genera
/// una vibración que aumenta de intensidad mientras se mantiene el toque.
enum HapticLieDetectorShortcutEffect: EffectModule {
    static let info = EffectInfo(
        id: "haptic_lie_detector_shortcut",
        name: "El Detector de Mentiras Háptico",
        category: .paranormal,
        shortDescription: "Sostienes el teléfono por los lados. Cuando el espectador miente, vibra cada vez más fuerte.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "hand.raised.brakesignal",
        instructions: EffectInstructions(
            whatItDoes: "Le pides al espectador que diga tres afirmaciones, dos verdaderas y una mentira. Sostienes el iPhone por los lados y, cuando dice la mentira, el teléfono empieza a vibrar, con una intensidad que crece mientras mantienes el dedo presionado, delatándolo.",
            preparation: [
                "Practica sostener el teléfono por los lados con los dedos sobre las zonas ocultas (mitad izquierda y derecha de la pantalla, por debajo de la mitad), sin que se note ningún movimiento especial.",
                "Ensaya mantener pulsado discretamente con un dedo mientras sostienes el teléfono con normalidad con el resto de la mano."
            ],
            performance: [
                "Pide al espectador tres afirmaciones, dos verdaderas y una falsa, sin decirte cuál es la mentira.",
                "Sostén el teléfono por los lados con ambas manos, con un dedo apoyado sobre la zona oculta de cada lado.",
                "Mientras dice la afirmación que tú decidas marcar como mentira, presiona y mantén pulsada esa zona: la vibración crecerá progresivamente.",
                "Suelta cuando consideres que la intensidad ha sido suficientemente dramática."
            ],
            script: [
                "\"Dime tres cosas sobre ti: dos verdaderas y una mentira, en el orden que quieras.\"",
                "\"Voy a sostener el teléfono así, sujeto por los lados, sin tocar la pantalla.\"",
                "\"Ahí... ha vibrado en la segunda. Esa es la mentira.\""
            ],
            recoveryTips: [
                "Si presionas la zona equivocada por error, suelta enseguida y deja que la vibración pare; puedes recuperarlo diciendo que el teléfono a veces detecta \"dudas\" además de mentiras directas.",
                "Practica con el teléfono en silencio (sin sonido de feedback) para que solo se perciba la vibración, nunca un sonido que delate el toque."
            ],
            performanceTips: [
                "No mires tus propias manos mientras presionas; mantén la mirada en el espectador para no delatar el gesto.",
                "Deja que la intensidad crezca progresivamente en vez de disparar la vibración máxima de golpe: se siente más genuino."
            ],
            variations: [
                "Usa el mismo método para un juego de \"sí o no\" con preguntas directas en vez de afirmaciones.",
                "Combínalo con el Detector de mentiras (basado en micrófono) para una rutina de \"doble verificación\" más elaborada."
            ],
            commonMistakes: [
                "Sujetar el teléfono de forma rígida o forzada, lo que hace evidente que estás manipulando algo con los dedos.",
                "Disparar la vibración demasiado rápido tras la afirmación, sin dar sensación de \"análisis\"."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Sostén el teléfono por los lados, con un dedo sobre cada zona oculta.",
                spectatorAction: "Dice tres afirmaciones, dos verdaderas y una falsa.",
                simulationNote: "Solo la zona de 'mentira' que tú decidas activar genera vibración; la otra no hace nada."
            ),
            PracticeStep(
                performerAction: "Mantén pulsada la zona elegida durante la afirmación que decidas marcar como mentira.",
                spectatorAction: "Siente o ve vibrar el teléfono, con intensidad creciente, justo en esa afirmación.",
                simulationNote: "Tú controlas el resultado por completo; no hay análisis real de veracidad."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(HapticLieDetectorPerformView()) }
    static func settingsView() -> AnyView { AnyView(HapticLieDetectorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct HapticLieDetectorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPressing = false
    @State private var rampTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()
                Image(systemName: isPressing ? "waveform.path.ecg.rectangle.fill" : "hand.raised.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(isPressing ? .red : .indigo)
                Text(isPressing ? "Detectando…" : "Sostén el teléfono por los lados")
                    .font(Theme.Typography.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(Theme.Spacing.lg)

            HStack(spacing: 0) {
                lieZone
                Color.clear
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .accessibilityHidden(true)
            }
        }
    }

    private var lieZone: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                pressing ? startRamp() : stopRamp()
            }, perform: {})
            .accessibilityHidden(true)
    }

    private func startRamp() {
        guard !isPressing else { return }
        isPressing = true
        rampTask = Task {
            var interval: UInt64 = 350_000_000
            while !Task.isCancelled {
                HapticManager.shared.impact(.heavy)
                try? await Task.sleep(nanoseconds: interval)
                interval = max(80_000_000, interval - 40_000_000)
            }
        }
    }

    private func stopRamp() {
        isPressing = false
        rampTask?.cancel()
        rampTask = nil
    }
}

private struct HapticLieDetectorSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "Detector de Mentiras Háptico") {
            Section {
                Text("La pantalla se divide en dos mitades invisibles: la izquierda es la zona de 'mentira' (mantener pulsada genera vibración creciente), la derecha no hace nada. Sostén el teléfono con un dedo de cada mano sobre cada mitad para activarla sin que se note.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
