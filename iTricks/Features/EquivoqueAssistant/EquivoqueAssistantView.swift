import SwiftUI

/// Asistente reutilizable para ejecutar correctamente la técnica de
/// "equívoco" (magician's choice / multiple out) sobre 4 opciones,
/// forzando siempre la misma sin que el espectador note manipulación.
///
/// Algoritmo real de equívoco en dos rondas:
/// 1. El espectador señala dos de las cuatro opciones. Si la opción forzada
///    está entre las señaladas, se eliminan las DOS NO señaladas. Si no lo
///    está, se eliminan las DOS señaladas. En ambos casos la forzada
///    sobrevive entre las dos restantes.
/// 2. El espectador señala una de las dos restantes. Si es la forzada, se
///    descarta la otra. Si no lo es, se descarta la señalada. La forzada
///    siempre queda como única superviviente.
///
/// El mago, no la app, decide qué señaló el espectador (tocando la opción
/// correspondiente), porque solo él puede ver el gesto real del espectador.
struct EquivoqueAssistantView: View {
    let options: [String]
    let forcedIndex: Int
    let onFinished: (String) -> Void

    @State private var remaining: [Int]
    @State private var round = 1
    @State private var instruction: String?

    init(options: [String], forcedIndex: Int, onFinished: @escaping (String) -> Void) {
        precondition(options.count == 4, "El equívoco está diseñado para exactamente 4 opciones")
        self.options = options
        self.forcedIndex = forcedIndex
        self.onFinished = onFinished
        _remaining = State(initialValue: Array(0..<options.count))
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Text(roundPrompt)
                .font(Theme.Typography.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.md)

            if let instruction {
                GlassCard {
                    Text(instruction)
                        .font(Theme.Typography.body)
                }
                .padding(.horizontal, Theme.Spacing.md)
            }

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(remaining, id: \.self) { index in
                    Button {
                        select(index)
                    } label: {
                        Text(options[index])
                            .font(Theme.Typography.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.appSecondaryBackground, in: RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous))
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.md)

            Text(selectionHint)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.md)
        }
    }

    private var roundPrompt: String {
        round == 1
            ? "Pide al espectador que señale libremente DOS de las cuatro opciones.\nToca las dos que haya señalado."
            : "Pide que señale UNA de las dos opciones restantes.\nToca la que haya señalado."
    }

    private var selectionHint: String {
        round == 1
            ? "Toca exactamente dos. La app te dirá qué decir después."
            : "Toca exactamente una. La app te dará la frase final."
    }

    @State private var firstRoundTaps: [Int] = []

    private func select(_ index: Int) {
        HapticManager.shared.selectionChanged()
        if round == 1 {
            firstRoundTaps.append(index)
            guard firstRoundTaps.count == 2 else { return }

            let pointed = Set(firstRoundTaps)
            let forcedIsPointed = pointed.contains(forcedIndex)
            if forcedIsPointed {
                instruction = "Di: \"Vamos a eliminar estas dos que no señalaste.\" Elimina las dos NO señaladas."
                remaining = Array(pointed)
            } else {
                instruction = "Di: \"Vamos a eliminar estas dos que señalaste.\" Elimina las dos señaladas."
                remaining = remaining.filter { !pointed.contains($0) }
            }
            round = 2
            firstRoundTaps = []
        } else {
            if index == forcedIndex {
                instruction = "Di: \"Quédate con esta que has señalado.\""
            } else {
                instruction = "Di: \"Vamos a quitar esta que has señalado.\""
            }
            remaining = [forcedIndex]
            HapticManager.shared.magicReveal()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onFinished(options[forcedIndex])
            }
        }
    }
}
