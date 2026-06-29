import SwiftUI
import AVFoundation

/// "Siri la Psíquica" — Tecnología.
///
/// Método real (integrado en la app): en vez de depender de que el
/// sistema Siri reconozca una frase exacta, iTricks usa síntesis de voz
/// real (`AVSpeechSynthesizer`) para que el propio iPhone "hable" la
/// predicción con voz de sistema, disparado por un toque oculto. El
/// verdadero secreto sigue siendo el forzaje psicológico del color, no
/// la tecnología.
enum SiriThePsychicEffect: EffectModule {
    static let info = EffectInfo(
        id: "siri_the_psychic",
        name: "Siri la Psíquica",
        category: .technology,
        shortDescription: "Le preguntas a tu asistente en qué color piensa tu amigo. Responde en voz alta, y acierta.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "waveform.circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le preguntas en voz alta a tu asistente en qué color está pensando tu amigo. El teléfono responde de inmediato con voz hablada, acertando por completo el color exacto.",
            preparation: [
                "Escribe en la configuración secreta la frase exacta que el teléfono dirá en voz alta.",
                "Aprende y practica un forzaje psicológico de color (preguntas en cascada que casi siempre llevan a 'azul' como primera respuesta espontánea, o el color que prefieras forzar)."
            ],
            performance: [
                "Conduce al espectador con el forzaje psicológico hacia el color que ya tienes configurado.",
                "Saca el teléfono y di en voz alta tu pregunta a 'la psíquica', como si fuera Siri.",
                "Toca discretamente la zona oculta de la pantalla: el teléfono empezará a 'escuchar' (animación) y después hablará la predicción.",
                "Deja que la voz de sistema responda en voz alta, sin que tú digas nada más."
            ],
            script: [
                "\"Piensa en un color, cualquiera, rápido, sin pensarlo demasiado.\"",
                "\"Oye, asistente, ¿en qué color está pensando mi amigo?\"",
                "(voz de sistema) \"Está pensando en el color azul.\""
            ],
            recoveryTips: [
                "Si el forzaje no funciona y el espectador dice otro color, ten preparada una salida (\"vamos a intentarlo otra vez en un momento\") y repite el forzaje más adelante.",
                "Practica el toque oculto hasta poder activarlo sin mirar la pantalla, justo después de hacer la pregunta en voz alta."
            ],
            performanceTips: [
                "El verdadero secreto es el forzaje psicológico, no la tecnología: dedica más tiempo de práctica a este apartado que a la app.",
                "Deja una breve pausa de \"escucha\" antes de la respuesta hablada, para que parezca una reacción genuina y no una grabación."
            ],
            variations: [
                "Sustituye el color por un número del 1 al 10, usando técnicas de forzaje numérico equivalentes.",
                "Configura varias frases y colores distintos en sesiones diferentes para no repetir siempre lo mismo."
            ],
            commonMistakes: [
                "Tocar la zona oculta antes de terminar de decir la pregunta en voz alta, rompiendo la sincronización.",
                "No practicar suficiente el forzaje psicológico, dependiendo solo de la suerte."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce al espectador con un forzaje psicológico hacia el color predeterminado.",
                spectatorAction: "Cree elegir un color de forma completamente espontánea.",
                simulationNote: "El forzaje psicológico es la técnica real; la tecnología solo presenta el resultado."
            ),
            PracticeStep(
                performerAction: "Pregunta en voz alta y toca la zona oculta para activar la respuesta hablada.",
                spectatorAction: "Escucha al teléfono responder con el color exacto que pensó.",
                simulationNote: "AVSpeechSynthesizer lee en voz alta el texto configurado, con voz de sistema real."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(SiriThePsychicPerformView()) }
    static func settingsView() -> AnyView { AnyView(SiriThePsychicSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private final class SpeechController: NSObject, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        utterance.rate = 0.48
        synthesizer.speak(utterance)
    }
}

private struct SiriThePsychicPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("siri_psychic_response") private var responseText = "Está pensando en el color azul"
    @StateObject private var speech = SpeechController()
    @State private var isListening = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(isListening ? 0.25 : 0.12))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isListening ? 1.15 : 1)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isListening)
                Image(systemName: "waveform")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
            }

            Text(isListening ? "Escuchando…" : "Pregunta en voz alta")
                .font(Theme.Typography.headline)
                .foregroundStyle(.secondary)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .overlay(alignment: .bottomTrailing) {
            Color.clear
                .frame(width: 80, height: 80)
                .contentShape(Rectangle())
                .onTapGesture { trigger() }
                .accessibilityHidden(true)
        }
    }

    private func trigger() {
        guard !isListening else { return }
        isListening = true
        HapticManager.shared.impact(.light)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            isListening = false
            speech.speak(responseText)
        }
    }
}

private struct SiriThePsychicSettingsView: View {
    @AppStorage("siri_psychic_response") private var responseText = "Está pensando en el color azul"

    var body: some View {
        SecretConfigScreen(title: "Siri la Psíquica") {
            Section("Texto que se hablará en voz alta") {
                TextField("Está pensando en el color azul", text: $responseText)
            }
            Section {
                Text("Toca la esquina inferior derecha justo después de hacer tu pregunta en voz alta: el teléfono simula 'escuchar' un instante y luego lee el texto configurado con voz de sistema real.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
