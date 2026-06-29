import SwiftUI

/// "Adivina cualquier carta" — Cartas.
///
/// Método real: seguimiento de corte completo ("tracked cut"). Un corte
/// completo de un mazo (mover un bloque de cartas de arriba abajo) no
/// rompe el orden cíclico del mazo. Si la app conoce qué carta ocupa la
/// posición superior y genera ella misma la cantidad de cartas movidas en
/// cada corte, siempre puede calcular qué carta queda arriba tras una
/// serie de cortes "libres" en apariencia. El espectador corta tantas
/// veces como quiera; la app simplemente lleva la cuenta.
enum AnyCardEffect: EffectModule {
    static let info = EffectInfo(
        id: "any_card",
        name: "Adivina cualquier carta",
        category: .cards,
        shortDescription: "El espectador corta el mazo libremente las veces que quiera. Tú anuncias la carta antes de que la vea.",
        difficulty: .intermediate,
        preparationTime: .seconds,
        symbol: "suit.club.fill",
        instructions: EffectInstructions(
            whatItDoes: "Se muestra un mazo barajado en pantalla. El espectador lo corta tantas veces como desee tocando el botón \"Cortar\". Cuando decide detenerse, el mago anuncia en voz alta el nombre exacto de la carta que ha quedado en la parte superior del mazo, antes de mostrarla.",
            preparation: [
                "No requiere preparación física: el mazo es virtual y se baraja en la propia app.",
                "Practica el guion para anunciar la carta con seguridad y sin dudar, justo antes de revelarla en pantalla."
            ],
            performance: [
                "Pulsa \"Barajar\" para mezclar el mazo visualmente delante del espectador.",
                "Entrega el control o pide al espectador que pulse \"Cortar\" tantas veces como quiera, sin patrón fijo.",
                "Cuando el espectador decida detenerse, pídele que NO mire todavía la carta superior.",
                "Anuncia en voz alta el nombre de la carta que la app te muestra de forma discreta en ese momento.",
                "Pide al espectador que voltee la carta superior para comprobar que coincide exactamente con lo que dijiste.",
                "Deja que la app revele la carta en pantalla como confirmación final, a modo de \"doble verificación\"."
            ],
            script: [
                "\"Corta el mazo tantas veces como quieras, no hay trampa, tú decides cuándo paras.\"",
                "\"No mires todavía la carta de arriba.\"",
                "\"Tu carta es... el siete de corazones.\""
            ],
            recoveryTips: [
                "Si pierdes la cuenta visual de la animación, no pasa nada: la app calcula la posición exacta, solo tienes que leerla en el panel discreto antes de anunciarla.",
                "Si el espectador insiste en cortar muchísimas veces, deja que lo haga: el método funciona igual sin importar cuántos cortes se realicen."
            ],
            performanceTips: [
                "Anuncia la carta ANTES de que se revele en pantalla; ese orden es lo que vende el efecto como una predicción real.",
                "Mantén contacto visual al anunciar la carta en lugar de mirar la pantalla, para que parezca que la sabes de memoria."
            ],
            variations: [
                "En lugar de anunciarla tú, puedes pedirle al espectador que la diga él mismo después de mirarla y tú simplemente \"confirmas\" que ya lo sabías.",
                "Puedes presentarlo como si el teléfono \"sintiera\" las vibraciones del corte para detectar la carta, en vez de mencionar predicción."
            ],
            commonMistakes: [
                "Revelar la carta en pantalla antes de anunciarla en voz alta, lo que invierte el orden dramático correcto.",
                "Cortar tú mismo el mazo en lugar de dejar que el espectador lo haga libremente, lo que reduce el impacto."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pulsa \"Barajar\" para mezclar el mazo visualmente.",
                spectatorAction: "Observa cómo se baraja el mazo en pantalla.",
                simulationNote: "La app asigna internamente una carta de seguimiento en la posición superior."
            ),
            PracticeStep(
                performerAction: "Cede el control y deja que el espectador pulse \"Cortar\" varias veces.",
                spectatorAction: "Corta el mazo tantas veces como quiera, sin patrón.",
                simulationNote: "Cada corte mueve un bloque aleatorio de arriba abajo; la app recalcula la posición de la carta seguida en cada corte."
            ),
            PracticeStep(
                performerAction: "Lee discretamente el nombre de la carta indicado por la app y anúncialo en voz alta.",
                spectatorAction: "Escucha la predicción sin haber mirado todavía la carta.",
                simulationNote: "La app conoce con certeza matemática qué carta ocupa la posición superior."
            ),
            PracticeStep(
                performerAction: "Pide que voltee la carta superior para confirmar.",
                spectatorAction: "Voltea la carta y comprueba que coincide con la predicción.",
                simulationNote: "La coincidencia está garantizada por el seguimiento de cortes, no por azar."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(AnyCardPerformView()) }
    static func settingsView() -> AnyView { AnyView(AnyCardSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum AnyCardStage {
    case intro, shuffled, cutting, revealed
}

private struct AnyCardPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("any_card_show_helper") private var showHelper = true
    @State private var stage: AnyCardStage = .intro
    @State private var trackedIndex = 0
    @State private var deck = PredictionEngine.standardDeck.shuffled()
    @State private var cutCount = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            switch stage {
            case .intro: introContent
            case .shuffled: shuffledContent
            case .cutting: cuttingContent
            case .revealed: revealedContent
            }

            Spacer()
            footer
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }

    private var introContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            deckGlyph
            Text("Mazo listo para barajar")
                .font(Theme.Typography.title)
            PrimaryButton("Barajar", symbol: "shuffle", tint: .red) {
                deck = PredictionEngine.standardDeck.shuffled()
                trackedIndex = 0
                cutCount = 0
                HapticManager.shared.impact(.medium)
                withAnimation(Theme.AnimationCurve.standard) { stage = .shuffled }
            }
        }
    }

    private var shuffledContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            deckGlyph
            Text("El mazo está barajado.\nEntrega el teléfono al espectador.")
                .font(Theme.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            PrimaryButton("Comenzar a cortar", symbol: "arrow.up.arrow.down", tint: .red) {
                withAnimation(Theme.AnimationCurve.standard) { stage = .cutting }
            }
        }
    }

