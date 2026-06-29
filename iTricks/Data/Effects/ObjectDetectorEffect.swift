import SwiftUI

/// "Detector de objetos" — Tecnología.
///
/// Usa la cámara real del iPhone para mostrar una previsualización en
/// vivo (tecnología genuina de AVFoundation), mientras el "reconocimiento"
/// del objeto lo decide el mago con un control discreto, igual que el
/// patrón ya usado en los detectores paranormales. El valor real aportado
/// por el hardware es la imagen en vivo, que vende visualmente la idea de
/// un análisis por visión artificial.
enum ObjectDetectorEffect: EffectModule {
    static let info = EffectInfo(
        id: "object_detector",
        name: "Detector de objetos",
        category: .technology,
        shortDescription: "Apunta la cámara a cualquier objeto que el espectador eligió en tu ausencia y la app lo identifica.",
        difficulty: .intermediate,
        preparationTime: .none,
        symbol: "camera.viewfinder",
        instructions: EffectInstructions(
            whatItDoes: "Mientras el mago no mira, el espectador elige libremente un objeto cualquiera de la sala. El mago apunta la cámara del teléfono hacia distintos objetos y, al apuntar al elegido, la app lo \"reconoce\" y lo anuncia en pantalla.",
            preparation: [
                "Acuerda con un cómplice (o usa una técnica de codificación verbal/visual propia) una señal discreta para identificar cuál es el objeto elegido por el espectador.",
                "Si no usas cómplice, practica una técnica de \"un objeto por delante\" (one-ahead): el primer objeto que se nombra en realidad corresponde a la elección anterior, desplazando la revelación una posición."
            ],
            performance: [
                "Pide a alguien del público que señale o piense en un objeto de la sala mientras te das la vuelta o sales de la habitación.",
                "Vuelve y empieza a apuntar la cámara hacia varios objetos distintos, fingiendo que la app los analiza uno a uno.",
                "Cuando tengas identificado (por tu método) cuál es el objeto correcto, apúntalo y toca la zona oculta para que la app lo anuncie.",
                "Deja que la app muestre el nombre del objeto en pantalla con una animación de \"análisis completado\"."
            ],
            script: [
                "\"Mientras yo no miraba, has elegido un objeto cualquiera de esta sala.\"",
                "\"Voy a usar la cámara para escanear varios objetos y ver cuál coincide con tu elección.\"",
                "\"Ahí está... has elegido este.\""
            ],
            recoveryTips: [
                "Si no estás seguro de cuál es el objeto correcto, sigue apuntando a varios más para ganar tiempo mientras confirmas tu método de identificación.",
                "Si usas la técnica one-ahead, asegúrate de nombrar siempre un objeto antes de pedir el siguiente para mantener el desplazamiento correcto."
            ],
            performanceTips: [
                "Apunta a varios objetos incorrectos antes del correcto, para que parezca que la app realmente está analizando cada uno.",
                "Añade una breve pausa dramática con el sonido de \"análisis\" antes de revelar el objeto correcto."
            ],
            variations: [
                "Usa la técnica con cartas en vez de objetos: el espectador elige una carta de un mazo extendido y la cámara la \"reconoce\".",
                "Combínalo con un cómplice entre el público que te da la señal del objeto correcto de forma completamente disimulada."
            ],
            commonMistakes: [
                "Apuntar directamente al objeto correcto sin pasar antes por varios incorrectos, lo que resulta sospechosamente directo.",
                "Revelar el nombre del objeto antes de que la animación de \"análisis\" termine."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Sal de la sala o date la vuelta mientras el espectador elige un objeto.",
                spectatorAction: "Elige libremente un objeto visible en la sala.",
                simulationNote: "El método para identificar el objeto (cómplice o one-ahead) ocurre fuera de la app."
            ),
            PracticeStep(
                performerAction: "Apunta la cámara a varios objetos, terminando en el correcto, y toca la zona oculta.",
                spectatorAction: "Observa cómo la cámara \"analiza\" distintos objetos antes de acertar.",
                simulationNote: "La app solo necesita tu toque para anunciar el resultado; el reconocimiento real lo decides tú."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ObjectDetectorPerformView()) }
    static func settingsView() -> AnyView { AnyView(ObjectDetectorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct ObjectDetectorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraController()
    @AppStorage("object_detector_label") private var objectLabel = "Reloj de pulsera"
    @State private var isAnalyzing = false
    @State private var result: String?

    var body: some View {
        ZStack {
            CameraPreviewView(controller: camera)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.25))

            VStack {
                Spacer()
                VStack(spacing: Theme.Spacing.md) {
                    if let result {
                        Text(result)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    } else {
                        Text(isAnalyzing ? "Analizando…" : "Apunta a un objeto")
                            .font(Theme.Typography.headline)
                            .foregroundStyle(.white)
                    }
                    Button("Cerrar") { dismiss() }
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
        .overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 90, height: 90)
                .contentShape(Rectangle())
                .onTapGesture { revealObject() }
                .accessibilityHidden(true)
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

    private func revealObject() {
        guard !isAnalyzing else { return }
        isAnalyzing = true
        HapticManager.shared.impact(.light)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAnalyzing = false
            withAnimation(Theme.AnimationCurve.standard) { result = objectLabel }
            MagicEngine.performReveal()
        }
    }
}

private struct ObjectDetectorSettingsView: View {
    @AppStorage("object_detector_label") private var objectLabel = "Reloj de pulsera"

    var body: some View {
        SecretConfigScreen(title: "Detector de objetos") {
            Section("Objeto a anunciar") {
                TextField("Ej. Reloj de pulsera", text: $objectLabel)
            }
            Section {
                Text("Toca la esquina superior derecha cuando tengas identificado (por tu propio método: cómplice o one-ahead) el objeto correcto, para que la app lo anuncie con la animación de análisis.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Control oculto")
            }
        }
    }
}
