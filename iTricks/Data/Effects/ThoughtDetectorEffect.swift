import SwiftUI

/// "Detector de pensamiento" — Mentalismo.
///
/// Método real: fuerza matemática de raíz digital. Cualquier número entero
/// del 1 al 9, multiplicado por 9, tiene siempre raíz digital 9 (la suma
/// repetida de sus dígitos siempre converge en 9). El espectador cree que
/// el resultado depende de su número original, pero el resultado final
/// está matemáticamente garantizado. La app solo necesita "revelar" 9.
enum ThoughtDetectorEffect: EffectModule {
    static let info = EffectInfo(
        id: "thought_detector",
        name: "Detector de pensamiento",
        category: .mentalism,
        shortDescription: "El espectador piensa en un número y la app lo \"escanea\" y lo revela con precisión absoluta.",
        difficulty: .beginner,
        preparationTime: .none,
        symbol: "brain.head.profile",
        instructions: EffectInstructions(
            whatItDoes: "El espectador elige libremente un número del 1 al 9 sin decírselo a nadie, realiza un cálculo mental sencillo guiado por la app y, al final, el iPhone \"escanea su mente\" y revela el número exacto en el que pensó.",
            preparation: [
                "No requiere ningún material ni preparación previa.",
                "Repasa mentalmente el guion para que las pausas durante el escaneo se sientan naturales y no mecánicas."
            ],
            performance: [
                "Pide al espectador que piense en cualquier número del 1 al 9 y que no lo diga en voz alta.",
                "Pulsa \"Comenzar\" y entrega el teléfono al espectador, o guíalo tú mismo leyendo las instrucciones en pantalla.",
                "La app le pedirá multiplicar su número por 9 y sumar las cifras del resultado hasta obtener una sola cifra.",
                "Cuando el espectador confirme que ya tiene su cifra final, pulsa \"Escanear\".",
                "Deja que la animación de escaneo se complete: dura unos segundos y genera tensión antes de la revelación.",
                "El número revelado coincidirá siempre con el resultado del espectador. Reacciona con normalidad, como si la app realmente leyera su mente."
            ],
            script: [
                "\"Piensa en cualquier número del uno al nueve, el que tú quieras, y no me lo digas.\"",
                "\"Voy a pedirte que hagas un cálculo muy simple en tu cabeza, tranquilo, no hace falta que sepas matemáticas.\"",
                "\"Ahora voy a usar los sensores del teléfono para intentar leer ese número directamente desde tu mente.\""
            ],
            recoveryTips: [
                "Si el espectador dice que se ha perdido en el cálculo, pídele que empiece de nuevo desde el principio con calma; el método sigue funcionando igual.",
                "Si alguien pregunta cómo funciona el escaneo, mantente en personaje: \"son los sensores de movimiento, reaccionan a la actividad neuronal\" basta como respuesta en tono de broma seria."
            ],
            performanceTips: [
                "Cuanto más lenta y dramática sea la animación de escaneo, más creíble resulta la revelación.",
                "Evita repetir el efecto inmediatamente con la misma persona: al pensar en el método podría descubrir el patrón.",
                "Funciona mejor en formato íntimo, uno a uno, que en grupos grandes."
            ],
            variations: [
                "En vez de revelar un número, puedes mapearlo a una letra (A=1...I=9) y forzar así una palabra o país que empiece por \"I\".",
                "Pide al espectador que visualice el número girando en su mente justo antes de pulsar \"Escanear\" para reforzar la idea de lectura mental."
            ],
            commonMistakes: [
                "Apresurar la animación de escaneo, lo que resta impacto a la revelación.",
                "Explicar de más el procedimiento matemático en lugar de presentarlo como algo natural y sencillo.",
                "Repetir el efecto varias veces seguidas con el mismo público."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide al espectador que piense un número del 1 al 9 sin decirlo.",
                spectatorAction: "Elige mentalmente un número y lo mantiene en secreto.",
                simulationNote: "No necesitas saber el número: el método funciona para cualquier valor entre 1 y 9."
            ),
            PracticeStep(
                performerAction: "Guía el cálculo: multiplicar por 9 y sumar las cifras del resultado hasta quedar con una sola cifra.",
                spectatorAction: "Realiza el cálculo mentalmente y llega a un resultado de una cifra.",
                simulationNote: "La raíz digital de cualquier múltiplo de 9 es siempre 9 — el resultado está garantizado."
            ),
            PracticeStep(
                performerAction: "Pulsa \"Escanear\" y deja que la animación se complete sin prisa.",
                spectatorAction: "Observa la animación de escaneo con expectación.",
                simulationNote: "La app espera unos segundos antes de revelar el 9 para generar tensión dramática."
            ),
            PracticeStep(
                performerAction: "Revela el número y reacciona con naturalidad ante el asombro del espectador.",
                spectatorAction: "Confirma que el número revelado es exactamente el que pensó.",
                simulationNote: "El resultado siempre será correcto; no hay margen de error matemático."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ThoughtDetectorPerformView()) }
    static func settingsView() -> AnyView { AnyView(ThoughtDetectorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

// MARK: - Perform

private enum ThoughtDetectorStage {
    case intro, calculating, scanning, reveal
}

private struct ThoughtDetectorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("thought_detector_reveal_style") private var revealStyle = ThoughtDetectorRevealStyle.number.rawValue
    @State private var stage: ThoughtDetectorStage = .intro
    @State private var scanRotation: Double = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            switch stage {
            case .intro:
                introContent
            case .calculating:
                calculatingContent
            case .scanning:
                scanningContent
            case .reveal:
                revealContent
            }

            Spacer()
            footer
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }

    private var introContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundStyle(.purple)
            Text("Piensa en un número del 1 al 9")
                .font(Theme.Typography.title)
                .multilineTextAlignment(.center)
            Text("No lo digas en voz alta. Cuando lo tengas claro, continúa.")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            PrimaryButton("Ya lo tengo", symbol: "checkmark") {
                withAnimation(Theme.AnimationCurve.standard) { stage = .calculating }
            }
            .padding(.top, Theme.Spacing.md)
        }
    }

