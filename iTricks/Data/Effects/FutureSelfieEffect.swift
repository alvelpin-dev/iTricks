import SwiftUI

/// "La Foto del Futuro" — Tecnología.
///
/// Método real (integrado en la app): se toma una foto real con la
/// cámara (`CameraController.capturePhoto`) y, en el momento, se le
/// superpone digitalmente el nombre del espectador sobre la zona de la
/// mano mediante Core Graphics. El resultado se muestra solo dentro de
/// iTricks (no se guarda en el carrete real), evitando pedir permiso de
/// galería y dejando cero rastro fuera de la app.
enum FutureSelfieEffect: EffectModule {
    static let info = EffectInfo(
        id: "future_selfie",
        name: "La Foto del Futuro",
        category: .technology,
        shortDescription: "Te haces una selfie real con el espectador. Al verla, sostienes un cartel con su nombre que nunca existió.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "camera.badge.ellipsis",
        instructions: EffectInstructions(
            whatItDoes: "Te haces una selfie real con el espectador desde la propia app. Al momento, la foto capturada muestra al mago sosteniendo un cartel con el nombre exacto del espectador, aunque nunca tocó ningún cartel real durante la toma.",
            preparation: [
                "Averigua el nombre del espectador de forma casual al principio de la rutina.",
                "Practica sostener la mano en la posición exacta donde se superpondrá el nombre (la zona se indica en pantalla con una guía discreta solo visible para ti durante la práctica)."
            ],
            performance: [
                "Abre el efecto e introduce el nombre del espectador, capturado de antemano, en el campo correspondiente.",
                "Activa la cámara y haz la foto con el espectador con normalidad, sosteniendo la mano en la posición acordada.",
                "La app superpone el nombre sobre la zona de tu mano en el mismo instante de la captura.",
                "Muestra el resultado en pantalla: el espectador verá su nombre en un cartel que nunca existió durante la foto."
            ],
            script: [
                "\"Vamos a hacernos una foto juntos, sonríe.\"",
                "\"Mira esto...\"",
                "\"¿Cómo puede ser que yo esté sosteniendo tu nombre si nunca tuve ningún cartel?\""
            ],
            recoveryTips: [
                "Si la superposición no queda en la posición exacta de tu mano, puedes repetir la foto cuantas veces quieras antes de mostrarla.",
                "Ten siempre verificada la ortografía exacta del nombre antes de la actuación."
            ],
            performanceTips: [
                "Sostén la mano de forma natural durante la foto, en la posición acordada, para que el resultado final parezca auténtico.",
                "No mires la pantalla justo después de la foto: deja que sea el espectador quien la vea y descubra el detalle."
            ],
            variations: [
                "En vez de un nombre, usa una palabra que el espectador haya elegido libremente durante la rutina.",
                "Combínalo con el Post de Instagram fantasma para un cierre de rutina con doble impacto visual."
            ],
            commonMistakes: [
                "No comprobar la iluminación antes de la foto, lo que puede dificultar ver la superposición con claridad.",
                "Mostrar la foto demasiado rápido, sin dar tiempo a que el espectador procese lo que está viendo."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Introduce el nombre del espectador capturado al inicio de la rutina.",
                spectatorAction: "No sabe que su nombre se usará en esta fase.",
                simulationNote: "El nombre se introduce en un campo de texto antes de abrir la cámara."
            ),
            PracticeStep(
                performerAction: "Haz la foto real con el espectador, sosteniendo la mano en la posición acordada.",
                spectatorAction: "Posa con normalidad para la foto, sin sospechar nada especial.",
                simulationNote: "La app toma la foto real y superpone el nombre en el mismo instante."
            ),
            PracticeStep(
                performerAction: "Muestra el resultado en pantalla.",
                spectatorAction: "Descubre su nombre en un cartel que nunca existió durante la foto.",
                simulationNote: "La superposición se calcula con Core Graphics sobre la foto real capturada."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(FutureSelfiePerformView()) }
    static func settingsView() -> AnyView { AnyView(FutureSelfieSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum FutureSelfieStage {
    case nameEntry, camera, result
}

private struct FutureSelfiePerformView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraController()
    @AppStorage("future_selfie_name") private var spectatorName = ""
    @AppStorage("future_selfie_overlay_x") private var overlayX = 0.5
    @AppStorage("future_selfie_overlay_y") private var overlayY = 0.78
    @State private var stage: FutureSelfieStage = .nameEntry
    @State private var resultImage: UIImage?

    var body: some View {
        NavigationStack {
            ZStack {
                switch stage {
                case .nameEntry: nameEntryContent
                case .camera: cameraContent
                case .result: resultContent
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var nameEntryContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(.teal)
            Text("Nombre del espectador")
                .font(Theme.Typography.title)
            TextField("Nombre", text: $spectatorName)
                .multilineTextAlignment(.center)
                .padding()
                .glassCardStyle()
                .padding(.horizontal, Theme.Spacing.lg)
            PrimaryButton("Abrir cámara", symbol: "camera.fill", tint: .teal) {
                camera.start(capturesPhotos: true)
                withAnimation { stage = .camera }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .disabled(spectatorName.trimmingCharacters(in: .whitespaces).isEmpty)
            Spacer()
        }
    }

    private var cameraContent: some View {
        ZStack(alignment: .bottom) {
            CameraPreviewView(controller: camera).ignoresSafeArea()
            PrimaryButton("Capturar", symbol: "camera.fill", tint: .teal) {
                capture()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .onDisappear { camera.stop() }
    }

    private var resultContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            if let resultImage {
                Image(uiImage: resultImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.medium))
                    .padding(Theme.Spacing.md)
            }
            SecondaryButton("Repetir foto", symbol: "arrow.counterclockwise") {
                withAnimation { stage = .camera }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.md)
        }
    }

    private func capture() {
        camera.capturePhoto { image in
            guard let image else { return }
            HapticManager.shared.impact(.medium)
            resultImage = Self.overlay(name: spectatorName, on: image, relativeX: overlayX, relativeY: overlayY)
            camera.stop()
            withAnimation(Theme.AnimationCurve.standard) { stage = .result }
            MagicEngine.performReveal()
        }
    }

    private static func overlay(name: String, on image: UIImage, relativeX: Double, relativeY: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { _ in
            image.draw(at: .zero)

            let fontSize = image.size.width * 0.06
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: UIColor.black,
                .backgroundColor: UIColor.white
            ]
            let text = NSAttributedString(string: " \(name) ", attributes: attributes)
            let textSize = text.size()
            let origin = CGPoint(
                x: image.size.width * relativeX - textSize.width / 2,
                y: image.size.height * relativeY - textSize.height / 2
            )
            text.draw(at: origin)
        }
    }
}

private struct FutureSelfieSettingsView: View {
    @AppStorage("future_selfie_overlay_x") private var overlayX = 0.5
    @AppStorage("future_selfie_overlay_y") private var overlayY = 0.78

    var body: some View {
        SecretConfigScreen(title: "La Foto del Futuro") {
            Section("Posición del cartel sobre la foto") {
                VStack(alignment: .leading) {
                    Text("Horizontal")
                    Slider(value: $overlayX, in: 0...1)
                }
                VStack(alignment: .leading) {
                    Text("Vertical")
                    Slider(value: $overlayY, in: 0...1)
                }
            }
            Section {
                Text("Ajusta estos valores para que el nombre quede situado exactamente sobre la zona donde sueles colocar la mano al hacer la foto.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
