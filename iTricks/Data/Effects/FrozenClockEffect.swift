import SwiftUI

/// "El Reloj Detenido en el Tiempo" — Tecnología.
///
/// Método real (integrado en la app): el iPhone nunca cambia su hora de
/// sistema (Apple no lo permite a ninguna app). En su lugar, iTricks
/// renderiza en vivo, con SwiftUI, una réplica del reloj con la hora
/// forzada, y la revela mediante un gesto real de "frotado" detectado
/// con un `DragGesture` que acumula movimiento de ida y vuelta, aplicando
/// desenfoque progresivo hasta el cambio.
enum FrozenClockEffect: EffectModule {
    static let info = EffectInfo(
        id: "frozen_clock",
        name: "El Reloj Detenido en el Tiempo",
        category: .technology,
        shortDescription: "Le pides al espectador una hora especial para él. Frotas la pantalla y la hora mostrada cambia al instante.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "clock.badge.fill",
        instructions: EffectInstructions(
            whatItDoes: "Muestras la pantalla de tu iPhone con la hora real. Le pides al espectador que piense en una hora especial para él. La nombra, frotas la pantalla con el dedo y, mágicamente, la hora mostrada cambia a la que dijo.",
            preparation: [
                "Aprende un forzaje psicológico de hora que conduzca casi siempre hacia horas redondas o significativas (en punto, y media, etc.), y configura esa hora en los ajustes secretos antes de actuar.",
                "Practica el gesto de \"frotar\" la pantalla con un movimiento real de ida y vuelta, ya que es lo que dispara el cambio."
            ],
            performance: [
                "Muestra la pantalla con la hora real, dejando claro que es la hora normal del teléfono.",
                "Conduce con el forzaje hacia la hora que ya tienes configurada y pide que la diga en voz alta.",
                "Frota la pantalla con el dedo, de forma visible, varias veces de ida y vuelta.",
                "La hora real se desenfoca progresivamente con el frotado y revela la hora forzada al alcanzar suficiente movimiento."
            ],
            script: [
                "\"Mira la hora real de mi teléfono.\"",
                "\"Piensa en una hora que sea especial para ti, y dime cuál es.\"",
                "\"Voy a frotar la pantalla... y mira lo que pasa.\""
            ],
            recoveryTips: [
                "Si el espectador dice una hora distinta a la forzada, sigue frotando con normalidad: la revelación tarda un poco más en aparecer, así que tienes margen para reconducir la conversación.",
                "El umbral de frotado necesario es generoso a propósito, para que el gesto se sienta natural y no instantáneo."
            ],
            performanceTips: [
                "El gesto de frotar debe ser visualmente convincente: hazlo con cierta energía, no un simple roce.",
                "Vuelve a cerrar el efecto de forma natural después de la revelación, sin demorarte mostrando la hora forzada."
            ],
            variations: [
                "Usa el mismo método para cambiar \"mágicamente\" la fecha en vez de la hora, adaptando el guion.",
                "Combínalo con una predicción sellada física que indique la hora antes de que el espectador la diga."
            ],
            commonMistakes: [
                "Frotar con un movimiento demasiado pequeño, lo que retrasa mucho la revelación.",
                "Olvidar configurar la hora forzada en los ajustes secretos antes de empezar."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce el forzaje psicológico hacia la hora ya configurada y pide que la diga en voz alta.",
                spectatorAction: "Cree pensar y nombrar una hora completamente libre.",
                simulationNote: "La hora mostrada al final coincide siempre con la configurada en los ajustes secretos."
            ),
            PracticeStep(
                performerAction: "Frota la pantalla mientras activas discretamente la imagen correspondiente.",
                spectatorAction: "Ve la hora 'cambiar' ante sus ojos.",
                simulationNote: "La hora del sistema nunca cambió: solo se muestra una imagen idéntica a la interfaz real."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(FrozenClockPerformView()) }
    static func settingsView() -> AnyView { AnyView(FrozenClockSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct FrozenClockPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("frozen_clock_forced_hour") private var forcedHour = 4
    @AppStorage("frozen_clock_forced_minute") private var forcedMinute = 30
    @State private var revealed = false
    @State private var blurRadius: Double = 0
    @State private var lastTranslationX: CGFloat = 0
    @State private var rubAmount: CGFloat = 0
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: Theme.Spacing.md) {
                Spacer()
                if revealed {
                    Text(forcedTimeString)
                        .font(.system(size: 80, weight: .light, design: .rounded))
                        .foregroundStyle(.white)
                } else {
                    Text(now, style: .time)
                        .font(.system(size: 80, weight: .light, design: .rounded))
                        .foregroundStyle(.white)
                }
                Text(revealed ? "Hora forzada" : "Hora real")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
                Text("Frota la pantalla con el dedo")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.5))
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, Theme.Spacing.md)
            }
            .blur(radius: blurRadius)
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged { value in
                    let delta = abs(value.translation.width - lastTranslationX)
                    rubAmount += delta
                    lastTranslationX = value.translation.width
                    blurRadius = min(12, rubAmount / 60)
                    if rubAmount > 500, !revealed {
                        triggerReveal()
                    }
                }
                .onEnded { _ in lastTranslationX = 0 }
        )
        .onReceive(timer) { now = $0 }
    }

    private var forcedTimeString: String {
        String(format: "%02d:%02d", forcedHour, forcedMinute)
    }

    private func triggerReveal() {
        revealed = true
        HapticManager.shared.impact(.medium)
        withAnimation(.easeOut(duration: 0.5)) { blurRadius = 0 }
        rubAmount = 0
        MagicEngine.performReveal()
    }
}

private struct FrozenClockSettingsView: View {
    @AppStorage("frozen_clock_forced_hour") private var forcedHour = 4
    @AppStorage("frozen_clock_forced_minute") private var forcedMinute = 30

    var body: some View {
        SecretConfigScreen(title: "El Reloj Detenido en el Tiempo") {
            Section("Hora forzada") {
                Picker("Hora", selection: $forcedHour) {
                    ForEach(0..<24, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                }
                Picker("Minuto", selection: $forcedMinute) {
                    ForEach(0..<60, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                }
            }
            Section {
                Text("Al frotar la pantalla con el dedo (acumulando movimiento horizontal de ida y vuelta), la app difumina la hora real y revela la hora forzada configurada aquí. No se modifica la hora real del sistema.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
