import SwiftUI

/// "La Calculadora Tóxica Digital" — Números.
///
/// Método real (integrado en la app): una calculadora completamente
/// funcional (suma, resta, multiplica y divide de verdad, como cualquier
/// calculadora real). El único punto manipulado es el botón "=": en vez
/// de mostrar el resultado real de la operación, muestra el texto fijo
/// que el mago predeterminó (coordenadas, un número de teléfono, una
/// fecha). El resto de la calculadora opera con normalidad, lo que la
/// hace mucho más creíble que una simulación de interfaz.
enum ToxicCalculatorEffect: EffectModule {
    static let info = EffectInfo(
        id: "toxic_calculator",
        name: "La Calculadora Tóxica Digital",
        category: .numbers,
        shortDescription: "Una calculadora real. Varias personas suman y multiplican números al azar. El resultado final siempre coincide con tu predicción.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "plusminus.circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres una calculadora completamente funcional y pides a varias personas que sumen y multipliquen números al azar (fechas de cumpleaños, números de la suerte). Todas las operaciones se calculan de verdad. Al pulsar \"=\", el resultado mostrado coincide exactamente con una predicción que ya tenías preparada.",
            preparation: [
                "Decide de antemano el número que vas a forzar (coordenadas, tu número de teléfono, una fecha significativa) y configúralo en los ajustes secretos.",
                "Practica con la calculadora real para que las operaciones intermedias se vean fluidas y naturales."
            ],
            performance: [
                "Pide a varias personas distintas que aporten un número y una operación cada una, e introdúcelos de verdad en la calculadora.",
                "Deja que cada operación se calcule con normalidad, mostrando resultados intermedios reales.",
                "Al pulsar \"=\" la última vez, revela el resultado fijo que coincide con tu predicción, en vez del resultado matemático real.",
                "Conecta el resultado con algo significativo (una ubicación, una fecha) para reforzar el impacto."
            ],
            script: [
                "\"Dime cualquier número, el primero que se te ocurra.\"",
                "\"Vamos a sumarlo, multiplicarlo... y a ver qué sale.\"",
                "\"Este número no es casualidad: son las coordenadas exactas de donde estamos ahora mismo.\""
            ],
            recoveryTips: [
                "Como las operaciones intermedias son reales, puedes dejar que cualquiera revise los pasos sin miedo: solo el resultado final de \"=\" está controlado."
            ],
            performanceTips: [
                "Cuantas más personas aporten números distintos, más imposible parece que el resultado esté predeterminado.",
                "Prepara una buena historia para justificar por qué ese número final es relevante."
            ],
            variations: [
                "Usa como resultado final un número de teléfono real al que llamar en el momento para reforzar la sorpresa.",
                "Combínalo con una fecha relevante para el espectador, presentándolo como \"el destino calculado\"."
            ],
            commonMistakes: [
                "Pulsar \"=\" más de una vez por error, lo que podría volver a calcular el resultado real en vez de mostrar el forzado de nuevo.",
                "Usar un número final demasiado largo o complicado de verificar en el momento."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide números y operaciones a varias personas, calculando de verdad cada paso.",
                spectatorAction: "Aporta números al azar viendo resultados intermedios reales.",
                simulationNote: "La calculadora funciona de verdad hasta el último paso."
            ),
            PracticeStep(
                performerAction: "Pulsa '=' por última vez y revela el resultado fijo predeterminado.",
                spectatorAction: "Ve un resultado final que no tiene relación matemática con los números introducidos.",
                simulationNote: "Solo el botón '=' final ignora el cálculo real y muestra el texto configurado."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ToxicCalculatorPerformView()) }
    static func settingsView() -> AnyView { AnyView(ToxicCalculatorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum CalcOperator: String {
    case add = "+", subtract = "−", multiply = "×", divide = "÷"

    func apply(_ lhs: Double, _ rhs: Double) -> Double {
        switch self {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs == 0 ? 0 : lhs / rhs
        }
    }
}

private struct ToxicCalculatorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("toxic_calculator_forced_result") private var forcedResult = "40.4168, -3.7038"

    @State private var display = "0"
    @State private var accumulator: Double = 0
    @State private var pendingOperator: CalcOperator?
    @State private var isEnteringNewNumber = true
    @State private var showingForcedResult = false

    private let buttonRows: [[String]] = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "−"],
        ["C", "0", "=", "+"]
    ]

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(showingForcedResult ? forcedResult : display)
                .font(.system(size: showingForcedResult ? 32 : 56, weight: .medium, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, Theme.Spacing.md)

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(buttonRows, id: \.self) { row in
                    HStack(spacing: Theme.Spacing.sm) {
                        ForEach(row, id: \.self) { key in
                            calculatorButton(key)
                        }
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.md)
        }
        .background(Color.appBackground)
    }

    private func calculatorButton(_ key: String) -> some View {
        Button {
            tap(key)
        } label: {
            Text(key)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .foregroundStyle(key == "=" ? .white : .primary)
                .background(
                    key == "=" ? Color.accentColor : Color.appSecondaryBackground,
                    in: RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous)
                )
        }
        .buttonStyle(PressableButtonStyle())
    }

    private func tap(_ key: String) {
        HapticManager.shared.selectionChanged()

        switch key {
        case "C":
            display = "0"
            accumulator = 0
            pendingOperator = nil
            isEnteringNewNumber = true
            showingForcedResult = false

        case "=":
            if let op = pendingOperator, let value = Double(display) {
                _ = op.apply(accumulator, value)
            }
            withAnimation(Theme.AnimationCurve.standard) { showingForcedResult = true }
            MagicEngine.performReveal()
            pendingOperator = nil
            isEnteringNewNumber = true

        case "+", "−", "×", "÷":
            if let value = Double(display) {
                accumulator = pendingOperator?.apply(accumulator, value) ?? value
            }
            pendingOperator = CalcOperator(rawValue: key)
            isEnteringNewNumber = true
            showingForcedResult = false

        default:
            showingForcedResult = false
            if isEnteringNewNumber {
                display = key
                isEnteringNewNumber = false
            } else {
                display = display == "0" ? key : display + key
            }
        }
    }
}

private struct ToxicCalculatorSettingsView: View {
    @AppStorage("toxic_calculator_forced_result") private var forcedResult = "40.4168, -3.7038"

    var body: some View {
        SecretConfigScreen(title: "Calculadora Tóxica Digital") {
            Section("Resultado forzado") {
                TextField("Coordenadas, teléfono o fecha", text: $forcedResult)
            }
            Section {
                Text("La calculadora opera con normalidad en todos los pasos. Solo al pulsar '=' se ignora el resultado real y se muestra el texto configurado aquí.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
