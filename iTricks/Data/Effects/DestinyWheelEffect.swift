import SwiftUI

/// "Ruleta del destino" — Números.
///
/// Método real: la ruleta es una animación controlada por software. El
/// espectador imparte la energía del giro arrastrando el dedo, pero el
/// ángulo final se calcula siempre para que el puntero se detenga en el
/// segmento que el mago haya forzado de antemano, sin importar la
/// velocidad o dirección del giro.
enum DestinyWheelEffect: EffectModule {
    static let info = EffectInfo(
        id: "destiny_wheel",
        name: "Ruleta del destino",
        category: .numbers,
        shortDescription: "El espectador gira la ruleta con la fuerza que quiera. Siempre se detiene en el segmento que el mago predijo.",
        difficulty: .beginner,
        preparationTime: .seconds,
        symbol: "circle.grid.3x3.fill",
        instructions: EffectInstructions(
            whatItDoes: "Una ruleta dividida en ocho segmentos numerados gira al recibir un giro del espectador. Por mucha fuerza o dirección que le dé, siempre se detiene en el segmento que el mago anunció o anotó como predicción antes del giro.",
            preparation: [
                "Decide qué segmento vas a forzar y ajústalo en la configuración secreta antes de la actuación.",
                "Anuncia o escribe tu predicción antes de que el espectador gire la ruleta."
            ],
            performance: [
                "Muestra la ruleta con sus ocho segmentos y anuncia o muestra tu predicción.",
                "Pide al espectador que gire la ruleta arrastrando el dedo, con la fuerza y dirección que quiera.",
                "Deja que la ruleta gire de forma visualmente realista antes de detenerse en el segmento forzado.",
                "Revela tu predicción y compárala con el resultado."
            ],
            script: [
                "\"He anotado un número antes de empezar, no lo he tocado desde entonces.\"",
                "\"Gira la ruleta como quieras, con la fuerza que prefieras.\"",
                "\"Veamos dónde se ha detenido… y comprobemos la predicción.\""
            ],
            recoveryTips: [
                "Si el espectador gira muy suave, la animación se ajusta automáticamente para completar al menos varias vueltas antes de detenerse, manteniendo la credibilidad."
            ],
            performanceTips: [
                "Revela la predicción antes del giro siempre que sea posible: refuerza que el resultado no pudo manipularse después.",
                "Varía la cantidad de vueltas que da la ruleta entre actuaciones para que no parezca un patrón fijo."
            ],
            variations: [
                "Usa la ruleta para forzar una carta, asociando cada segmento numerado a una carta de un mazo real.",
                "Encadena dos giros y suma los resultados, forzando ambos para llegar a un número final concreto."
            ],
            commonMistakes: [
                "Revelar la predicción después de ver el resultado en pantalla.",
                "Dejar que la ruleta gire un tiempo demasiado corto, lo que puede parecer poco realista."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Anuncia tu predicción antes del giro.",
                spectatorAction: "Escucha o ve la predicción sellada.",
                simulationNote: "El segmento forzado está fijado en la configuración secreta del efecto."
            ),
            PracticeStep(
                performerAction: "Pide al espectador que arrastre el dedo para girar la ruleta.",
                spectatorAction: "Gira la ruleta con la fuerza y dirección que prefiera.",
                simulationNote: "El ángulo final se calcula matemáticamente para aterrizar siempre en el segmento forzado."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(DestinyWheelPerformView()) }
    static func settingsView() -> AnyView { AnyView(DestinyWheelSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct DestinyWheelPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("destiny_wheel_forced_segment") private var forcedSegment = 0
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    private let segmentCount = 8

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            ZStack {
                ForEach(0..<segmentCount, id: \.self) { index in
                    WheelSlice(index: index, total: segmentCount)
                        .fill(index % 2 == 0 ? Color.blue.opacity(0.85) : Color.blue.opacity(0.55))
                    Text("\(index + 1)")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(360.0 / Double(segmentCount) * Double(index) + 360.0 / Double(segmentCount) / 2))
                        .offset(y: -90)
                        .rotationEffect(.degrees(360.0 / Double(segmentCount) * Double(index) + 360.0 / Double(segmentCount) / 2))
                }
                Circle().fill(Color.white).frame(width: 16, height: 16)
            }
            .frame(width: 260, height: 260)
            .rotationEffect(.degrees(rotation))
            .gesture(
                DragGesture()
                    .onEnded { value in
                        guard !isSpinning else { return }
                        spin(power: value.translation.width + value.translation.height)
                    }
            )

            Image(systemName: "arrowtriangle.down.fill")
                .foregroundStyle(.primary)
                .offset(y: -8)

            Text(isSpinning ? "Girando…" : "Arrastra el dedo sobre la ruleta para girarla")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
    }

    private func spin(power: CGFloat) {
        isSpinning = true
        HapticManager.shared.impact(.medium)
        let segmentAngle = 360.0 / Double(segmentCount)
        let targetSegmentAngle = segmentAngle * Double(forcedSegment) + segmentAngle / 2
        let extraSpins = Double.random(in: 4...7) * 360
        let finalRotation = rotation - (rotation.truncatingRemainder(dividingBy: 360)) - targetSegmentAngle - extraSpins

        withAnimation(.easeOut(duration: 2.6)) {
            rotation = finalRotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            isSpinning = false
            MagicEngine.performReveal()
        }
    }
}

private struct WheelSlice: Shape {
    let index: Int
    let total: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let anglePer = 360.0 / Double(total)
        let start = Angle(degrees: anglePer * Double(index) - 90)
        let end = Angle(degrees: anglePer * Double(index + 1) - 90)

        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        path.closeSubpath()
        return path
    }
}

private struct DestinyWheelSettingsView: View {
    @AppStorage("destiny_wheel_forced_segment") private var forcedSegment = 0

    var body: some View {
        SecretConfigScreen(title: "Ruleta del destino") {
            Section("Segmento forzado") {
                Picker("Número que saldrá", selection: $forcedSegment) {
                    ForEach(0..<8, id: \.self) { index in
                        Text("\(index + 1)").tag(index)
                    }
                }
                .pickerStyle(.inline)
            }
            Section {
                Text("El giro real del espectador solo determina la velocidad visual de la animación. El ángulo final siempre se calcula para detener el puntero exactamente en el segmento configurado aquí.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
