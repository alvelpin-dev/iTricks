import SwiftUI
import MediaPlayer

/// "Telepatía Musical con Shazam" — Tecnología.
///
/// Método real (integrado en la app): en vez de simular el sonido,
/// iTricks busca de verdad en la biblioteca musical del dispositivo
/// (`MPMediaQuery`) y reproduce la canción real encontrada con
/// `MPMusicPlayerController`. Se configuran hasta 5 canciones en los
/// ajustes secretos, cada una con su propio toque oculto, según cuál
/// hayas forzado psicológicamente en el espectador. No se incluye
/// ninguna canción con la app: se reproduce desde tu propia biblioteca
/// de Música, evitando cualquier problema de derechos.
enum MusicalTelepathyEffect: EffectModule {
    static let info = EffectInfo(
        id: "musical_telepathy",
        name: "Telepatía Musical con Shazam",
        category: .technology,
        shortDescription: "Alguien piensa en una canción famosa. El teléfono, boca abajo sobre la mesa, empieza a reproducirla solo, de tu propia biblioteca.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "music.note",
        instructions: EffectInstructions(
            whatItDoes: "Pides a alguien que piense en una canción muy famosa. Colocas el teléfono boca abajo sobre la mesa. El espectador se concentra, y de repente el teléfono empieza a reproducir, de tu propia biblioteca musical, exactamente esa canción.",
            preparation: [
                "Añade a tu app Música las 3-5 canciones que vayas a poder forzar, y escribe sus títulos exactos en la configuración secreta de este efecto.",
                "Aprende un forzaje psicológico de canción que dirija casi siempre hacia una de esas pocas canciones preparadas.",
                "Concede el permiso de acceso a Música la primera vez que se solicite, fuera de la actuación."
            ],
            performance: [
                "Conduce al espectador con el forzaje psicológico hacia una de las canciones que tienes preparadas.",
                "Coloca el teléfono boca abajo sobre la mesa, lejos de tus manos si es posible.",
                "Pide que se concentre intensamente en la canción durante unos segundos.",
                "Toca discretamente la zona oculta asociada a esa canción: empezará a reproducirse de tu biblioteca real, como si el teléfono 'hubiera escuchado' su mente."
            ],
            script: [
                "\"Piensa en una canción muy famosa, de las que todo el mundo conoce.\"",
                "\"Concéntrate en ella, en la melodía, en la letra.\"",
                "\"Vamos a ver si el teléfono puede escuchar tu mente.\""
            ],
            recoveryTips: [
                "Si la canción no está en tu biblioteca de Música, no se reproducirá nada: verifica las 3-5 canciones antes de cada actuación.",
                "Ten un atajo 'comodín' con una canción universalmente reconocible como salida si el forzaje no funciona del todo."
            ],
            performanceTips: [
                "Aléjate físicamente del teléfono tras colocarlo en la mesa, reforzando que no lo estás tocando cuando empieza a sonar.",
                "El verdadero trabajo está en el forzaje de canción: dedícale más tiempo de práctica que a la configuración técnica."
            ],
            variations: [
                "Usa la misma técnica con un álbum o artista en vez de una canción concreta, dando más margen al forzaje.",
                "Combínalo con un altavoz Bluetooth en la sala en vez del propio teléfono, para distanciar aún más la sospecha."
            ],
            commonMistakes: [
                "Forzar siempre la misma canción ante el mismo grupo de personas en sesiones distintas.",
                "No comprobar que las canciones siguen estando en tu biblioteca antes de cada actuación."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce el forzaje psicológico de canción.",
                spectatorAction: "Cree elegir una canción famosa de forma completamente libre.",
                simulationNote: "El forzaje determina qué toque oculto vas a activar después."
            ),
            PracticeStep(
                performerAction: "Coloca el teléfono boca abajo y toca la zona oculta de la canción correspondiente.",
                spectatorAction: "Se concentra en la canción mientras observa el teléfono en reposo.",
                simulationNote: "MPMusicPlayerController reproduce la canción real desde tu biblioteca, no un archivo simulado."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MusicalTelepathyPerformView()) }
    static func settingsView() -> AnyView { AnyView(MusicalTelepathySettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct MusicalTelepathyPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("musical_telepathy_songs") private var songsRaw = "Bohemian Rhapsody,Imagine,Yesterday"
    @State private var isPlaying = false
    @State private var statusMessage: String?

    private var songs: [String] {
        songsRaw.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: isPlaying ? "music.note" : "iphone.gen3")
                .font(.system(size: 56))
                .foregroundStyle(.pink)
            Text("Coloca el teléfono boca abajo")
                .font(Theme.Typography.headline)
            if let statusMessage {
                Text(statusMessage)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .overlay(alignment: .bottomLeading) {
            secretZone(index: 0)
        }
        .overlay(alignment: .bottom) {
            secretZone(index: 1)
        }
        .overlay(alignment: .bottomTrailing) {
            secretZone(index: 2)
        }
    }

    private func secretZone(index: Int) -> some View {
        Color.clear
            .frame(width: 90, height: 90)
            .contentShape(Rectangle())
            .onTapGesture {
                guard songs.indices.contains(index) else { return }
                play(songs[index])
            }
            .accessibilityHidden(true)
    }

    private func play(_ title: String) {
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: title, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains))

        guard let item = query.items?.first else {
            statusMessage = "No se encontró '\(title)' en tu biblioteca"
            return
        }

        let player = MPMusicPlayerController.applicationMusicPlayer
        player.setQueue(with: MPMediaItemCollection(items: [item]))
        player.play()
        isPlaying = true
        statusMessage = nil
        HapticManager.shared.impact(.soft)
    }
}

private struct MusicalTelepathySettingsView: View {
    @AppStorage("musical_telepathy_songs") private var songsRaw = "Bohemian Rhapsody,Imagine,Yesterday"

    var body: some View {
        SecretConfigScreen(title: "Telepatía Musical con Shazam") {
            Section("Canciones forzables (separadas por comas)") {
                TextField("Título 1, Título 2, Título 3", text: $songsRaw)
            }
            Section {
                Text("Hay tres zonas táctiles ocultas en la parte inferior de la pantalla de actuación (izquierda, centro, derecha), una por cada canción en el orden en que las escribas aquí. Las canciones deben existir en tu biblioteca de Música para poder reproducirse.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
