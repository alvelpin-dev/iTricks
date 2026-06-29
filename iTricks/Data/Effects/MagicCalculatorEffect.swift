import SwiftUI

/// "Calculadora mágica" — Números.
///
/// Método real: la propiedad matemática del 1089. Cualquier número de
/// tres cifras con la primera y la última cifra distintas, al restarle su
/// inverso (y si el resultado tiene dos cifras, completarlo con un cero a
/// la izquierda) y sumarle el inverso de ese resultado, da siempre 1089.
/// El espectador cree que el resultado depende de su número, pero está
/// matemáticamente garantizado, lo que permite tener una predicción
/// sellada de antemano.
enum MagicCalculatorEffect: EffectModule {
    static let info = EffectInfo(
        id: "magic_calculator",
        name: "Calculadora mágica",
        category: .numbers,
        shortDescription: "El espectador elige un número de tres cifras al azar. El resultado final coincide con una predicción sellada.",
        difficulty: .beginner,
        preparationTime: .seconds,
        symbol: "number",
        instructions: EffectInstructions(
            whatItDoes: "El espectador escribe en la \"calculadora\" cualquier número de tres cifras (con la primera y la última cifra distintas), y la app le guía para invertirlo, restar y volver a invertir y sumar. El resultado final, 1089, coincide exactamente con una predicción que el mago mostró sellada antes de empezar.",
            preparation: [
                "Antes de la actuación, anota \"1089\" en un papel, dentro de un sobre sellado, o guárdalo como nota cerrada en otra app del teléfono.",
                "Asegúrate de tener ese sobre o nota accesible para el momento de la revelación final."
            ],
            performance: [
                "Muestra el sobre sellado (o la nota oculta) y déjalo bien visible sin abrirlo, anunciando que contiene una predicción.",
                "Pide al espectador que escriba cualquier número de tres cifras distintas en la \"calculadora\", evitando que la primera y la última cifra coincidan.",
                "Sigue los pasos que la app indica: invertir el número, restar el menor del mayor, y sumar el resultado a su propio inverso.",
                "Cuando la app muestre el resultado final, pide a alguien que abra el sobre o lea la nota predicha.",
                "Deja que el público compruebe que el resultado y la predicción coinciden exactamente: 1089."
            ],
            script: [
                "\"Antes de empezar, he dejado una predicción sellada sobre la mesa. No la toquéis todavía.\"",
                "\"Escribe cualquier número de tres cifras, el que tú quieras, que no se repita la primera y la última cifra.\"",
                "\"Ahora vamos a invertirlo, a restarlo... y a sumarlo otra vez. Veamos qué número sale.\""
            ],
            recoveryTips: [
                "Si el espectador elige un número con la primera y última cifra iguales (ej. 565), la app lo detecta y le pide otro número antes de continuar.",
                "Si se equivoca al invertir mentalmente, deja que la app haga el cálculo automáticamente; lo importante es que el espectador elija el número inicial con libertad."
            ],
            performanceTips: [
                "Muestra el sobre sellado bien al principio, antes de pedir el número, para reforzar que la predicción es previa.",
                "No expliques la propiedad matemática del 1089 después del efecto: deja que el asombro quede sin explicación."
            ],
            variations: [
                "En vez de un sobre, predice el resultado escribiéndolo en una pizarra y tapándolo con un libro.",
                "Combina el resultado 1089 con una segunda capa: usa esas cuatro cifras para forzar una carta (10=10, 8=8, 9=9) en un efecto de cartas posterior."
            ],
            commonMistakes: [
                "Permitir números con la primera y última cifra iguales, lo que puede romper la fórmula.",
                "Abrir la predicción antes de completar todo el cálculo, perdiendo tensión dramática."
            ],
            recommendedDuration: "3-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Muestra una predicción sellada con \"1089\" escrito de antemano.",
                spectatorAction: "Observa el sobre sellado sin conocer su contenido.",
                simulationNote: "El resultado está garantizado por la propiedad matemática del 1089, no por adivinación."
            ),
            PracticeStep(
                performerAction: "Pide un número de tres cifras con primera y última cifra distintas.",
                spectatorAction: "Elige libremente cualquier número que cumpla la condición.",
                simulationNote: "La app valida automáticamente que el número cumple la condición necesaria."
            ),
            PracticeStep(
                performerAction: "Guía los pasos de inversión, resta y suma mostrados en pantalla.",
                spectatorAction: "Sigue cada paso del cálculo junto con la app.",
                simulationNote: "Cualquier número válido converge siempre en 1089 tras estos pasos."
            ),
            PracticeStep(
                performerAction: "Pide que se abra la predicción sellada y se compare con el resultado.",
                spectatorAction: "Comprueba que la predicción coincide exactamente.",
                simulationNote: "La coincidencia es matemáticamente perfecta el 100% de las veces."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MagicCalculatorPerformView()) }
    static func settingsView() -> AnyView { AnyView(MagicCalculatorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum CalculatorStage {
    case input, reversedSubtraction, finalSum, reveal
}

private struct MagicCalculatorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stage: CalculatorStage = .input
    @State private var inputText = ""
    @State private var errorMessage: String?
    @State private var subtractionResult = 0
    @State private var finalResult = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            switch stage {
            case .input: inputContent
            case .reversedSubtraction: subtractionContent
            case .finalSum: finalSumContent
            case .reveal: revealContent
            }

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }

    private var inputContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "number")
                .font(.system(size: 56))
                .foregroundStyle(.blue)
            Text("Escribe cualquier número de tres cifras")
                .font(Theme.Typography.title)
                .multilineTextAlignment(.center)
            Text("La primera y la última cifra no deben ser iguales")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)

            TextField("Ej. 472", text: $inputText)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .padding()
                .glassCardStyle()

            if let errorMessage {
                Text(errorMessage)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.red)
            }

            PrimaryButton("Calcular", symbol: "arrow.right", tint: .blue) {
                processInput()
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
    }

    private var subtractionContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Invertimos y restamos…")
                .font(Theme.Typography.headline)
            Text("\(subtractionResult)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
            PrimaryButton("Invertir y sumar", symbol: "arrow.right", tint: .blue) {
                withAnimation(Theme.AnimationCurve.standard) {
                    let reversedDigits = String(String(format: "%03d", subtractionResult).reversed())
                    finalResult = subtractionResult + (Int(reversedDigits) ?? 0)
                    stage = .finalSum
                }
            }
        }
    }

    private var finalSumContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Resultado final")
                .font(Theme.Typography.headline)
            Text("\(finalResult)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
            PrimaryButton("Comprobar predicción", symbol: "envelope.open", tint: .blue) {
                MagicEngine.performReveal()
                withAnimation(Theme.AnimationCurve.standard) { stage = .reveal }
            }
        }
    }

    private var revealContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("1089")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
                .transition(.scale.combined(with: .opacity))
            Text("Exactamente lo que predijiste")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
            SecondaryButton("Repetir con otro número", symbol: "arrow.counterclockwise") {
                inputText = ""
                withAnimation { stage = .input }
            }
        }
    }

    private func processInput() {
        guard let number = Int(inputText), inputText.count == 3 else {
            errorMessage = "Introduce exactamente tres cifras."
            return
        }
        let digits = Array(String(format: "%03d", number))
        guard digits.first != digits.last else {
            errorMessage = "La primera y la última cifra deben ser distintas."
            return
        }
        errorMessage = nil

        let reversed = Int(String(digits.reversed()))!
        subtractionResult = abs(number - reversed)
        HapticManager.shared.impact(.light)
        withAnimation(Theme.AnimationCurve.standard) { stage = .reversedSubtraction }
    }
}

private struct MagicCalculatorSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "Calculadora mágica") {
            Section {
                Text("El resultado final está garantizado matemáticamente: cualquier número de tres cifras con la primera y última cifra distintas converge siempre en 1089 tras invertir, restar y sumar el inverso. No hay parámetros que ajustar: solo necesitas preparar la predicción sellada con \"1089\" antes de la actuación.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
