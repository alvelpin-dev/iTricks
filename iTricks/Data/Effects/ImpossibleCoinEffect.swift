import SwiftUI

/// "Moneda imposible" — Herramientas.
///
/// Método real: el iPhone detecta, mediante el acelerómetro, el gesto
/// brusco de "lanzar" o cerrar la mano que el mago ejecuta durante una
/// sustracción/vanish real de una moneda física. El sonido y el haptic se
/// disparan exactamente en ese instante, sincronizando la percepción
/// auditiva y táctil del público con el momento del vanish, lo que hace
/// que la sustracción real resulte invisible. La tecnología no sustituye
/// la sutileza: la refuerza.
enum ImpossibleCoinEffect: EffectModule {
    static let info = EffectInfo(
        id: "impossible_coin",
        name: "Moneda imposible",
        category: .tools,
        shortDescription: "Una moneda real desaparece de la mano del mago justo cuando el teléfono detecta el gesto y dispara el sonido del vanish.",
        difficulty: .advanced,
        preparationTime: .seconds,
        symbol: "circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "El mago sostiene una moneda real, la coloca en el teléfono (o cerca de él) y ejecuta un gesto de cierre de mano. En el instante exacto del gesto, el teléfono detecta el movimiento brusco mediante el acelerómetro y reproduce un sonido y una vibración de \"desaparición\", justo cuando la moneda físicamente desaparece de la mano mediante una sustracción real.",
            preparation: [
                "Practica una sustracción de moneda real (palming, retención clásica, o simplemente pasarla a la otra mano) hasta que sea completamente fluida.",
                "Practica el gesto de cierre de mano sobre el teléfono en reposo varias veces para calibrar a qué velocidad de movimiento reacciona el sensor.",
                "Ten siempre un botón de respaldo (toque manual) por si el gesto no se detecta con la fuerza suficiente."
            ],
            performance: [
                "Muestra la moneda real con normalidad y deja que el espectador la vea y la toque si quieres reforzar que es real.",
                "Coloca el teléfono sobre la mesa con la app abierta y la moneda aparentemente sobre tu mano cerca de él.",
                "Ejecuta el gesto de cierre de mano (el momento real del vanish) con normalidad, sin mirar el teléfono.",
                "El sonido y la vibración se disparan automáticamente al detectar el gesto, reforzando la sensación de desaparición real.",
                "Abre la mano vacía: la combinación de sonido, vibración y la sustracción real hacen que la desaparición se perciba como instantánea y total."
            ],
            script: [
                "\"Esta es una moneda completamente normal, la puedes tocar.\"",
                "\"Voy a hacerla desaparecer usando el campo magnético del teléfono.\"",
                "\"¿Ves? Ya no está.\""
            ],
            recoveryTips: [
                "Si el gesto no dispara el sonido a la primera, usa el botón de respaldo discreto en la esquina de la pantalla, que dispara el mismo efecto manualmente.",
                "Si el espectador pide repetir el efecto inmediatamente, cambia la mano o el ángulo para que la sustracción real no se vuelva predecible."
            ],
            performanceTips: [
                "El sonido y la vibración deben acompañar la sustracción, nunca sustituirla: la técnica de manos sigue siendo lo que vende el efecto.",
                "Practica frente a un espejo hasta que el gesto de cierre de mano sea idéntico, lo veas o no detectado por el sensor."
            ],
            variations: [
                "Usa el mismo disparo de sonido/haptic para sincronizar la reaparición de la moneda en otro lugar.",
                "Combínalo con una rutina de aparición y desaparición repetida, alternando manos."
            ],
            commonMistakes: [
                "Mirar el teléfono en el momento del gesto, lo que delata que el truco depende del dispositivo.",
                "Ejecutar el gesto demasiado suave para que el sensor lo detecte, perdiendo la sincronización sonora."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Ejecuta la sustracción real de la moneda mientras realizas el gesto de cierre de mano sobre el teléfono.",
                spectatorAction: "Observa la moneda en la mano del mago, sin sospechar del teléfono.",
                simulationNote: "El acelerómetro detecta el gesto brusco y dispara sonido + haptic en sincronía con el vanish real."
            ),
            PracticeStep(
                performerAction: "Si el gesto no se detecta, usa el botón de respaldo discreto.",
                spectatorAction: "No nota ninguna diferencia entre el disparo automático y el manual.",
                simulationNote: "Ambos disparan exactamente la misma coreografía de sonido y vibración."
            ),
            PracticeStep(
                performerAction: "Abre la mano vacía para revelar la desaparición.",
                spectatorAction: "Ve la mano vacía y escucha/siente la confirmación sensorial de la desaparición.",
                simulationNote: "La combinación multisensorial refuerza la percepción de que la moneda desapareció en ese instante exacto."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(ImpossibleCoinPerformView()) }
    static func settingsView() -> AnyView { AnyView(ImpossibleCoinSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct ImpossibleCoinPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @State private var vanished = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(vanished ? 0 : 0.9))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.2), lineWidth: 3)
                    )
                    .scaleEffect(vanished ? 0.4 : 1)
                    .opacity(vanished ? 0 : 1)
                    .animation(Theme.AnimationCurve.snappy, value: vanished)
                if vanished {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }
            .frame(height: 160)

            Text(vanished ? "¡Desaparecida!" : "Ejecuta el gesto de cierre de mano")
                .font(Theme.Typography.headline)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        // Botón de respaldo discreto si el gesto no se detecta.
        .overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 60, height: 60)
                .contentShape(Rectangle())
                .onTapGesture { triggerVanish() }
                .accessibilityHidden(true)
        }
        .onAppear {
            MagicEngine.beginSession()
            sensors.startMotionUpdates()
        }
        .onChange(of: sensors.shakeDetected) { detected in
            if detected { triggerVanish() }
        }
        .onDisappear { MagicEngine.endSession() }
    }

    private func triggerVanish() {
        guard !vanished else { return }
        MagicEngine.performReveal(sound: .whoosh)
        withAnimation { vanished = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { vanished = false }
        }
    }
}

private struct ImpossibleCoinSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "Moneda imposible") {
            Section {
                Text("El acelerómetro dispara automáticamente el sonido y la vibración al detectar un movimiento brusco (umbral fijo, calibrado para un gesto firme de cierre de mano). La esquina superior derecha de la pantalla es un botón de respaldo invisible por si el gesto no se detecta.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
