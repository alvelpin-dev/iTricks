import SwiftUI
import AVFoundation

/// "El Lector de Códigos de Barras Mental" — Mentalismo.
///
/// Método real (integrado en la app): un escaneo de código real con
/// `AVCaptureMetadataOutput` (la cámara detecta de verdad el tipo de
/// símbolo: QR, EAN-13, Code128…). El contenido del código se ignora,
/// pero el tipo de símbolo detectado sí se usa para elegir, entre varios
/// textos de personalidad preescritos, cuál mostrar — combinando un dato
/// real con una respuesta preparada.
enum BarcodeMindReaderEffect: EffectModule {
    static let info = EffectInfo(
        id: "barcode_mind_reader",
        name: "El Lector de Códigos de Barras Mental",
        category: .mentalism,
        shortDescription: "Escaneas el código de barras de cualquier objeto. En vez del precio, aparece un rasgo exacto de la personalidad del espectador.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "barcode.viewfinder",
        instructions: EffectInstructions(
            whatItDoes: "Escaneas el código de barras de cualquier producto de la habitación con tu iPhone. En lugar de aparecer el precio o el nombre del objeto, aparece una ventana emergente que describe un rasgo de la personalidad del espectador con precisión sorprendente.",
            preparation: [
                "Investiga discretamente algún rasgo de personalidad del espectador antes del show (observación, conversación previa, lectura en frío) para que el texto resulte impactante y específico.",
                "Escribe ese texto en la configuración secreta de este efecto antes de actuar."
            ],
            performance: [
                "Presenta el teléfono como un escáner capaz de leer la energía de los objetos y, a través de ellos, la personalidad de quien los toca.",
                "Pide al espectador que sostenga o señale cualquier objeto con código de barras en la sala.",
                "Escanea el código con normalidad, dejando que la cámara enfoque claramente la línea de barras.",
                "Revela la alerta con el rasgo de personalidad, presentándolo como un análisis preciso del objeto."
            ],
            script: [
                "\"Los objetos que tocamos guardan parte de nuestra energía. Vamos a escanear este código.\"",
                "\"El código en sí no importa, lo que importa es lo que revela de quien lo ha tocado.\"",
                "\"Esto describe exactamente cómo eres tú.\""
            ],
            recoveryTips: [
                "Si el escáner no reconoce el código a la primera, sigue intentándolo con normalidad: el resultado final no depende del escaneo real.",
                "Ten dos o tres textos de personalidad preparados para distintos espectadores si vas a repetir el efecto en la misma sesión."
            ],
            performanceTips: [
                "Cuanto más específico y personal sea el texto preparado, más impactante resulta el efecto; evita generalidades vagas.",
                "Deja que el espectador elija el objeto libremente: refuerza que no hay ningún control sobre qué se escanea."
            ],
            variations: [
                "Usa la misma estructura para revelar un secreto o un mensaje motivacional en vez de un rasgo de personalidad.",
                "Combínalo con el Detector de objetos para una rutina de \"escáner mágico\" más larga."
            ],
            commonMistakes: [
                "Usar un texto de personalidad demasiado genérico que podría aplicarse a cualquier persona.",
                "No practicar el enfoque de la cámara, lo que puede generar una pausa incómoda al intentar escanear repetidamente."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Investiga un rasgo de personalidad específico del espectador antes del show.",
                spectatorAction: "No sospecha que se está preparando información sobre él.",
                simulationNote: "Esta investigación previa es el verdadero método, no el escaneo en sí."
            ),
            PracticeStep(
                performerAction: "Escanea el código de barras de un objeto elegido libremente por el espectador.",
                spectatorAction: "Elige cualquier objeto con código de barras de la sala.",
                simulationNote: "El atajo ignora el resultado real del escaneo por completo."
            ),
            PracticeStep(
                performerAction: "Revela la alerta con el rasgo de personalidad preescrito.",
                spectatorAction: "Se sorprende de la precisión del análisis.",
                simulationNote: "El texto fue escrito de antemano en la configuración secreta del efecto."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(BarcodeMindReaderPerformView()) }
    static func settingsView() -> AnyView { AnyView(BarcodeMindReaderSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct BarcodeMindReaderPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraController()
    @AppStorage("barcode_text_qr") private var textForQR = "Eres alguien que conecta ideas distintas con facilidad."
    @AppStorage("barcode_text_ean") private var textForEAN = "Tienes una memoria mucho mejor de lo que crees."
    @AppStorage("barcode_text_other") private var textForOther = "Confías en tu instinto más de lo que admites."
    @State private var resultText: String?

    var body: some View {
        ZStack {
            CameraPreviewView(controller: camera).ignoresSafeArea()
                .overlay(Color.black.opacity(0.15))

            VStack {
                Spacer()
                if let resultText {
                    Text(resultText)
                        .font(Theme.Typography.headline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(Theme.Spacing.md)
                        .background(.black.opacity(0.4), in: RoundedRectangle(cornerRadius: Theme.Radius.medium))
                        .padding(.horizontal, Theme.Spacing.md)
                } else {
                    Text("Apunta a cualquier código de barras")
                        .font(Theme.Typography.body)
                        .foregroundStyle(.white)
                }
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.top, Theme.Spacing.sm)
                    .padding(.bottom, Theme.Spacing.xl)
            }
        }
        .onAppear { camera.start(scansMetadata: true) }
        .onDisappear { camera.stop() }
        .onChange(of: camera.lastDetectedSymbology) { symbology in
            guard let symbology, resultText == nil else { return }
            reveal(for: symbology)
        }
    }

    private func reveal(for symbology: AVMetadataObject.ObjectType) {
        let text: String
        switch symbology {
        case .qr, .pdf417:
            text = textForQR
        case .ean13, .ean8, .upce:
            text = textForEAN
        default:
            text = textForOther
        }
        HapticManager.shared.impact(.medium)
        withAnimation(Theme.AnimationCurve.standard) { resultText = text }
        MagicEngine.performReveal()
    }
}

private struct BarcodeMindReaderSettingsView: View {
    @AppStorage("barcode_text_qr") private var textForQR = "Eres alguien que conecta ideas distintas con facilidad."
    @AppStorage("barcode_text_ean") private var textForEAN = "Tienes una memoria mucho mejor de lo que crees."
    @AppStorage("barcode_text_other") private var textForOther = "Confías en tu instinto más de lo que admites."

    var body: some View {
        SecretConfigScreen(title: "El Lector de Códigos de Barras Mental") {
            Section("Texto para códigos QR") {
                TextField("Texto de personalidad", text: $textForQR, axis: .vertical)
            }
            Section("Texto para códigos de producto (EAN/UPC)") {
                TextField("Texto de personalidad", text: $textForEAN, axis: .vertical)
            }
            Section("Texto para otros códigos") {
                TextField("Texto de personalidad", text: $textForOther, axis: .vertical)
            }
            Section {
                Text("El escaneo es real: la cámara detecta de verdad el tipo de código. Según sea QR, un código de producto (EAN/UPC) u otro tipo, se muestra uno de los tres textos configurados aquí.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
