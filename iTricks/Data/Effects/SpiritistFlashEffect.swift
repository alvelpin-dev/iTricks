import SwiftUI

/// "El Destello Espiritista" — Paranormal.
///
/// Método real (integrado en la app): los botones de volumen no son
/// interceptables por una app normal, así que el disparador real son
/// tres zonas táctiles ocultas (sí / no / no estoy seguro), cada una
/// controlando la linterna real del dispositivo (`SensorManager.setTorch`)
/// con un número de parpadeos configurable.
enum SpiritistFlashEffect: EffectModule {
    static let info = EffectInfo(
        id: "spiritist_flash",
        name: "El Destello Espiritista",
        category: .paranormal,
        shortDescription: "Haces preguntas al más allá. La linterna del teléfono parpadea una vez para sí, dos veces para no, y siempre acierta.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "flashlight.on.fill",
        instructions: EffectInstructions(
            whatItDoes: "Colocas el iPhone en el centro de la mesa con la linterna lista. Haces preguntas al \"más allá\". Si la respuesta es sí, la linterna parpadea una vez; si es no, parpadea dos veces. El teléfono responde correctamente a preguntas que el mago no podía saber.",
            preparation: [
                "Practica las tres zonas táctiles ocultas (izquierda = sí, centro = no, derecha = no estoy seguro) hasta poder activarlas sin mirar.",
                "Prepara de antemano las respuestas a las preguntas que vas a hacer, usando técnicas de mentalismo (información previa, lectura en frío, o un cómplice que te las transmita)."
            ],
            performance: [
                "Coloca el teléfono en el centro de la mesa, con la pantalla hacia abajo o la app abierta discretamente.",
                "Haz preguntas de sí/no al \"más allá\" sobre algo que ya sepas la respuesta por algún método de mentalismo.",
                "Toca discretamente la zona correspondiente a la respuesta que quieras dar.",
                "Deja que el público interprete los parpadeos reales de la linterna como una comunicación genuina con el más allá."
            ],
            script: [
                "\"Si hay alguien aquí con nosotros, que responda a través de la luz.\"",
                "\"Una vez para sí, dos veces para no.\"",
                "\"¿Puedes confirmarnos algo sobre esta persona?\""
            ],
            recoveryTips: [
                "Si te equivocas en el número de parpadeos, puedes recuperarlo diciendo que \"la energía es inestable\" y repitiendo la pregunta para una segunda confirmación.",
                "Practica el ritmo exacto de pulsaciones para que el número de parpadeos sea siempre nítido y no se confunda con un parpadeo accidental."
            ],
            performanceTips: [
                "El verdadero secreto está en cómo obtienes la información para responder las preguntas, no en el mecanismo del parpadeo: dedica tiempo a esa parte.",
                "Mantén las manos visiblemente alejadas del teléfono mientras parpadea, para reforzar que no lo estás tocando."
            ],
            variations: [
                "Usa un código de parpadeos más elaborado (por ejemplo, contar hasta un número) para preguntas de \"cuánto\" en vez de sí/no.",
                "Combínalo con El Mensaje del más allá para una rutina paranormal de cierre más larga."
            ],
            commonMistakes: [
                "Activar el disparador de forma visible, como mover demasiado el pie o las manos cerca del teléfono.",
                "Hacer preguntas cuya respuesta no puedas conocer por ningún método previo, dejando el resultado al azar."
            ],
            recommendedDuration: "3-5 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Coloca el teléfono en el centro de la mesa y formula una pregunta cuya respuesta ya conoces.",
                spectatorAction: "Hace o escucha la pregunta al 'más allá', sin saber que el mago ya tiene la respuesta.",
                simulationNote: "El verdadero método de obtención de información ocurre fuera del mecanismo del parpadeo."
            ),
            PracticeStep(
                performerAction: "Activa discretamente uno o dos parpadeos según la respuesta deseada.",
                spectatorAction: "Ve la linterna parpadear el número exacto de veces que corresponde a sí o no.",
                simulationNote: "La automatización por botón de volumen controla el número de parpadeos de la linterna."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(SpiritistFlashPerformView()) }
    static func settingsView() -> AnyView { AnyView(SpiritistFlashSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct SpiritistFlashPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("spiritist_flash_yes") private var flashesForYes = 1
    @AppStorage("spiritist_flash_no") private var flashesForNo = 2
    @AppStorage("spiritist_flash_unsure") private var flashesForUnsure = 3
    @State private var isFlashing = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()
                Image(systemName: isFlashing ? "flashlight.on.fill" : "flashlight.off.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(isFlashing ? .yellow : .secondary)
                Text("Toca una zona oculta: izquierda (sí), centro (no), derecha (no estoy seguro)")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.lg)
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(Theme.Spacing.lg)

            HStack(spacing: 0) {
                hiddenZone(count: flashesForYes)
                hiddenZone(count: flashesForNo)
                hiddenZone(count: flashesForUnsure)
            }
        }
        .onDisappear { sensors.setTorch(on: false) }
    }

    private func hiddenZone(count: Int) -> some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { flash(times: count) }
            .accessibilityHidden(true)
    }

    private func flash(times: Int) {
        guard !isFlashing else { return }
        isFlashing = true
        Task {
            for i in 0..<times {
                sensors.setTorch(on: true)
                HapticManager.shared.impact(.soft)
                try? await Task.sleep(nanoseconds: 250_000_000)
                sensors.setTorch(on: false)
                if i < times - 1 {
                    try? await Task.sleep(nanoseconds: 250_000_000)
                }
            }
            isFlashing = false
        }
    }
}

private struct SpiritistFlashSettingsView: View {
    @AppStorage("spiritist_flash_yes") private var flashesForYes = 1
    @AppStorage("spiritist_flash_no") private var flashesForNo = 2
    @AppStorage("spiritist_flash_unsure") private var flashesForUnsure = 3

    var body: some View {
        SecretConfigScreen(title: "El Destello Espiritista") {
            Section("Número de parpadeos") {
                Stepper("Sí: \(flashesForYes)", value: $flashesForYes, in: 1...5)
                Stepper("No: \(flashesForNo)", value: $flashesForNo, in: 1...5)
                Stepper("No estoy seguro: \(flashesForUnsure)", value: $flashesForUnsure, in: 1...5)
            }
            Section {
                Text("La pantalla de actuación se divide en tres zonas invisibles iguales (izquierda, centro, derecha) que controlan la linterna real del dispositivo con el número de parpadeos configurado aquí para cada respuesta.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
