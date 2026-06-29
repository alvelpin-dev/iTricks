import SwiftUI

/// "La Moneda que Atraviesa la Pantalla" — Herramientas.
///
/// Método real (integrado en la app): el Toque Posterior no es accesible
/// a apps normales, así que el disparador es la detección real de golpe
/// seco por acelerómetro (`SensorManager.shakeDetected`, igual que en
/// Moneda imposible y Dado mental). En el instante del golpe contra la
/// mano, la imagen de la moneda cambia a negro, sincronizada con la
/// caída real de una moneda física retenida con técnica clásica.
enum CoinThroughScreenEffect: EffectModule {
    static let info = EffectInfo(
        id: "coin_through_screen",
        name: "La Moneda que Atraviesa la Pantalla",
        category: .tools,
        shortDescription: "Una moneda digital flota en la pantalla. Golpeas el teléfono contra tu mano y cae una moneda real, mientras la digital desaparece.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "circle.dashed",
        instructions: EffectInstructions(
            whatItDoes: "Muestras una moneda digital flotando en la pantalla de tu iPhone. Colocas tu mano física debajo del teléfono, das un golpe seco, y la moneda desaparece de la pantalla al mismo tiempo que cae una moneda real en tu mano.",
            preparation: [
                "Prepara una imagen de una moneda sobre fondo negro, a pantalla completa, lo más realista posible.",
                "Activa Toque Posterior con triple toque en Ajustes > Accesibilidad > Toque posterior, asignado a este atajo.",
                "Practica el palmeo o retención de una moneda real en la mano que sostiene el teléfono por debajo, de forma que puedas soltarla en el golpe seco.",
                "Ensaya el triple toque contra la palma de tu mano hasta que sea indistinguible de un simple golpe."
            ],
            performance: [
                "Muestra la imagen de la moneda flotando en la pantalla con naturalidad.",
                "Coloca tu mano libre debajo del teléfono, con la moneda real ya preparada en tu palma o retenida con técnica clásica.",
                "Da un golpe seco con el teléfono contra tu mano: este gesto disparará el triple toque en la parte trasera.",
                "En el mismo instante, suelta la moneda real para que parezca caer desde la pantalla, mientras la imagen cambia a negro."
            ],
            script: [
                "\"Mira esta moneda en la pantalla, está atrapada ahí dentro.\"",
                "\"Voy a darle un golpe seco para que salga.\"",
                "\"Ahí está, en mi mano. Y mira la pantalla: ya no está.\""
            ],
            recoveryTips: [
                "Practica muchísimo el triple toque antes de actuar: si no se activa, la imagen seguirá visible y delatará el método.",
                "Si el toque no se detecta a la primera, puedes repetir el golpe disimuladamente con una frase como \"a veces hace falta un segundo golpe\"."
            ],
            performanceTips: [
                "El sonido del golpe seco debe ser convincente; practica la fuerza exacta que activa el sensor sin sonar artificial.",
                "Sincroniza el sonido de la moneda cayendo en tu mano con el cambio de imagen para maximizar el efecto."
            ],
            variations: [
                "Usa el mismo método para hacer \"aparecer\" en la pantalla un objeto que sostenías oculto, en vez de hacerlo desaparecer.",
                "Combínalo con Moneda imposible para una rutina de monedas más larga, alternando métodos."
            ],
            commonMistakes: [
                "No practicar suficiente el triple toque, lo que provoca fallos de activación visibles para el público.",
                "Mover la mano que sostiene la moneda real de forma sospechosa antes del golpe."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Muestra la moneda digital en pantalla y coloca la mano con la moneda real preparada debajo.",
                spectatorAction: "Observa la moneda digital flotando en la pantalla.",
                simulationNote: "La moneda real ya está oculta en tu mano antes de empezar el efecto."
            ),
            PracticeStep(
                performerAction: "Da un golpe seco que dispare el triple toque y suelta la moneda real al mismo tiempo.",
                spectatorAction: "Ve y oye la moneda caer en la mano del mago, justo cuando la imagen desaparece.",
                simulationNote: "El Toque Posterior cambia la imagen a negro en el mismo instante del golpe físico."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(CoinThroughScreenPerformView()) }
    static func settingsView() -> AnyView { AnyView(CoinThroughScreenSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct CoinThroughScreenPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @State private var vanished = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()
                if !vanished {
                    ZStack {
                        Circle().fill(Color.yellow).frame(width: 140, height: 140)
                        Circle().stroke(Color.black.opacity(0.2), lineWidth: 3).frame(width: 140, height: 140)
                    }
                    .transition(.opacity)
                }
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, Theme.Spacing.md)
            }
        }
        .overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 60, height: 60)
                .contentShape(Rectangle())
                .onTapGesture { vanish() }
                .accessibilityHidden(true)
        }
        .onAppear { sensors.startMotionUpdates() }
        .onChange(of: sensors.shakeDetected) { detected in
            if detected { vanish() }
        }
        .onDisappear { sensors.stopMotionUpdates() }
    }

    private func vanish() {
        guard !vanished else { return }
        HapticManager.shared.impact(.rigid)
        MagicEngine.performReveal(sound: .whoosh)
        withAnimation(Theme.AnimationCurve.snappy) { vanished = true }
    }
}

private struct CoinThroughScreenSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "La Moneda que Atraviesa la Pantalla") {
            Section {
                Text("El golpe seco real del teléfono contra tu mano se detecta por acelerómetro y cambia la imagen a negro automáticamente. La esquina superior derecha es un botón de respaldo invisible por si el golpe no se detecta a la primera.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
