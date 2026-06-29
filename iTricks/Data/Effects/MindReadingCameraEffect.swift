import SwiftUI

/// "Cámara que lee pensamientos" — Tecnología.
///
/// Combina la cámara frontal real (tecnología genuina) como elemento
/// visual de presentación con el mismo método de fuerza matemática que
/// `ThoughtDetectorEffect` (raíz digital de los múltiplos de 9). La
/// cámara no analiza realmente el rostro: el valor que aporta es mostrar
/// el reflejo del espectador mientras "se le escanea", lo que multiplica
/// el impacto teatral del mismo método matemático ya probado.
enum MindReadingCameraEffect: EffectModule {
    static let info = EffectInfo(
        id: "mind_reading_camera",
        name: "Cámara que lee pensamientos",
        category: .technology,
        shortDescription: "La cámara frontal enmarca el rostro del espectador mientras la app \"escanea\" su mente y revela su número.",
        difficulty: .beginner,
        preparationTime: .none,
        symbol: "camera.fill",
        instructions: EffectInstructions(
            whatItDoes: "El espectador mira a la cámara frontal mientras piensa en un número del 1 al 9 y realiza un cálculo mental sencillo guiado por la app. La pantalla muestra su propio rostro con un overlay de \"análisis\", y al final revela el número exacto en el que pensó.",
            preparation: [
                "No requiere preparación física. Asegúrate de tener buena luz frontal para que la cámara se vea con nitidez.",
                "El método matemático es el mismo que en Detector de pensamiento: la raíz digital de cualquier múltiplo de 9 es siempre 9."
            ],
            performance: [
                "Pide al espectador que sujete el teléfono mirando a la cámara frontal, como si se hiciera un selfie.",
                "Pide que piense un número del 1 al 9 y siga el cálculo mental guiado: multiplicar por 9 y sumar las cifras hasta quedar con una sola.",
                "Deja que la app muestre el overlay de \"escaneo facial\" sobre su propio rostro durante unos segundos.",
                "Revela el número: siempre coincidirá con el resultado de su cálculo."
            ],
            script: [
                "\"Mírate a la cámara y piensa en un número del uno al nueve.\"",
                "\"La cámara va a analizar tus micro-expresiones mientras haces un cálculo mental sencillo.\"",
                "\"Ahí está tu número.\""
            ],
            recoveryTips: [
                "Si la cámara frontal no enfoca bien por poca luz, pide que se acerque a una fuente de luz antes de continuar.",
                "El resultado siempre es matemáticamente correcto, así que cualquier duda del espectador sobre el cálculo no afecta al desenlace."
            ],
            performanceTips: [
                "Aprovecha el hecho de que el espectador se ve a sí mismo en pantalla para generar una conexión emocional más fuerte con el momento de la revelación.",
                "No menciones la palabra \"matemáticas\"; preséntalo como análisis biométrico o de microexpresiones."
            ],
            variations: [
                "Usa la cámara trasera apuntando a un grupo y pide que todos piensen en el mismo número simultáneamente para un efecto grupal.",
                "Sustituye el número final por una letra (I, la novena) para forzar un país o nombre que empiece por esa letra."
            ],
            commonMistakes: [
                "Explicar el cálculo matemático después de la revelación, lo que rompe el misterio.",
                "No dejar suficiente tiempo de \"escaneo\" visual antes de revelar el resultado."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide al espectador que mire a la cámara frontal y piense un número del 1 al 9.",
                spectatorAction: "Sujeta el teléfono mirando a la cámara y elige mentalmente un número.",
                simulationNote: "La cámara solo aporta presentación visual; el método es matemático, no biométrico."
            ),
            PracticeStep(
                performerAction: "Guía el cálculo mental: multiplicar por 9 y sumar cifras hasta una sola.",
                spectatorAction: "Realiza el cálculo mentalmente mientras ve su propio rostro en pantalla.",
                simulationNote: "El resultado siempre converge en 9, sin importar el número elegido inicialmente."
            ),
            PracticeStep(
                performerAction: "Revela el número tras el \"escaneo\" facial.",
                spectatorAction: "Confirma que el número coincide exactamente.",
                simulationNote: "La coincidencia está garantizada matemáticamente, no por análisis de imagen real."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MindReadingCameraPerformView()) }
    static func settingsView() -> AnyView { AnyView(MindReadingCameraSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum ScanStage {
    case intro, calculating, scanning, reveal
}

private struct MindReadingCameraPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraController()
    @State private var stage: ScanStage = .intro
    @State private var scanProgress: Double = 0

    var body: some View {
        ZStack {
            CameraPreviewView(controller: camera)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.15))

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()

                switch stage {
                case .intro:
                    promptCard("Mírate a la cámara y piensa un número del 1 al 9")
                    PrimaryButton("Ya lo tengo", symbol: "checkmark") {
                        withAnimation { stage = .calculating }
                    }
                case .calculating:
                    promptCard("Multiplica tu número por 9 y suma las cifras hasta quedarte con una sola")
                    PrimaryButton("Ya tengo mi cifra final", symbol: "checkmark") {
                        MagicEngine.performBuildUp()
                        withAnimation { stage = .scanning }
                        startScan()
                    }
                case .scanning:
                    ProgressView(value: scanProgress)
                        .tint(.white)
                        .frame(width: 220)
                    Text("Escaneando rasgos faciales…")
                        .foregroundStyle(.white)
                case .reveal:
                    Text("9")
                        .font(.system(size: 96, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Ese es tu número")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(.white)
                }

                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(Theme.Spacing.lg)
        }
        .onAppear {
            MagicEngine.beginSession()
            camera.start()
        }
        .onDisappear {
            camera.stop()
            MagicEngine.endSession()
        }
    }

    private func promptCard(_ text: String) -> some View {
        Text(text)
            .font(Theme.Typography.title)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(Theme.Spacing.md)
            .background(.black.opacity(0.35), in: RoundedRectangle(cornerRadius: Theme.Radius.medium))
            .padding(.horizontal, Theme.Spacing.md)
    }

    private func startScan() {
        withAnimation(.linear(duration: 2.2)) { scanProgress = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            MagicEngine.performReveal()
            withAnimation(Theme.AnimationCurve.standard) { stage = .reveal }
        }
    }
}

private struct MindReadingCameraSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "Cámara que lee pensamientos") {
            Section {
                Text("El método es idéntico al Detector de pensamiento: la raíz digital de cualquier múltiplo de 9 es siempre 9. La cámara frontal solo aporta valor teatral, no realiza ningún análisis real.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
