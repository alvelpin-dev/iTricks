import SwiftUI

/// "Predicción sellada" — Mentalismo.
///
/// Método real: equívoco (magician's choice) sobre 4 sobres o papeles
/// sellados. El espectador cree elegir libremente uno, pero la técnica de
/// eliminación en dos rondas garantiza que siempre queda el sobre que el
/// mago predijo de antemano. Ver `EquivoqueAssistantView` para el algoritmo.
enum PredictionSealedEffect: EffectModule {
    static let info = EffectInfo(
        id: "prediction_sealed",
        name: "Predicción sellada",
        category: .mentalism,
        shortDescription: "Cuatro sobres sellados. El espectador elimina libremente hasta quedarse con uno solo: siempre el predicho.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "envelope.fill",
        instructions: EffectInstructions(
            whatItDoes: "Se muestran cuatro sobres (o papeles) sellados sobre la mesa. El espectador, mediante un proceso de eliminación que parece completamente libre, se queda con un único sobre. Al abrirlo, su contenido coincide con una predicción que el mago hizo público desde el principio.",
            preparation: [
                "Escribe el mismo contenido (una carta, un número o una palabra) dentro de los cuatro sobres. Como todos contienen lo mismo, el que sobreviva siempre será 'correcto'.",
                "Numera mentalmente los sobres de izquierda a derecha para poder seguir el algoritmo de eliminación sin confusión.",
                "Aprende de memoria el guion de la app antes de actuar; la naturalidad del lenguaje es lo que vende el efecto."
            ],
            performance: [
                "Coloca los cuatro sobres en fila y anuncia que cada uno contiene una predicción distinta, aunque en realidad las cuatro sean iguales.",
                "Abre la app y sigue el asistente de equívoco: te indicará exactamente qué decir según lo que el espectador señale en cada ronda.",
                "Pide al espectador que señale libremente dos sobres en la primera ronda.",
                "Sigue la instrucción que te da la app (eliminar los señalados o los no señalados) sin dudar.",
                "Repite con los dos sobres restantes: pide que señale uno y sigue la instrucción final de la app.",
                "Abre el único sobre superviviente y revela que coincide con tu predicción."
            ],
            script: [
                "\"Aquí tengo cuatro predicciones distintas, cada una en su propio sobre sellado.\"",
                "\"Señala dos de los cuatro sobres, los que tú quieras.\"",
                "\"Vamos a ir eliminando hasta quedarnos con uno solo: el que de verdad escogiste.\""
            ],
            recoveryTips: [
                "Si el espectador señala indecisamente o cambia de opinión, espera a que se decida antes de tocar nada en la app: el algoritmo solo necesita la elección final.",
                "Si dudas en qué fase del proceso estás, la app siempre muestra en pantalla la pregunta exacta que debes hacer a continuación."
            ],
            performanceTips: [
                "No expliques el proceso de eliminación de antemano: preséntalo como una serie de decisiones espontáneas, no como un procedimiento con reglas.",
                "Habla con la misma seguridad sin importar qué haya señalado el espectador; el lenguaje del mago, no el azar, controla el resultado."
            ],
            variations: [
                "En vez de sobres, usa cuatro papeles doblados o cuatro tarjetas boca abajo con dibujos distintos en el reverso.",
                "Sustituye la predicción escrita por un objeto idéntico repetido en los cuatro contenedores (cuatro relojes parados a la misma hora, por ejemplo)."
            ],
            commonMistakes: [
                "Anunciar las reglas del proceso de eliminación antes de empezar, lo que delata que existe un patrón.",
                "Vacilar al dar la instrucción de eliminación, lo que genera sospecha de que se está improvisando sobre la marcha."
            ],
            recommendedDuration: "3-5 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Prepara los cuatro sobres con el mismo contenido dentro.",
                spectatorAction: "No participa todavía; solo ve cuatro sobres sellados distintos por fuera.",
                simulationNote: "Como el contenido es idéntico en los cuatro, el resultado está garantizado sin importar cuál sobreviva."
            ),
            PracticeStep(
                performerAction: "Pide que señale dos sobres y sigue la instrucción de eliminación que da la app.",
                spectatorAction: "Señala libremente dos de los cuatro sobres.",
                simulationNote: "El algoritmo de equívoco asegura que el sobre forzado sobrevive a esta ronda sin importar la elección."
            ),
            PracticeStep(
                performerAction: "Repite con los dos sobres restantes hasta quedarte con uno.",
                spectatorAction: "Señala uno de los dos sobres restantes.",
                simulationNote: "La segunda ronda del equívoco deja siempre el sobre forzado como único superviviente."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(PredictionSealedPerformView()) }
    static func settingsView() -> AnyView { AnyView(PredictionSealedSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct PredictionSealedPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("prediction_sealed_label") private var sealedLabel = "AS DE CORAZONES"
    @State private var finished: String?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            if let finished {
                VStack(spacing: Theme.Spacing.md) {
                    Text("Abre el sobre superviviente")
                        .font(Theme.Typography.title)
                    Text(finished)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    Text("Coincide con tu predicción sellada: \(sealedLabel)")
                        .font(Theme.Typography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .transition(.opacity)
            } else {
                EquivoqueAssistantView(
                    options: ["Sobre 1", "Sobre 2", "Sobre 3", "Sobre 4"],
                    forcedIndex: 0
                ) { result in
                    withAnimation(Theme.AnimationCurve.standard) { finished = result }
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

private struct PredictionSealedSettingsView: View {
    @AppStorage("prediction_sealed_label") private var sealedLabel = "AS DE CORAZONES"

    var body: some View {
        SecretConfigScreen(title: "Predicción sellada") {
            Section("Contenido escrito en los 4 sobres") {
                TextField("Ej. AS DE CORAZONES", text: $sealedLabel)
            }
            Section {
                Text("Escribe físicamente este mismo contenido en los cuatro sobres antes de actuar. El equívoco garantiza que el sobre superviviente sea indistinguible de los demás para el espectador, así que cualquiera de los cuatro sirve.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
