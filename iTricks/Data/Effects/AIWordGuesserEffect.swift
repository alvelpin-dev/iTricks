import SwiftUI

/// "IA que adivina palabras" — Tecnología.
///
/// Presentado como un análisis de inteligencia artificial, el método real
/// es el mismo equívoco de cuatro opciones que usa `PredictionSealedEffect`,
/// aplicado aquí sobre una cuadrícula de palabras. Es una forma honesta de
/// lograr el efecto "adivina cualquier palabra" sin pretender una
/// capacidad de IA que la app no tiene: ninguna tecnología puede adivinar
/// libremente cualquier palabra pensada, así que se restringe la elección
/// a un conjunto reducido mediante una técnica de fuerza real.
enum AIWordGuesserEffect: EffectModule {
    static let info = EffectInfo(
        id: "ai_word_guesser",
        name: "IA que adivina palabras",
        category: .technology,
        shortDescription: "El espectador piensa una palabra de una lista y la elimina libremente hasta quedarse con una. La \"IA\" la adivina siempre.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "brain",
        instructions: EffectInstructions(
            whatItDoes: "Se muestran cuatro palabras en pantalla. El espectador, mediante un proceso de eliminación que la app presenta como análisis de inteligencia artificial, se queda con una sola palabra. La app la \"adivina\" porque, en realidad, el proceso de eliminación está diseñado para forzar siempre la misma.",
            preparation: [
                "Decide de antemano qué palabra de las cuatro va a ser la forzada, y configúrala en los ajustes secretos.",
                "Prepara una pequeña predicción física (escrita, sellada) con esa misma palabra para reforzar el efecto al final."
            ],
            performance: [
                "Presenta la app como un sistema de inteligencia artificial que analiza patrones de elección.",
                "Pide al espectador que mire las cuatro palabras y, sin decir nada, piense en cuál le atrae más.",
                "Sigue el asistente de equívoco en pantalla: te indicará exactamente qué decir según las elecciones del espectador.",
                "Cuando quede una sola palabra, revela tu predicción sellada o anuncia que la \"IA\" ya la había calculado de antemano."
            ],
            script: [
                "\"Esta inteligencia artificial ha analizado patrones de miles de personas eligiendo palabras.\"",
                "\"Señala dos de las cuatro palabras, las que prefieras.\"",
                "\"La IA ya sabía qué palabra te quedaría: la tengo escrita desde antes de empezar.\""
            ],
            recoveryTips: [
                "El procedimiento de equívoco es idéntico al de Predicción sellada: si te despistas, la app siempre muestra en pantalla la pregunta exacta que toca hacer.",
                "Si el espectador dice que no tiene ninguna preferencia clara, pídele que elija de forma instintiva; el método funciona igual."
            ],
            performanceTips: [
                "Apóyate en el lenguaje de inteligencia artificial (\"análisis de patrones\", \"modelo entrenado\") para justificar teatralmente el resultado.",
                "No repitas el efecto con las mismas cuatro palabras ante el mismo público."
            ],
            variations: [
                "Cambia las cuatro palabras por emociones, colores o nombres de personas, adaptando el guion de IA a cada contexto.",
                "Combínalo con Predicción sellada para una rutina de cierre con doble forzado coordinado."
            ],
            commonMistakes: [
                "Revelar la predicción antes de que el proceso de eliminación termine.",
                "Usar siempre las mismas cuatro palabras en distintas actuaciones para el mismo grupo de personas."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Configura la palabra forzada y prepara una predicción sellada física opcional.",
                spectatorAction: "No participa todavía.",
                simulationNote: "La palabra forzada está fijada en los ajustes secretos antes de empezar."
            ),
            PracticeStep(
                performerAction: "Sigue el asistente de equívoco según las elecciones del espectador.",
                spectatorAction: "Señala libremente entre las palabras mostradas en cada ronda.",
                simulationNote: "El algoritmo de equívoco garantiza que la palabra forzada sobrevive sin importar la elección."
            ),
            PracticeStep(
                performerAction: "Revela que la \"IA\" ya sabía el resultado.",
                spectatorAction: "Comprueba que la palabra final coincide con la predicción.",
                simulationNote: "La coincidencia está garantizada por el método de eliminación, no por análisis real de IA."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(AIWordGuesserPerformView()) }
    static func settingsView() -> AnyView { AnyView(AIWordGuesserSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct AIWordGuesserPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("ai_word_options") private var optionsRaw = "OCÉANO,MONTAÑA,LIBERTAD,TORMENTA"
    @AppStorage("ai_word_forced_index") private var forcedIndex = 0
    @State private var result: String?

    private var options: [String] {
        let parts = optionsRaw.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        return parts.count == 4 ? parts : ["OCÉANO", "MONTAÑA", "LIBERTAD", "TORMENTA"]
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: "brain")
                .font(.system(size: 40))
                .foregroundStyle(.purple)
            Text("Analizando patrón de elección…")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)

            if let result {
                VStack(spacing: Theme.Spacing.sm) {
                    Text("La IA predijo:")
                        .font(Theme.Typography.body)
                        .foregroundStyle(.secondary)
                    Text(result)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                }
                .transition(.opacity)
            } else {
                EquivoqueAssistantView(options: options, forcedIndex: min(forcedIndex, 3)) { value in
                    withAnimation(Theme.AnimationCurve.standard) { result = value }
                }
            }

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }
}

private struct AIWordGuesserSettingsView: View {
    @AppStorage("ai_word_options") private var optionsRaw = "OCÉANO,MONTAÑA,LIBERTAD,TORMENTA"
    @AppStorage("ai_word_forced_index") private var forcedIndex = 0

    var body: some View {
        SecretConfigScreen(title: "IA que adivina palabras") {
            Section("Las 4 palabras (separadas por comas)") {
                TextField("OCÉANO,MONTAÑA,LIBERTAD,TORMENTA", text: $optionsRaw)
            }
            Section("Palabra forzada") {
                Picker("Cuál se forzará", selection: $forcedIndex) {
                    ForEach(0..<4, id: \.self) { index in
                        Text("Posición \(index + 1)").tag(index)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section {
                Text("El proceso de eliminación en pantalla sigue el algoritmo de equívoco clásico: cualquiera que sea la elección del espectador, la palabra de la posición forzada siempre sobrevive.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