    private var cuttingContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            deckGlyph
            Text("Cortes realizados: \(cutCount)")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)

            PrimaryButton("Cortar", symbol: "scissors", tint: .red) {
                performCut()
            }

            SecondaryButton("Ya he cortado suficiente", symbol: "checkmark") {
                MagicEngine.performBuildUp()
                withAnimation(Theme.AnimationCurve.standard) { stage = .revealed }
            }

            if showHelper {
                Text("Carta superior actual: \(cardName(at: trackedIndex))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, Theme.Spacing.xs)
            }
        }
    }

    private var revealedContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Anuncia en voz alta:")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
            Text(cardName(at: trackedIndex))
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .transition(.scale.combined(with: .opacity))
            Text("Ahora pide que volteen la carta superior")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .onAppear { MagicEngine.performReveal() }
    }

    private var deckGlyph: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.red.opacity(0.85 - Double(i) * 0.2))
                    .frame(width: 100, height: 140)
                    .offset(x: CGFloat(i) * 3, y: CGFloat(i) * -3)
            }
            Image(systemName: "suit.club.fill")
                .font(.system(size: 32))
                .foregroundStyle(.white)
        }
        .frame(height: 150)
    }

    private var footer: some View {
        Button("Cerrar") { dismiss() }
            .font(Theme.Typography.caption)
            .foregroundStyle(.secondary)
    }

    private func performCut() {
        let cut = Int.random(in: 1..<deck.count)
        trackedIndex = (trackedIndex - cut + deck.count) % deck.count
        cutCount += 1
        HapticManager.shared.impact(.light)
    }

    private func cardName(at index: Int) -> String {
        formattedCardName(deck[index])
    }
}

/// Convierte el código corto de una carta (ej. "10H") en un nombre legible en español.
func formattedCardName(_ code: String) -> String {
    let rankCode = String(code.dropLast())
    let suitCode = String(code.suffix(1))

    let rankNames: [String: String] = [
        "A": "As", "2": "Dos", "3": "Tres", "4": "Cuatro", "5": "Cinco",
        "6": "Seis", "7": "Siete", "8": "Ocho", "9": "Nueve", "10": "Diez",
        "J": "Jota", "Q": "Reina", "K": "Rey"
    ]
    let suitNames: [String: String] = [
        "S": "Picas", "H": "Corazones", "D": "Diamantes", "C": "Tréboles"
    ]

    let rank = rankNames[rankCode] ?? rankCode
    let suit = suitNames[suitCode] ?? suitCode
    return "\(rank) de \(suit)"
}

private struct AnyCardSettingsView: View {
    @AppStorage("any_card_show_helper") private var showHelper = true

    var body: some View {
        SecretConfigScreen(title: "Adivina cualquier carta") {
            Section("Ayuda en escena") {
                Toggle("Mostrar carta superior discretamente", isOn: $showHelper)
            }
            Section {
                Text("El método se basa en el seguimiento matemático de cortes completos: cada corte lo genera la propia app, por lo que siempre puede calcular qué carta queda arriba del mazo, sin importar cuántas veces se corte.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
