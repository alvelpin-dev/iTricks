import SwiftUI
import UserNotifications

/// "El Mensaje del Más Allá" — Paranormal.
///
/// Método real (integrado en la app): un campo de texto oculto donde el
/// mago teclea el nombre captado, que dispara de inmediato una
/// notificación local real (`UNUserNotificationCenter`) personalizada
/// para imitar la apariencia de un mensaje de texto entrante de
/// remitente desconocido. Sin retardo: el ritual de quemar el papel ya
/// aporta el tiempo dramático necesario.
enum MessageFromBeyondEffect: EffectModule {
    static let info = EffectInfo(
        id: "message_from_beyond",
        name: "El Mensaje del Más Allá",
        category: .paranormal,
        shortDescription: "Un espectador quema el nombre de un familiar fallecido. Segundos después, recibes un mensaje firmado por esa persona.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "envelope.badge.fill",
        instructions: EffectInstructions(
            whatItDoes: "Un espectador escribe el nombre de un familiar fallecido en un papel y lo quema. Segundos después, recibes una notificación de un \"Remitente Desconocido\" que dice: \"Estoy aquí, firmado: [nombre del familiar]\".",
            preparation: [
                "Decide cómo vas a capturar el nombre sin que se note: leerlo discretamente mientras lo escriben, pedirles que lo digan en voz baja, o usar dictado por voz a través del atajo.",
                "Configura el atajo para que muestre una notificación con apariencia de mensaje de texto entrante.",
                "Practica la sincronización: cuanto más rápido consigas introducir el nombre tras conocerlo, más impactante resulta la notificación."
            ],
            performance: [
                "Pide al espectador que escriba en privado el nombre de un familiar fallecido en un papel pequeño.",
                "Mientras se realiza el ritual de quemar el papel (o justo antes), capta el nombre con tu método elegido.",
                "Introduce el nombre en el atajo de forma disimulada, activando la notificación.",
                "Deja que la notificación aparezca de forma natural en pantalla, como si fuera un mensaje real entrante."
            ],
            script: [
                "\"Escribe en este papel el nombre de alguien que ya no está, alguien especial para ti.\"",
                "\"Vamos a quemarlo, dejando que su energía se libere.\"",
                "\"Espera... ha llegado algo a mi teléfono.\""
            ],
            recoveryTips: [
                "Si no logras captar el nombre con claridad, pide que lo repitan en voz alta \"para el ritual\", ganando una segunda oportunidad de oírlo.",
                "Ten preparada una notificación genérica (\"Estoy aquí\", sin nombre) como salida de emergencia si no consigues el nombre a tiempo."
            ],
            performanceTips: [
                "El momento de quemar el papel es una distracción perfecta para introducir el nombre en el teléfono sin que se note.",
                "Deja que la notificación llegue con un sonido audible para que todo el grupo la perciba al mismo tiempo."
            ],
            variations: [
                "En vez de un nombre de familiar, usa una palabra o mensaje que el espectador quiera \"enviar\" simbólicamente.",
                "Combínalo con el Detector paranormal para una rutina paranormal de cierre más larga."
            ],
            commonMistakes: [
                "Tardar demasiado en introducir el nombre, lo que rompe la conexión temporal entre quemar el papel y recibir el mensaje.",
                "Mostrar el teléfono demasiado pronto, antes de que la notificación esté lista."
            ],
            recommendedDuration: "3-5 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Capta el nombre del familiar fallecido mientras el espectador lo escribe o lo dice en voz baja.",
                spectatorAction: "Escribe el nombre en privado, creyendo que nadie más lo conoce.",
                simulationNote: "El método de captación (lectura discreta, dictado) ocurre fuera de la app."
            ),
            PracticeStep(
                performerAction: "Introduce el nombre en el atajo durante el ritual de quemar el papel.",
                spectatorAction: "Se concentra en el ritual, sin sospechar del teléfono.",
                simulationNote: "El atajo genera una notificación personalizada con el nombre capturado."
            ),
            PracticeStep(
                performerAction: "Deja que la notificación aparezca de forma natural.",
                spectatorAction: "Ve el mensaje firmado con el nombre exacto que escribió.",
                simulationNote: "La notificación imita la apariencia de un mensaje de texto real entrante."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MessageFromBeyondPerformView()) }
    static func settingsView() -> AnyView { AnyView(MessageFromBeyondSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct MessageFromBeyondPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("message_from_beyond_template") private var template = "Estoy aquí, firmado: %@"
    @State private var capturedName = ""
    @State private var sent = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            Image(systemName: "envelope.badge.fill")
                .font(.system(size: 56))
                .foregroundStyle(.indigo)

            Text("Nombre captado")
                .font(Theme.Typography.headline)
            TextField("Teclea el nombre que has captado", text: $capturedName)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .padding()
                .glassCardStyle()
                .padding(.horizontal, Theme.Spacing.lg)

            PrimaryButton(sent ? "Enviado" : "Enviar mensaje", symbol: "paperplane.fill", tint: .indigo) {
                send()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .disabled(capturedName.trimmingCharacters(in: .whitespaces).isEmpty)

            Spacer()
            Button("Cerrar") { dismiss() }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Color.appBackground)
        .onAppear {
            isFocused = true
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    private func send() {
        let content = UNMutableNotificationContent()
        content.title = "Mensaje de Texto"
        content.subtitle = "Remitente desconocido"
        content.body = String(format: template, capturedName)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        HapticManager.shared.impact(.soft)
        sent = true
    }
}

private struct MessageFromBeyondSettingsView: View {
    @AppStorage("message_from_beyond_template") private var template = "Estoy aquí, firmado: %@"

    var body: some View {
        SecretConfigScreen(title: "El Mensaje del Más Allá") {
            Section("Plantilla del mensaje") {
                TextField("Estoy aquí, firmado: %@", text: $template)
                Text("Usa %@ donde quieras que aparezca el nombre captado.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Section {
                Text("El campo de texto de la pantalla de actuación es donde tecleas el nombre captado. Al pulsar 'Enviar mensaje' se programa una notificación local real, disfrazada de mensaje de texto, que llega en un par de segundos.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