    private var calculatingContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Ahora, mentalmente:")
                .font(Theme.Typography.headline)
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                stepRow("1", "Multiplica tu número por 9")
                stepRow("2", "Suma las cifras del resultado")
                stepRow("3", "Si sigue teniendo más de una cifra, vuelve a sumarlas hasta quedarte con una sola")
            }
            .padding(Theme.Spacing.md)
            .glassCardStyle()

            PrimaryButton("Ya tengo mi cifra final", symbol: "checkmark") {
                MagicEngine.performBuildUp()
                withAnimation(Theme.AnimationCurve.standard) { stage = .scanning }
                startScan()
            }
            .padding(.top, Theme.Spacing.sm)
        }
    }

    private func stepRow(_ index: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            Text(index)
                .font(Theme.Typography.headline)
                .foregroundStyle(.purple)
                .frame(width: 20)
            Text(text)
                .font(Theme.Typography.body)
        }
    }

    private var scanningContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .stroke(Color.purple.opacity(0.15), lineWidth: 8)
                    .frame(width: 160, height: 160)
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.purple, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(scanRotation))
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 36))
                    .foregroundStyle(.purple)
            }
            Text("Escaneando actividad mental…")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
        }
    }

    private var revealContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text(ThoughtDetectorRevealStyle(rawValue: revealStyle) == .letter ? "I" : "9")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .foregroundStyle(.purple)
                .transition(.scale.combined(with: .opacity))
            Text("Ese es el número en el que pensaste")
                .font(Theme.Typography.headline)
                .multilineTextAlignment(.center)
        }
    }

    private var footer: some View {
        HStack {
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
            Spacer()
            if stage == .reveal {
                Button("Repetir") {
                    withAnimation { stage = .intro }
                }
                .font(Theme.Typography.caption)
            }
        }
    }

    private func startScan() {
        withAnimation(.linear(duration: 1.4).repeatCount(2, autoreverses: false)) {
            scanRotation += 720
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            MagicEngine.performReveal()
            withAnimation(Theme.AnimationCurve.standard) { stage = .reveal }
        }
    }
}

// MARK: - Settings (secret)

enum ThoughtDetectorRevealStyle: String, CaseIterable, Identifiable {
    case number = "Número (9)"
    case letter = "Letra (I)"
    var id: String { rawValue }
}

private struct ThoughtDetectorSettingsView: View {
    @AppStorage("thought_detector_reveal_style") private var revealStyle = ThoughtDetectorRevealStyle.number.rawValue

    var body: some View {
        SecretConfigScreen(title: "Detector de pensamiento") {
            Section("Estilo de revelación") {
                Picker("Mostrar como", selection: $revealStyle) {
                    ForEach(ThoughtDetectorRevealStyle.allCases) { style in
                        Text(style.rawValue).tag(style.rawValue)
                    }
                }
                .pickerStyle(.inline)
            }
            Section {
                Text("El método se basa en la raíz digital de los múltiplos de 9, que siempre es 9. El resultado está garantizado matemáticamente para cualquier número del 1 al 9 elegido por el espectador.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
