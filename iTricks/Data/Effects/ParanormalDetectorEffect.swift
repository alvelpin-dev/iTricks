import SwiftUI

/// "Detector paranormal" — Paranormal.
///
/// Combina datos reales del magnetómetro (brújula) del iPhone, que
/// fluctúa de forma natural cerca de objetos metálicos o campos
/// magnéticos del entorno, con un control discreto del mago para reforzar
/// el momento exacto de la "detección" mediante una zona de toque oculta.
/// El resultado se siente genuino porque, en parte, lo es: el sensor sí
/// reacciona a interferencias reales del entorno.
enum ParanormalDetectorEffect: EffectModule {
    static let info = EffectInfo(
        id: "paranormal_detector",
        name: "Detector paranormal",
        category: .paranormal,
        shortDescription: "El iPhone detecta \"energía paranormal\" combinando el magnetómetro real con el control del mago.",
        difficulty: .intermediate,
        preparationTime: .none,
        symbol: "sparkles",
        instructions: EffectInstructions(
            whatItDoes: "La pantalla muestra un medidor de \"energía paranormal\" que reacciona en tiempo real al campo magnético del entorno (un dato real, captado por el magnetómetro). El mago puede además provocar discretamente un \"pico\" de energía en el momento dramático que él decida, tocando una zona invisible de la pantalla.",
            preparation: [
                "Comprueba antes de actuar que no hay imanes ni metales muy cercanos al teléfono que disparen el medidor de forma constante.",
                "Identifica de antemano un objeto metálico cercano (llaves, anillo, marco de puerta) que puedas acercar de forma disimulada para justificar una lectura alta de forma real."
            ],
            performance: [
                "Presenta el teléfono como un \"detector de energías\" y explica que reacciona a presencias en la habitación.",
                "Pasea el teléfono lentamente por la habitación dejando que el medidor reaccione de forma natural a objetos metálicos reales.",
                "En el momento dramático que elijas, toca discretamente la zona oculta de la pantalla para provocar un pico de energía controlado.",
                "Combina ambos: deja que el sensor real genere fluctuaciones creíbles y refuerza el clímax con tu control manual."
            ],
            script: [
                "\"Vamos a usar los sensores magnéticos del teléfono para detectar si hay alguna presencia en la sala.\"",
                "\"Mantente quieto, a veces estas energías reaccionan al movimiento o a las emociones.\"",
                "\"Ahí... ¿lo notas? Algo ha reaccionado justo ahí.\""
            ],
            recoveryTips: [
                "Si el medidor se queda plano mucho tiempo, usa tu control oculto para generar un pico y mantener el interés.",
                "Si reacciona de forma inesperadamente alta por un objeto real, aprovecha el momento como si fuera parte del guion."
            ],
            performanceTips: [
                "Cuanto menos expliques el funcionamiento técnico, más misterioso resulta el efecto.",
                "Usa luz tenue y un tono de voz bajo para reforzar la atmósfera paranormal.",
                "El movimiento lento del teléfono por la habitación genera más tensión que mantenerlo quieto."
            ],
            variations: [
                "Preséntalo como un detector de mentiras paranormal: pide que respondan preguntas y provoca picos en las respuestas que decidas.",
                "Combínalo con una historia de fondo sobre el lugar donde actúas para dar contexto narrativo al detector."
            ],
            commonMistakes: [
                "Tocar la zona oculta demasiadas veces seguidas, lo que genera un patrón reconocible.",
                "Explicar que el dato proviene del magnetómetro, lo que rompe la ilusión inmediatamente."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Activa el detector y paséalo lentamente por la sala.",
                spectatorAction: "Observa el medidor reaccionar mientras el mago se mueve.",
                simulationNote: "El magnetómetro real responde a objetos metálicos del entorno; la lectura base es genuina."
            ),
            PracticeStep(
                performerAction: "En el momento dramático, toca la zona oculta para forzar un pico de energía.",
                spectatorAction: "Reacciona al pico repentino en la pantalla.",
                simulationNote: "El toque oculto añade un impulso controlado sobre la lectura real del sensor."
            ),
            PracticeStep(
                performerAction: "Cierra el efecto relacionando el pico con algo significativo del contexto (un nombre, un objeto, un lugar).",
                spectatorAction: "Conecta emocionalmente el pico de energía con el comentario del mago.",
                simulationNote: "La combinación de dato real + control manual + narrativa es lo que vende el efecto."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ParanormalDetectorPerformView()) }
    static func settingsView() -> AnyView { AnyView(ParanormalDetectorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct ParanormalDetectorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("paranormal_sensitivity") private var sensitivity = 1.0
    @State private var manualSpike: Double = 0

    private var energyLevel: Double {
        let baseline = abs(sensors.heading.truncatingRemainder(dividingBy: 30)) / 30
        return min(1, baseline * sensitivity + manualSpike)
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.indigo.opacity(0.15), lineWidth: 14)
                    .frame(width: 220, height: 220)
                Circle()
                    .trim(from: 0, to: energyLevel)
                    .stroke(Color.indigo, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .animation(Theme.AnimationCurve.gentle, value: energyLevel)
                VStack {
                    Text("\(Int(energyLevel * 100))%")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Text("Energía detectada")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
            Text("Mueve el teléfono lentamente por la sala")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        // Zona invisible que el mago toca para forzar un pico dramático.
        .overlay(alignment: .bottomTrailing) {
            Color.clear
                .frame(width: 80, height: 80)
                .contentShape(Rectangle())
                .onTapGesture { triggerSpike() }
                .accessibilityHidden(true)
        }
        .onAppear {
            MagicEngine.beginSession()
            sensors.startHeadingUpdates()
        }
        .onDisappear {
            MagicEngine.endSession()
        }
    }

    private func triggerSpike() {
        HapticManager.shared.impact(.medium)
        withAnimation(Theme.AnimationCurve.snappy) { manualSpike = 0.6 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(Theme.AnimationCurve.gentle) { manualSpike = 0 }
        }
    }
}

private struct ParanormalDetectorSettingsView: View {
    @AppStorage("paranormal_sensitivity") private var sensitivity = 1.0

    var body: some View {
        SecretConfigScreen(title: "Detector paranormal") {
            Section("Sensibilidad del magnetómetro") {
                Slider(value: $sensitivity, in: 0.3...2.5, step: 0.1)
                Text("Valor actual: \(sensitivity, specifier: "%.1f")")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Section {
                Text("Toca la esquina inferior derecha de la pantalla durante la actuación para forzar un pico de energía controlado, superpuesto sobre la lectura real del magnetómetro.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Control oculto")
            }
        }
    }
}
