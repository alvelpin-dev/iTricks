import SwiftUI
import PhotosUI

/// "El Post de Instagram Fantasma" — Tecnología.
///
/// Método real (integrado en la app): el mago elige, una sola vez al
/// preparar el efecto, su propia captura editada del perfil (con el área
/// del papel en blanco) usando el selector de fotos nativo de iOS
/// (`PhotosPicker`). Durante la actuación, la app superpone en vivo la
/// palabra elegida sobre esa zona en blanco con Core Graphics, mostrando
/// el resultado a pantalla completa.
enum GhostInstagramPostEffect: EffectModule {
    static let info = EffectInfo(
        id: "ghost_instagram_post",
        name: "El Post de Instagram Fantasma",
        category: .technology,
        shortDescription: "Alguien elige una palabra de un libro. Tu perfil de Instagram ya tiene, desde hace horas, una foto sosteniendo esa palabra.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "photo.stack.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a alguien que elija una palabra de un libro. Entras a tu perfil de Instagram y le muestras tu última publicación: una foto tuya subida horas antes donde sostienes un papel con esa palabra exacta escrita a mano.",
            preparation: [
                "Prepara con antelación una captura de pantalla editada de tu perfil de Instagram, donde sostienes un papel cuya área central queda en blanco.",
                "Guarda esa imagen en un lugar accesible para el atajo.",
                "Configura el atajo para que solicite la palabra elegida y la \"dibuje\" sobre el área en blanco antes de mostrar la imagen a pantalla completa."
            ],
            performance: [
                "Pide a alguien que elija libremente una palabra de cualquier libro disponible.",
                "Introduce esa palabra en el atajo de forma disimulada, mientras hablas de otra cosa.",
                "Abre el atajo camuflado como Instagram, mostrando la imagen ya combinada a pantalla completa.",
                "Deja que el espectador vea la \"publicación\" con la palabra exacta, fechada horas antes de la actuación."
            ],
            script: [
                "\"Elige cualquier palabra de este libro, la que tú quieras.\"",
                "\"Vamos a entrar a mi Instagram a ver mi última publicación...\"",
                "\"Esta foto la subí hace horas. Mira lo que sostengo.\""
            ],
            recoveryTips: [
                "Si tardas en introducir la palabra, gana tiempo charlando sobre el libro o la elección antes de \"abrir Instagram\".",
                "Ten siempre la imagen base bien encuadrada y editada para que el papel en blanco sea perfectamente creíble como un papel real en la foto original."
            ],
            performanceTips: [
                "Cuanto más casual sea tu manera de \"entrar a Instagram\", más creíble resulta que es tu perfil real.",
                "No reveles que la imagen es una sola foto estática: desplázate ligeramente como si estuvieras navegando por el perfil antes de mostrarla."
            ],
            variations: [
                "Usa la misma técnica con un mensaje en vez de una palabra suelta, ajustando el área en blanco del papel.",
                "Combínalo con la Foto del futuro para una rutina de \"redes sociales imposibles\" más larga."
            ],
            commonMistakes: [
                "Usar una imagen base de mala calidad o con una iluminación distinta a la palabra superpuesta, lo que rompe la ilusión.",
                "Introducir la palabra demasiado despacio, generando una pausa sospechosa antes de mostrar el resultado."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide que se elija libremente una palabra de un libro.",
                spectatorAction: "Elige una palabra cualquiera, creyendo que es completamente al azar.",
                simulationNote: "La palabra se introduce en el atajo en el momento, de forma disimulada."
            ),
            PracticeStep(
                performerAction: "Abre el atajo camuflado como Instagram y muestra el resultado combinado.",
                spectatorAction: "Ve la publicación con la palabra exacta, fechada antes de la actuación.",
                simulationNote: "La imagen es una vista rápida de una captura pre-editada con la palabra superpuesta sobre el área en blanco."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(GhostInstagramPostPerformView()) }
    static func settingsView() -> AnyView { AnyView(GhostInstagramPostSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct GhostInstagramPostPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("ghost_instagram_overlay_x") private var overlayX = 0.5
    @AppStorage("ghost_instagram_overlay_y") private var overlayY = 0.55
    @State private var baseImageData: Data?
    @State private var word = ""
    @State private var resultImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.md) {
                if let resultImage {
                    Image(uiImage: resultImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.medium))
                        .padding(Theme.Spacing.md)
                    SecondaryButton("Repetir con otra palabra", symbol: "arrow.counterclockwise") {
                        self.resultImage = nil
                        word = ""
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                } else if let baseImageData, let baseImage = UIImage(data: baseImageData) {
                    Image(uiImage: baseImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.medium))
                        .padding(Theme.Spacing.md)
                        .opacity(0.4)

                    TextField("Palabra elegida por el espectador", text: $word)
                        .multilineTextAlignment(.center)
                        .padding().glassCardStyle()
                        .padding(.horizontal, Theme.Spacing.lg)

                    PrimaryButton("Mostrar publicación", symbol: "photo.fill", tint: .pink) {
                        reveal(baseImage: baseImage)
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .disabled(word.trimmingCharacters(in: .whitespaces).isEmpty)
                } else {
                    Spacer()
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 48))
                        .foregroundStyle(.pink)
                    Text("No has elegido tu captura de Instagram todavía")
                        .font(Theme.Typography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.lg)
                    Text("Configúrala en los ajustes secretos de este efecto")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .onAppear {
                baseImageData = UserDefaults.standard.data(forKey: "ghost_instagram_base_image")
            }
        }
    }

