import SwiftUI

/// "La Predicción en la Pantalla de Bloqueo" — Cartas.
///
/// Método real (integrado en la app): Apple no permite que una app de
/// terceros cambie el fondo de pantalla real del sistema ni lea el Toque
/// Posterior. En su lugar, iTricks detecta un zarandeo real del teléfono
/// (acelerómetro, `SensorManager.shakeDetected`, igual que en Dado mental
/// y Moneda imposible) y, al detectarlo, sustituye la pantalla por una
/// réplica fiel de la pantalla de bloqueo de iOS con la carta forzada de
/// fondo. El espectador nunca ve la app real: la sustitución es completa.
enum LockScreenPredictionEffect: EffectModule {
    static let info = EffectInfo(
        id: "lock_screen_prediction",
        name: "La Predicción en la Pantalla de Bloqueo",
        category: .cards,
        shortDescription: "Un espectador nombra una carta. Zarandeas el teléfono al sacarlo del bolsillo y su pantalla de bloqueo ya la muestra.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "lock.rectangle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Un espectador nombra una carta cualquiera, previamente forzada. Sacas tu teléfono del bolsillo con un movimiento natural y, al encender la pantalla, una réplica exacta de la pantalla de bloqueo de iOS muestra esa misma carta como fondo.",
            preparation: [
                "Elige en la configuración secreta la carta que vas a forzar.",
                "Combina este efecto con Adivina cualquier carta o cualquier técnica de fuerza de carta, para garantizar qué carta va a nombrar el espectador.",
                "Practica el gesto de sacar el teléfono del bolsillo con un movimiento firme: ese mismo gesto es el que dispara la detección de zarandeo."
            ],
            performance: [
                "Fuerza la elección de la carta mediante la técnica que prefieras.",
                "Abre este efecto antes de empezar y guarda el teléfono en el bolsillo.",
                "Cuando el espectador nombre la carta, saca el teléfono con un movimiento natural pero firme.",
                "El zarandeo real del gesto activa la sustitución de pantalla automáticamente.",
                "Muestra la pantalla: la réplica de bloqueo con la carta forzada ya está mostrándose."
            ],
            script: [
                "\"Nombra cualquier carta de la baraja, la que tú quieras.\"",
                "\"Voy a sacar mi teléfono... fíjate en la pantalla de bloqueo.\"",
                "\"¿Cómo puede ser que ya estuviera ahí?\""
            ],
            recoveryTips: [
                "Si el zarandeo no se detecta a la primera, un toque oculto en la esquina superior de la pantalla dispara la misma sustitución manualmente.",
                "Practica la fuerza exacta del gesto de sacar el teléfono para que el sensor lo detecte de forma consistente."
            ],
            performanceTips: [
                "No mires el teléfono mientras lo sacas; mantén el contacto visual con el público para que el momento de la revelación sea más fuerte.",
                "La réplica de pantalla de bloqueo incluye la hora real del sistema, lo que la hace indistinguible de la real a primera vista."
            ],
            variations: [
                "En vez de cartas, usa esta misma técnica para forzar un número, un nombre o un emoji.",
                "Combínalo con cualquier efecto de fuerza de carta del repertorio."
            ],
            commonMistakes: [
                "Sacar el teléfono con un movimiento demasiado suave, que no llega al umbral de detección del zarandeo.",
                "Mantener la réplica en pantalla demasiado tiempo: un toque en cualquier parte de la pantalla la cierra, así que tócala poco después de mostrarla."
            ],
            recommendedDuration: "1-2 minutos (más el cierre del forzaje de carta)"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Fuerza la elección de una carta concreta mediante otra técnica del repertorio.",
                spectatorAction: "Cree elegir libremente una carta cualquiera.",
                simulationNote: "La carta nombrada debe coincidir con la que configuraste como forzada."
            ),
            PracticeStep(
                performerAction: "Saca el teléfono del bolsillo con un movimiento natural pero firme.",
                spectatorAction: "No nota ningún gesto especial al ver al mago sacar el teléfono.",
                simulationNote: "El acelerómetro detecta el zarandeo real y sustituye la pantalla automáticamente."
            ),
            PracticeStep(
                performerAction: "Muestra la pantalla con la réplica de bloqueo ya mostrando la carta.",
                spectatorAction: "Ve la carta exacta que nombró, ya en la 'pantalla de bloqueo'.",
                simulationNote: "Es una vista de iTricks idéntica visualmente a la pantalla de bloqueo real, no el sistema operativo."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(LockScreenPredictionPerformView()) }
    static func settingsView() -> AnyView { AnyView(LockScreenPredictionSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct LockScreenPredictionPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("lock_screen_forced_card") private var forcedCard = "AS"
    @State private var revealed = false
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if revealed {
                lockScreenReplica
                    .transition(.opacity)
                    .onTapGesture { withAnimation { revealed = false } }
            } else {
                pocketContent
            }
        }
        .overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 70, height: 70)
                .contentShape(Rectangle())
                .onTapGesture { reveal() }
                .accessibilityHidden(true)
        }
        .onReceive(timer) { now = $0 }
        .onAppear { sensors.startMotionUpdates() }
        .onChange(of: sensors.shakeDetected) { detected in
            if detected { reveal() }
        }
        .onDisappear { sensors.stopMotionUpdates() }
    }

    private var pocketContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Image(systemName: "iphone")
                .font(.system(size: 56))
                .foregroundStyle(.white.opacity(0.6))
            Text("Saca el teléfono del bolsillo con un gesto firme")
                .font(Theme.Typography.body)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.lg)
            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, Theme.Spacing.md)
        }
    }

    private var lockScreenReplica: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Spacer().frame(height: 60)
            Text(now, style: .time)
                .font(.system(size: 76, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
            Text(now, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(Theme.Typography.headline)
                .foregroundStyle(.white.opacity(0.9))

            Spacer()

            VStack(spacing: Theme.Spacing.sm) {
                Image(systemName: suitSymbol)
                    .font(.system(size: 64))
                    .foregroundStyle(suitColor)
                Text(formattedCardName(forcedCard))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }

            Spacer()
            Text("Desliza para desbloquear")
                .font(Theme.Typography.caption)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.bottom, Theme.Spacing.lg)
        }
    }

    private var suitSymbol: String {
        switch forcedCard.suffix(1) {
        case "H": return "suit.heart.fill"
        case "D": return "suit.diamond.fill"
        case "C": return "suit.club.fill"
        default: return "suit.spade.fill"
        }
    }

    private var suitColor: Color {
        switch forcedCard.suffix(1) {
        case "H", "D": return .red
        default: return .white
        }
    }

    private func reveal() {
        guard !revealed else { return }
        HapticManager.shared.impact(.medium)
        withAnimation(Theme.AnimationCurve.standard) { revealed = true }
    }
}

private struct LockScreenPredictionSettingsView: View {
    @AppStorage("lock_screen_forced_card") private var forcedCard = "AS"

    var body: some View {
        SecretConfigScreen(title: "Predicción en pantalla de bloqueo") {
            Section("Carta forzada") {
                Picker("Carta", selection: $forcedCard) {
                    ForEach(PredictionEngine.standardDeck, id: \.self) { card in
                        Text(formattedCardName(card)).tag(card)
                    }
                }
            }
            Section {
                Text("El zarandeo real del gesto de sacar el teléfono del bolsillo (acelerómetro) sustituye la pantalla por una réplica de la pantalla de bloqueo con la carta forzada. También puedes tocar la esquina superior derecha como respaldo manual.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
