import SwiftUI
import UIKit
import UserNotifications

/// "La Batería Profética" — Paranormal.
///
/// Método real (integrado en la app): mientras esta pantalla está
/// abierta, iTricks escucha el evento real `UIDevice.batteryStateDidChangeNotification`.
/// En el instante en que el espectador conecta el cable de carga, se
/// dispara una notificación local con la predicción del animal, sin que
/// el mago toque nada en ese momento.
enum PropheticBatteryEffect: EffectModule {
    static let info = EffectInfo(
        id: "prophetic_battery",
        name: "La Batería Profética",
        category: .paranormal,
        shortDescription: "Conectas el teléfono al cargador y, al instante, una notificación revela el animal exacto que el espectador pensó.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "battery.100.bolt",
        instructions: EffectInstructions(
            whatItDoes: "Le dices al espectador que tu teléfono puede sentir su energía. Le pides que lo conecte al cable de carga. En cuanto lo hace, llega una notificación: \"La energía es correcta, el animal en el que estás pensando es el león\".",
            preparation: [
                "Escribe tu predicción del animal en la configuración secreta de este efecto.",
                "Aprende un forzaje psicológico de animal (preguntas en cascada que casi siempre llevan a \"león\" como primera respuesta espontánea, o al animal que prefieras forzar).",
                "Concede el permiso de notificaciones con antelación, fuera de la actuación."
            ],
            performance: [
                "Conduce al espectador con el forzaje psicológico hacia el animal que ya tienes configurado.",
                "Abre este efecto y explica que el teléfono puede \"sentir su energía\" a través de la conexión eléctrica.",
                "Pide al espectador que conecte él mismo el cable de carga al teléfono.",
                "En cuanto lo conecte, la app detecta el evento real de carga y dispara la notificación con la predicción."
            ],
            script: [
                "\"Piensa en un animal, el primero que te venga a la mente.\"",
                "\"Conecta tú mismo el cable, sin que yo lo toque.\"",
                "\"Mira lo que dice el teléfono.\""
            ],
            recoveryTips: [
                "Si el forzaje no funciona del todo, ten una salida narrativa (\"a veces la energía tarda un poco en estabilizarse\") y repite el forzaje con otra pregunta.",
                "Verifica que la pantalla del efecto sigue abierta antes de que conecten el cable: solo detecta el evento mientras está activa."
            ],
            performanceTips: [
                "Que sea el propio espectador quien conecte el cable refuerza que tú no controlaste nada en ese instante.",
                "El verdadero secreto es el forzaje del animal: dedícale más tiempo de práctica que a la configuración técnica."
            ],
            variations: [
                "Usa la misma detección para forzar un color, un número o una palabra en vez de un animal.",
                "Combínalo con un segundo aviso al desconectar el cable, como cierre alternativo."
            ],
            commonMistakes: [
                "Cerrar la pantalla del efecto antes de que conecten el cable, lo que impide la detección.",
                "No practicar suficiente el forzaje psicológico del animal, dependiendo solo de la suerte."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce el forzaje psicológico hacia el animal configurado.",
                spectatorAction: "Cree elegir un animal de forma completamente espontánea.",
                simulationNote: "El forzaje es la técnica real; la app solo presenta el resultado."
            ),
            PracticeStep(
                performerAction: "Pide al espectador que conecte él mismo el cable de carga.",
                spectatorAction: "Conecta el cable sin que el mago toque el teléfono en ese momento.",
                simulationNote: "UIDevice detecta el evento de carga real y dispara la notificación automáticamente."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(PropheticBatteryPerformView()) }
    static func settingsView() -> AnyView { AnyView(PropheticBatterySettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct PropheticBatteryPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("prophetic_battery_prediction") private var prediction = "La energía es correcta. El animal en el que estás pensando es el león."
    @State private var triggered = false
    @State private var observerToken: NSObjectProtocol?

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: triggered ? "battery.100.bolt.fill" : "battery.25")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text(triggered ? "Energía detectada" : "Esperando conexión al cargador…")
                .font(Theme.Typography.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .onAppear {
            UIDevice.current.isBatteryMonitoringEnabled = true
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
            observerToken = NotificationCenter.default.addObserver(
                forName: UIDevice.batteryStateDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                if UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full {
                    trigger()
                }
            }
        }
        .onDisappear {
            if let observerToken {
                NotificationCenter.default.removeObserver(observerToken)
            }
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
    }

    private func trigger() {
        guard !triggered else { return }
        triggered = true
        HapticManager.shared.magicReveal()

        let content = UNMutableNotificationContent()
        content.title = "Batería Profética"
        content.body = prediction
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }
}

private struct PropheticBatterySettingsView: View {
    @AppStorage("prophetic_battery_prediction") private var prediction = "La energía es correcta. El animal en el que estás pensando es el león."

    var body: some View {
        SecretConfigScreen(title: "La Batería Profética") {
            Section("Predicción") {
                TextField("Texto de la predicción", text: $prediction, axis: .vertical)
            }
            Section {
                Text("Mientras esta pantalla está abierta, iTricks escucha el evento real de conexión a la corriente del dispositivo. En cuanto se detecta, se dispara una notificación local con la predicción configurada aquí.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