    private func reveal(baseImage: UIImage) {
        resultImage = Self.overlay(word: word, on: baseImage, relativeX: overlayX, relativeY: overlayY)
        HapticManager.shared.impact(.medium)
        MagicEngine.performReveal()
    }

    private static func overlay(word: String, on image: UIImage, relativeX: Double, relativeY: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { _ in
            image.draw(at: .zero)
            let fontSize = image.size.width * 0.07
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Marker Felt", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            let text = NSAttributedString(string: word.uppercased(), attributes: attributes)
            let size = text.size()
            let origin = CGPoint(
                x: image.size.width * relativeX - size.width / 2,
                y: image.size.height * relativeY - size.height / 2
            )
            text.draw(at: origin)
        }
    }
}

private struct GhostInstagramPostSettingsView: View {
    @AppStorage("ghost_instagram_overlay_x") private var overlayX = 0.5
    @AppStorage("ghost_instagram_overlay_y") private var overlayY = 0.55
    @State private var selectedItem: PhotosPickerItem?
    @State private var previewData: Data?
    @State private var imageSize: CGSize = .zero

    var body: some View {
        SecretConfigScreen(title: "El Post de Instagram Fantasma") {
            Section("Captura base de tu perfil") {
                if let previewData, let image = UIImage(data: previewData) {
                    ZStack(alignment: .topLeading) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.medium))
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear { imageSize = geo.size }
                                        .onChange(of: geo.size) { imageSize = $0 }
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                guard imageSize != .zero else { return }
                                overlayX = location.x / imageSize.width
                                overlayY = location.y / imageSize.height
                                HapticManager.shared.impact(.light)
                            }

                        if imageSize != .zero {
                            Circle()
                                .fill(Color.pink)
                                .frame(width: 18, height: 18)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .position(
                                    x: overlayX * imageSize.width,
                                    y: overlayY * imageSize.height
                                )
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(maxHeight: 300)

                    Text("Toca sobre la imagen para marcar dónde aparecerá la palabra. El punto rosa muestra la posición actual.")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                }
                PhotosPicker("Elegir captura de pantalla", selection: $selectedItem, matching: .images)
            }
            Section {
                Text("Elige una captura de tu perfil de Instagram con el área del papel en blanco. Toca directamente sobre esa zona para fijar la posición donde se superpondrá la palabra del espectador.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
        .onAppear {
            previewData = UserDefaults.standard.data(forKey: "ghost_instagram_base_image")
        }
        .onChange(of: selectedItem) { item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    UserDefaults.standard.set(data, forKey: "ghost_instagram_base_image")
                    previewData = data
                }
            }
        }
    }
}
