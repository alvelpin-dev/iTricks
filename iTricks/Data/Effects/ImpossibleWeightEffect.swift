import SwiftUI

/// "El Peso Digital Imposible" — Herramientas.
///
/// El iPhone 11 no tiene ningún sensor capaz de pesar objetos reales.
/// Esta vista (integrada en la app, sin Atajos) presenta una báscula
/// simulada con un selector de zona visible: el "peso" mostrado depende
/// por completo de qué zona se indique antes de colocar el objeto, no de
/// ninguna medición física genuina.
enum ImpossibleWeightEffect: EffectModule {
    static let info = EffectInfo(
        id: "impossible_weight",
        name: "El Peso Digital Imposible",
        category: .tools,
        shortDescription: "Tu iPhone se convierte en una báscula de precisión. Cuando tú pesas un objeto, siempre acierta su peso real.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "scalemass.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres una supuesta aplicación que convierte la pantalla de tu iPhone en una báscula de alta precisión. Colocas un objeto pequeño y la pantalla muestra el peso exacto en gramos. Cuando un espectador coloca el mismo objeto, el peso mostrado cambia drásticamente.",
            preparation: [
                "Pesa de antemano el objeto que vas a usar (una llave, una moneda) en una báscula real, y memoriza su peso exacto.",
                "Configura el atajo descrito en los ajustes secretos, que pregunta en qué zona de la pantalla se coloca el objeto antes de mostrar el resultado."
            ],
            performance: [
                "Presenta el teléfono como una báscula de precisión usando la sensibilidad de la pantalla.",
                "Coloca tú mismo el objeto en la esquina superior derecha (la zona que has memorizado como \"tu zona\"), y responde así cuando el atajo te pregunte dónde lo colocaste.",
                "Muestra el peso exacto y correcto, reforzando la credibilidad del aparato.",
                "Pide a un espectador que coloque el mismo objeto, indicando esta vez que lo puso en el centro: el resultado será aleatorio o un mensaje de error de calibración."
            ],
            script: [
                "\"Esta pantalla tiene sensores de presión capaces de medir peso con precisión.\"",
                "\"Mira, coloco la llave aquí... exactamente 4 gramos.\"",
                "\"Ahora pruébalo tú... interesante, el peso ha cambiado por completo.\""
            ],
            recoveryTips: [
                "Si te equivocas al indicar la zona donde colocaste el objeto, el atajo mostrará un resultado distinto al esperado; responde siempre con seguridad sobre qué zona elegiste.",
                "Ten preparada una explicación divertida para el \"error de calibración\" cuando lo active un espectador, como parte del espectáculo."
            ],
            performanceTips: [
                "Practica indicar siempre la misma zona para tus propias mediciones, de forma consistente y memorizable.",
                "Deja que distintas personas prueben colocando el objeto en el centro, reforzando que solo tú obtienes mediciones \"correctas\"."
            ],
            variations: [
                "Usa dos objetos de pesos distintos y memorizados, ampliando la rutina con varias mediciones \"precisas\" tuyas.",
                "Presenta el efecto como una prueba de \"conexión especial\" con los objetos en vez de hablar de sensores."
            ],
            commonMistakes: [
                "Olvidar en qué zona memorizada debes colocar el objeto para obtener el peso correcto.",
                "Dejar que el espectador vea tu mano elegir deliberadamente una zona concreta de la pantalla."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Memoriza el peso real de tu objeto y la zona de pantalla que vas a indicar siempre como la tuya.",
                spectatorAction: "No participa todavía.",
                simulationNote: "El peso 'correcto' es simplemente el dato real que memorizaste de antemano."
            ),
            PracticeStep(
                performerAction: "Coloca el objeto en tu zona memorizada e indica esa zona cuando el atajo lo pregunte.",
                spectatorAction: "Ve el peso exacto y correcto aparecer en pantalla.",
                simulationNote: "El atajo simplemente muestra el número fijo asociado a esa zona."
            ),
            PracticeStep(
                performerAction: "Pide al espectador que coloque el mismo objeto en el centro.",
                spectatorAction: "Ve un peso completamente distinto o un mensaje de error.",
                simulationNote: "La zona 'centro' está asociada a un resultado aleatorio o de error, no a una medición real."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ImpossibleWeightPerformView()) }
    static func settingsView() -> AnyView { AnyView(ImpossibleWeightSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum WeightZone: String, CaseIterable {
    case yourZone = "Tu zona"
    case center = "Centro"
}

private struct ImpossibleWeightPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("impossible_weight_value") private var memorizedWeight = 4.0
    @State private var selectedZone: WeightZone = .yourZone
    @State private var resultText: String?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: "scalemass.fill")
                .font(.system(size: 56))
                .foregroundStyle(.gray)

            if let resultText {
                Text(resultText)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .transition(.opacity)
            } else {
                Text("0,0 g")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Picker("Zona", selection: $selectedZone) {
                ForEach(WeightZone.allCases, id: \.self) { zone in
                    Text(zone.rawValue).tag(zone)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.Spacing.lg)

            PrimaryButton("Pesar objeto", symbol: "scalemass", tint: .gray) {
                measure()
            }
            .padding(.horizontal, Theme.Spacing.lg)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }

    private func measure() {
        HapticManager.shared.impact(.light)
        withAnimation(Theme.AnimationCurve.standard) {
            switch selectedZone {
            case .yourZone:
                resultText = String(format: "%.1f g", memorizedWeight)
            case .center:
                let outcomes = ["Error de calibración", String(format: "%.1f g", Double.random(in: 0...50))]
                resultText = outcomes.randomElement()
            }
        }
        MagicEngine.performReveal()
    }
}

private struct ImpossibleWeightSettingsView: View {
    @AppStorage("impossible_weight_value") private var memorizedWeight = 4.0

    var body: some View {
        SecretConfigScreen(title: "El Peso Digital Imposible") {
            Section("Peso real memorizado del objeto") {
                Stepper(String(format: "%.1f g", memorizedWeight), value: $memorizedWeight, in: 0...500, step: 0.5)
            }
            Section {
                Text("Pesa tu objeto de antemano en una báscula real e introduce ese valor aquí. Cuando coloques el objeto en 'Tu zona', siempre se mostrará ese peso exacto; en 'Centro', el resultado es aleatorio o un error de calibración.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
