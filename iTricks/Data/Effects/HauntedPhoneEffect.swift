import SwiftUI

/// "Móvil embrujado" — Paranormal.
///
/// Método real: el sensor de proximidad (el mismo que apaga la pantalla
/// al acercar el teléfono a la oreja durante una llamada) detecta cuando
/// una mano se acerca a la parte superior del teléfono. La app reacciona
/// a esa detección genuina con sonidos, vibración y efectos visuales,
/// dando la sensación de que el teléfono "siente" la presencia de alguien.
enum HauntedPhoneEffect: EffectModule {
    static let info = EffectInfo(
        id: "haunted_phone",
        name: "Móvil embrujado",
        category: .paranormal,
        shortDescription: "La pantalla reacciona con parpadeos, sonidos y vibraciones cuando una mano se acerca, como si el teléfono sintiera presencias.",
        difficulty: .beginner,
        preparationTime: .none,
        symbol: "hand.raised.fill",
        instructions: EffectInstructions(
            whatItDoes: "El teléfono permanece en reposo sobre la mesa. Cuando alguien acerca la mano a la parte superior (donde está el sensor de proximidad), la pantalla reacciona instantáneamente con parpadeos, un sonido inquietante y una vibración, como si \"sintiera\" la presencia de la mano antes de tocarlo siquiera.",
            preparation: [
                "Comprueba la posición exacta del sensor de proximidad de tu modelo de iPhone (junto a la cámara frontal) antes de actuar.",
                "Practica el gesto de acercar la mano lentamente para que la reacción se sienta como una detección progresiva, no instantánea."
            ],
            performance: [
                "Coloca el teléfono en una mesa, pantalla hacia arriba, y cuenta una breve historia sobre energías o presencias en el lugar.",
                "Invita a alguien a acercar la mano lentamente hacia la parte superior del teléfono, sin tocarlo.",
                "Deja que la app reaccione de forma genuina en el momento exacto en que la mano bloquea el sensor de proximidad.",
                "Repite con distintas personas para reforzar que la reacción depende de quién se acerca, alimentando la narrativa paranormal."
            ],
            script: [
                "\"Acerca la mano poco a poco, sin tocar la pantalla.\"",
                "\"¿Notas cómo reacciona antes de que lo toques?\"",
                "\"Este teléfono percibe algo que se acerca, no es normal.\""
            ],
            recoveryTips: [
                "Si la reacción no se dispara, pide que acerquen la mano más arriba, cerca de la cámara frontal, donde está el sensor real.",
                "Evita luz solar directa muy intensa sobre el sensor, ya que puede interferir con su funcionamiento normal."
            ],
            performanceTips: [
                "No reveles que se trata de un sensor de proximidad: deja que el público especule sobre el motivo de la reacción.",
                "Combina la reacción con una frase narrativa relacionada con el lugar o la historia que estés contando."
            ],
            variations: [
                "Pide a varias personas que se acerquen una a una y comenta diferencias imaginarias en la intensidad de la reacción de cada una.",
                "Combínalo con el Espíritu en el móvil para una rutina paranormal más larga."
            ],
            commonMistakes: [
                "Explicar que se trata de un sensor de proximidad, lo que rompe la ilusión inmediatamente.",
                "Colocar el teléfono en una posición donde el sensor quede oculto o difícil de activar."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Coloca el teléfono sobre la mesa e introduce la narrativa paranormal.",
                spectatorAction: "Escucha la historia sin saber qué va a ocurrir.",
                simulationNote: "El sensor de proximidad está activo y a la espera de una mano cercana."
            ),
            PracticeStep(
                performerAction: "Invita a acercar la mano lentamente sin tocar el teléfono.",
                spectatorAction: "Acerca la mano poco a poco hacia la parte superior del teléfono.",
                simulationNote: "El sensor real detecta la proximidad y dispara la reacción de forma genuina, no simulada."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(HauntedPhonePerformView()) }
    static func settingsView() -> AnyView { AnyView(HauntedPhoneSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct HauntedPhonePerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @AppStorage("haunted_phone_intensity") private var intensity = 1.0
    @State private var flicker = false

    var body: some View {
        ZStack {
            (flicker ? Color.black : Color.appBackground)
                .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()
                Image(systemName: sensors.isClose ? "eye.fill" : "moon.stars")
                    .font(.system(size: 64))
                    .foregroundStyle(flicker ? .white : .indigo)
                Text(sensors.isClose ? "Algo se acerca…" : "En reposo")
                    .font(Theme.Typography.headline)
                    .foregroundStyle(flicker ? .white : .primary)
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(Theme.Spacing.lg)
        }
        .onAppear {
            MagicEngine.beginSession()
            sensors.startProximityMonitoring()
        }
        .onChange(of: sensors.isClose) { isClose in
            if isClose { triggerHaunting() }
        }
        .onDisappear { MagicEngine.endSession() }
    }

    private func triggerHaunting() {
        HapticManager.shared.impact(.heavy)
        SoundManager.shared.play(.staticNoise, volume: Float(intensity))
        Task {
            for _ in 0..<4 {
                withAnimation(.easeInOut(duration: 0.08)) { flicker.toggle() }
                try? await Task.sleep(nanoseconds: 90_000_000)
            }
            withAnimation { flicker = false }
        }
    }
}

private struct HauntedPhoneSettingsView: View {
    @AppStorage("haunted_phone_intensity") private var intensity = 1.0

    var body: some View {
        SecretConfigScreen(title: "Móvil embrujado") {
            Section("Intensidad del sonido") {
                Slider(value: $intensity, in: 0.2...1.0, step: 0.1)
            }
            Section {
                Text("El sensor de proximidad físico del iPhone detecta cuando algo bloquea la parte superior de la pantalla (el mismo sensor que apaga la pantalla durante una llamada). La reacción es automática y real, no simulada.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
