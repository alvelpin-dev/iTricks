import SwiftUI

/// "Predicción con Siri" — Tecnología.
///
/// Método real: un Atajo de Siri personalizado (creado con la app gratuita
/// Atajos de Apple, fuera de iTricks) que asocia una frase concreta a una
/// respuesta de voz fija mediante la acción "Hablar texto". Cuando el mago
/// dice "Oye Siri, [frase]", el sistema operativo ejecuta el atajo y Siri
/// responde en voz alta con la predicción, sin que iTricks intervenga en
/// ese momento: la app solo sirve de guía de configuración y demo.
enum SiriPredictionEffect: EffectModule {
    static let info = EffectInfo(
        id: "siri_prediction",
        name: "Predicción con Siri",
        category: .technology,
        shortDescription: "El mago le pregunta algo a Siri en voz alta y Siri responde con la predicción exacta, como si supiera el futuro.",
        difficulty: .expert,
        preparationTime: .longSetup,
        symbol: "mic.circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "El espectador elige libremente algo (una carta, un número, una palabra de una lista corta). El mago le pregunta a Siri en voz alta, y Siri responde con la predicción exacta, como si la asistente realmente supiera lo que el espectador iba a elegir.",
            preparation: [
                "Abre la app Atajos de Apple (preinstalada en iOS, no es parte de iTricks) y crea un atajo nuevo.",
                "Añade la acción \"Hablar texto\" con el texto exacto de tu predicción (por ejemplo, \"El espectador eligió el siete de corazones\").",
                "En los ajustes del atajo, asígnale una frase de activación de Siri natural, como \"predicción mágica\" o \"qué va a pasar\".",
                "Practica decir la frase completa (\"Oye Siri, predicción mágica\") varias veces hasta que Siri la reconozca de forma fiable.",
                "Si el efecto requiere forzar la elección del espectador (carta, número), combina este efecto con uno de fuerza ya incluido en la app (Adivina cualquier carta, Calculadora mágica) para garantizar que la elección coincide con lo que grabaste en el atajo."
            ],
            performance: [
                "Fuerza o predetermina la elección del espectador usando otro efecto de la app como apoyo (carta forzada, número forzado).",
                "Pide al espectador que mire o sostenga tu teléfono o el suyo, y di en voz alta: \"Oye Siri, [tu frase de activación]\".",
                "Deja que Siri responda en voz alta con la predicción grabada de antemano.",
                "Reacciona con normalidad: para el público, Siri \"acaba de predecir\" la elección libre del espectador."
            ],
            script: [
                "\"Vamos a preguntarle a Siri qué has elegido, a ver si lo sabe.\"",
                "\"Oye Siri, predicción mágica.\"",
                "\"¿Lo ves? Siri ya lo sabía.\""
            ],
            recoveryTips: [
                "Si Siri no reconoce la frase a la primera, tenla siempre como pregunta corta y sin palabras ambiguas; pruébala muchas veces en distintos entornos de ruido antes de actuar.",
                "Ten un plan B: si Siri falla completamente, puedes mostrar el mismo texto como una nota \"enviada\" de antemano a otra persona, sin depender de Siri en ese momento."
            ],
            performanceTips: [
                "Usa este efecto como cierre de una rutina más larga donde ya forzaste la elección del espectador con otro método del repertorio.",
                "Practica la pregunta a Siri en el entorno real donde vas a actuar: el reconocimiento de voz varía con el ruido ambiente."
            ],
            variations: [
                "Configura varios atajos con frases distintas para predicciones distintas, y elige cuál usar según cómo se desarrolle la actuación.",
                "Usa un altavoz inteligente con el mismo asistente en vez del teléfono, para que el efecto no parezca depender de tu propio dispositivo."
            ],
            commonMistakes: [
                "No probar la frase de activación en el lugar real de la actuación, donde el ruido ambiente puede hacer que Siri no la reconozca.",
                "Olvidar que el atajo debe estar configurado en el dispositivo que se va a usar durante la actuación, no en otro."
            ],
            recommendedDuration: "2-3 minutos (más el cierre del efecto que use para forzar la elección)"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Crea el Atajo de Siri con la acción \"Hablar texto\" y tu predicción.",
                spectatorAction: "No participa en esta fase de preparación.",
                simulationNote: "Esta configuración ocurre antes de la actuación, en la app Atajos de Apple."
            ),
            PracticeStep(
                performerAction: "Fuerza la elección del espectador con otro efecto de la app.",
                spectatorAction: "Cree que elige libremente una carta, número o palabra.",
                simulationNote: "El forzado garantiza que la elección coincide con lo grabado en el atajo de Siri."
            ),
            PracticeStep(
                performerAction: "Pregunta a Siri en voz alta usando la frase de activación configurada.",
                spectatorAction: "Escucha a Siri responder con la predicción exacta.",
                simulationNote: "Siri ejecuta el atajo real configurado de antemano; no hay magia técnica adicional en ese instante."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(SiriPredictionPerformView()) }
    static func settingsView() -> AnyView { AnyView(SiriPredictionSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct SiriPredictionPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("siri_prediction_phrase") private var activationPhrase = "predicción mágica"
    @AppStorage("siri_prediction_text") private var predictionText = "El espectador eligió el siete de corazones"
    @State private var showingDemo = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: "mic.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.teal)

            VStack(spacing: Theme.Spacing.sm) {
                Text("Frase de activación configurada:")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
                Text("\"Oye Siri, \(activationPhrase)\"")
                    .font(Theme.Typography.headline)
                    .multilineTextAlignment(.center)
            }
            .padding(Theme.Spacing.md)
            .glassCardStyle()
            .padding(.horizontal, Theme.Spacing.md)

            if showingDemo {
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Siri diría:")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                    Text("\"\(predictionText)\"")
                        .font(Theme.Typography.body)
                        .italic()
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .transition(.opacity)
            }

            PrimaryButton("Simular respuesta de Siri", symbol: "waveform", tint: .teal) {
                withAnimation { showingDemo = true }
                HapticManager.shared.impact(.light)
            }
            .padding(.horizontal, Theme.Spacing.md)

            Text("Esta pantalla es solo una guía. El atajo real debe crearse en la app Atajos de Apple.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.md)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }
}

private struct SiriPredictionSettingsView: View {
    @AppStorage("siri_prediction_phrase") private var activationPhrase = "predicción mágica"
    @AppStorage("siri_prediction_text") private var predictionText = "El espectador eligió el siete de corazones"

    var body: some View {
        SecretConfigScreen(title: "Predicción con Siri") {
            Section("Frase de activación") {
                TextField("predicción mágica", text: $activationPhrase)
            }
            Section("Texto que dirá Siri") {
                TextField("El espectador eligió...", text: $predictionText)
            }
            Section {
                Text("Crea un Atajo en la app Atajos de Apple con la acción 'Hablar texto' usando exactamente este texto, y asígnale esta misma frase como activación de Siri. Esta pantalla de la app solo documenta y simula la configuración: la ejecución real ocurre dentro de Atajos/Siri, fuera de iTricks.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
