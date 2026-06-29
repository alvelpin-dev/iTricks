import SwiftUI

/// "El Color de la Mente" — Mentalismo.
///
/// Método real (integrado en la app): el `CoreMotion` ya integrado en
/// `SensorManager` mide la inclinación real del teléfono (`roll`). Tres
/// zonas de inclinación distintas (nivelado, inclinado a la derecha,
/// inclinado a la izquierda) disparan tres colores distintos tras
/// mantenerse estable un instante, evitando activaciones accidentales
/// por el temblor natural de la mano.
enum MindColorEffect: EffectModule {
    static let info = EffectInfo(
        id: "mind_color",
        name: "El Color de la Mente",
        category: .mentalism,
        shortDescription: "El espectador piensa en un color. Pasas la mano sobre la pantalla apagada y se ilumina exactamente de ese color.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "paintpalette.fill",
        instructions: EffectInstructions(
            whatItDoes: "El espectador piensa en un color primario. Miras fijamente la pantalla apagada de tu iPhone, pasas la mano por encima sin tocarla, y toda la pantalla se enciende brillando intensamente con el color exacto que el espectador pensó.",
            preparation: [
                "Crea los tres atajos descritos en la configuración secreta (uno por color: rojo, azul, verde), cada uno con su propio disparador discreto.",
                "Practica cada disparador hasta poder activarlo sin que se note ningún gesto especial con las manos.",
                "Aprende un forzaje psicológico de color como respaldo, para aumentar tus probabilidades de tener preparado el color correcto."
            ],
            performance: [
                "Pide al espectador que piense en un color primario (rojo, azul o verde) sin decirlo en voz alta todavía.",
                "Si usas forzaje psicológico, condúcelo hacia uno de los tres colores preparados antes de seguir.",
                "Pide que diga el color en voz alta, y activa discretamente el disparador correspondiente mientras pasas la mano sobre la pantalla.",
                "Deja que la pantalla se ilumine con el color exacto, como si hubiera \"sentido\" el pensamiento."
            ],
            script: [
                "\"Piensa en un color: rojo, azul o verde. El que tú quieras.\"",
                "\"Dime cuál es, y voy a pasar la mano sobre la pantalla sin tocarla.\"",
                "\"Mira cómo se ilumina exactamente de ese color.\""
            ],
            recoveryTips: [
                "Si activas el disparador equivocado por error, recupera el momento diciendo que el primer color fue \"un eco residual\" y repite con el color correcto.",
                "Practica los tres disparadores por separado hasta que actives cada uno sin pensar, evitando confundirlos en el momento."
            ],
            performanceTips: [
                "El gesto de pasar la mano sobre la pantalla debe ser lento y deliberado, dando tiempo a que el disparador se active antes de que la mano termine su recorrido.",
                "Practica frente a un espejo el momento exacto de la activación para que coincida visualmente con el gesto de la mano."
            ],
            variations: [
                "Limita la elección a solo dos colores si te resulta más manejable controlar únicamente dos disparadores.",
                "Combínalo con Siri la Psíquica para una rutina de \"colores imposibles\" con doble confirmación."
            ],
            commonMistakes: [
                "Intentar controlar más de tres colores, lo que complica demasiado los disparadores y aumenta el riesgo de error.",
                "Tocar la pantalla en vez de solo pasar la mano por encima, lo que rompe la idea de que no hay contacto físico."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide al espectador que piense en un color primario.",
                spectatorAction: "Elige mentalmente rojo, azul o verde.",
                simulationNote: "Tienes preparado un atajo distinto para cada uno de los tres colores."
            ),
            PracticeStep(
                performerAction: "Activa discretamente el disparador del color que diga el espectador mientras pasas la mano sobre la pantalla.",
                spectatorAction: "Dice el color en voz alta y ve la pantalla iluminarse de ese color exacto.",
                simulationNote: "El disparador correcto simplemente abre la imagen de ese color a pantalla completa."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MindColorPerformView()) }
    static func settingsView() -> AnyView { AnyView(MindColorSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum TiltZone: Equatable {
    case level, right, left
}

private struct MindColorPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var sensors = SensorManager.shared
    @State private var revealedColor: Color?
    @State private var currentZone: TiltZone?
    @State private var stableTicks = 0

    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            (revealedColor ?? Color.black).ignoresSafeArea()

            VStack(spacing: Theme.Spacing.md) {
                Spacer()
                if revealedColor == nil {
                    Text("Pasa la mano sobre la pantalla")
                        .font(Theme.Typography.body)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, Theme.Spacing.md)
            }
        }
        .onAppear { sensors.startMotionUpdates() }
        .onDisappear { sensors.stopMotionUpdates() }
        .onReceive(timer) { _ in evaluateTilt() }
    }

    private func evaluateTilt() {
        guard revealedColor == nil else { return }

        let zone: TiltZone
        if sensors.roll > 0.4 {
            zone = .right
        } else if sensors.roll < -0.4 {
            zone = .left
        } else if abs(sensors.roll) < 0.15 {
            zone = .level
        } else {
            currentZone = nil
            stableTicks = 0
            return
        }

        if zone == currentZone {
            stableTicks += 1
        } else {
            currentZone = zone
            stableTicks = 1
        }

        if stableTicks >= 4 {
            reveal(for: zone)
        }
    }

    private func reveal(for zone: TiltZone) {
        let color: Color
        switch zone {
        case .level: color = .green
        case .right: color = .red
        case .left: color = .blue
        }
        HapticManager.shared.magicReveal()
        withAnimation(Theme.AnimationCurve.standard) { revealedColor = color }
    }
}

private struct MindColorSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "El Color de la Mente") {
            Section {
                Text("Nivelado = verde · Inclinado a la derecha = rojo · Inclinado a la izquierda = azul. Inclina discretamente el teléfono hacia la zona correspondiente mientras pasas la mano por encima; debe mantenerse estable algo menos de un segundo para activarse, evitando temblores accidentales.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
