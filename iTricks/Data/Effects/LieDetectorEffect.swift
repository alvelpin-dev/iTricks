import SwiftUI

/// "Detector de mentiras" — Paranormal.
///
/// Combina el nivel real de volumen del micrófono (un dato genuino: la
/// voz tiembla y varía de volumen de forma natural al hablar) con un
/// control discreto del mago para decidir el momento exacto en que el
/// medidor marca "mentira", igual que `ParanormalDetectorEffect` combina
/// datos reales con control manual.
enum LieDetectorEffect: EffectModule {
    static let info = EffectInfo(
        id: "lie_detector",
        name: "Detector de mentiras",
        category: .paranormal,
        shortDescription: "El iPhone analiza la voz del espectador en tiempo real y señala cuándo está mintiendo.",
        difficulty: .intermediate,
        preparationTime: .none,
        symbol: "waveform",
        instructions: EffectInstructions(
            whatItDoes: "El espectador responde preguntas en voz alta mientras el teléfono muestra un medidor que analiza su voz. El medidor reacciona de forma natural al volumen real de la voz, y el mago controla discretamente el momento en que se dispara la alarma de \"mentira\" en las respuestas que él decide.",
            preparation: [
                "Antes de la actuación, decide con qué pregunta vas a provocar la \"mentira\" detectada, para que el momento esté bien planeado en tu guion.",
                "Practica el toque discreto en la zona oculta de la pantalla hasta que te resulte natural sin mirar."
            ],
            performance: [
                "Pide al espectador que sujete el teléfono cerca de su boca, como si fuera un micrófono de verdad.",
                "Hazle preguntas sencillas de sí/no y pide que responda en voz alta.",
                "Deja que el medidor reaccione de forma natural al volumen de la voz en las primeras respuestas para generar confianza en el aparato.",
                "En la pregunta clave, toca la zona oculta para disparar la alarma de \"mentira\" en el momento exacto que decidas.",
                "Reacciona con sorpresa fingida y comenta el resultado como si el detector realmente hubiera funcionado."
            ],
            script: [
                "\"Vamos a usar el micrófono para analizar el estrés en tu voz, como un detector de mentiras real.\"",
                "\"Responde en voz alta, que el micrófono pueda escucharte bien.\"",
                "\"Ahí... el medidor se ha disparado. Creo que no me has dicho la verdad.\""
            ],
            recoveryTips: [
                "Si el espectador habla muy bajo y el medidor apenas reacciona, pídele que se acerque más al micrófono antes de continuar.",
                "Si el ambiente es ruidoso, el medidor reaccionará más de la cuenta de forma natural; aprovecha esas reacciones extra como parte del espectáculo."
            ],
            performanceTips: [
                "Deja varias preguntas \"neutras\" antes de la decisiva, para que el patrón de uso no resulte sospechoso.",
                "No coloques siempre la pregunta clave en la misma posición de la secuencia entre actuaciones distintas."
            ],
            variations: [
                "Hazlo en grupo: cada persona responde una pregunta y el mago decide en quién se dispara la alarma.",
                "Combínalo con una adivinación: tras detectar la \"mentira\", revela cuál creías que era la verdad."
            ],
            commonMistakes: [
                "Tocar la zona oculta de forma demasiado evidente o repetida.",
                "Hacer solo una pregunta antes de la decisiva, lo que no da tiempo a establecer la credibilidad del aparato."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide al espectador que sujete el teléfono cerca de la boca y responda preguntas neutras.",
                spectatorAction: "Responde preguntas sencillas en voz alta.",
                simulationNote: "El medidor reacciona de verdad al volumen real de la voz captado por el micrófono."
            ),
            PracticeStep(
                performerAction: "En la pregunta clave, toca la zona oculta para forzar la alarma de mentira.",
                spectatorAction: "Responde la pregunta decisiva sin saber que el resultado está controlado.",
                simulationNote: "El toque oculto añade un pico controlado sobre la lectura real del micrófono."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(LieDetectorPerformView()) }
    static func settingsView() -> AnyView { AnyView(LieDetectorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct LieDetectorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("lie_detector_sensitivity") private var sensitivity = 1.0
    @State private var manualSpike: Double = 0
    @State private var isLying = false

    private var level: Double {
        min(1, sensors.micLevel * sensitivity + manualSpike)
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(isLying ? Color.red.opacity(0.2) : Color.indigo.opacity(0.15), lineWidth: 14)
                    .frame(width: 220, height: 220)
                Circle()
                    .trim(from: 0, to: level)
                    .stroke(isLying ? Color.red : Color.indigo, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .animation(Theme.AnimationCurve.gentle, value: level)
                VStack(spacing: 4) {
                    Image(systemName: isLying ? "exclamationmark.triangle.fill" : "waveform")
                        .font(.system(size: 28))
                        .foregroundStyle(isLying ? .red : .indigo)
                    Text(isLying ? "¡MENTIRA!" : "Analizando voz…")
                        .font(Theme.Typography.headline)
                }
            }

            Spacer()
            Text("Habla en voz alta, cerca del micrófono")
                .font(Theme.Typography.body)
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
                .onTapGesture { triggerLieSpike() }
                .accessibilityHidden(true)
        }
        .onAppear {
            MagicEngine.beginSession()
            sensors.startMicMonitoring()
        }
        .onDisappear { MagicEngine.endSession() }
    }

    private func triggerLieSpike() {
        HapticManager.shared.error()
        withAnimation(Theme.AnimationCurve.snappy) {
            manualSpike = 0.7
            isLying = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(Theme.AnimationCurve.gentle) {
                manualSpike = 0
                isLying = false
            }
        }
    }
}

private struct LieDetectorSettingsView: View {
    @AppStorage("lie_detector_sensitivity") private var sensitivity = 1.0

    var body: some View {
        SecretConfigScreen(title: "Detector de mentiras") {
            Section("Sensibilidad del micrófono") {
                Slider(value: $sensitivity, in: 0.3...3.0, step: 0.1)
                Text("Valor actual: \(sensitivity, specifier: "%.1f")")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Section {
                Text("Toca la esquina inferior derecha durante la pregunta clave para forzar la alarma de mentira, superpuesta sobre la lectura real del micrófono.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Control oculto")
            }
        }
    }
}
