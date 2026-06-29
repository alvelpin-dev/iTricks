import SwiftUI
import UserNotifications

/// "El Lector de Mentes Numérico" — Mentalismo.
///
/// Método real (versión integrada en la app, sin Atajos): la pantalla de
/// actuación imita una app de notas llamada "Notas temporales". En
/// cuanto el espectador escribe el número y bloquea el teléfono, iTricks
/// detecta el cambio de estado de la escena a segundo plano, borra el
/// número de la vista inmediatamente (para que no quede visible si
/// alguien la reabre) y programa una notificación local real de iOS para
/// unos segundos después, usando `UNUserNotificationCenter`. La
/// notificación llega aunque la app esté en segundo plano, porque la
/// entrega el sistema operativo, no la propia app.
///
/// También se incluye, en la configuración secreta, el plano de un Atajo
/// de Siri alternativo para quien prefiera recibir el número en otro
/// dispositivo (un Apple Watch o el teléfono de un cómplice) en lugar de
/// como notificación en el mismo iPhone.
enum NumericMindReaderEffect: EffectModule {
    static let info = EffectInfo(
        id: "numeric_mind_reader",
        name: "El Lector de Mentes Numérico",
        category: .mentalism,
        shortDescription: "El espectador escribe un número en 'Notas temporales'. Al bloquear el teléfono, segundos después llega una notificación con el número, y la nota ya está vacía.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "note.text",
        instructions: EffectInstructions(
            whatItDoes: "Le pides al espectador que abra una supuesta app de notas llamada \"Notas temporales\" y escriba un número secreto de tres cifras. En cuanto bloquea el teléfono, unos segundos después llega una notificación con el número exacto. Si alguien vuelve a abrir la nota, está completamente vacía: el número desapareció en el instante en que se bloqueó la pantalla.",
            preparation: [
                "La primera vez que uses este efecto, iOS te pedirá permiso para enviar notificaciones: acéptalo con antelación, fuera de la actuación, para que no aparezca ningún diálogo delante del público.",
                "Configura en la configuración secreta cuántos segundos tarda en llegar la notificación tras el bloqueo: ni tan rápido que parezca instantáneo, ni tan lento que se te olvide comprobarlo.",
                "Practica el gesto de bloquear el teléfono con el botón lateral justo después de que el espectador confirme que ya ha escrito el número."
            ],
            performance: [
                "Abre el efecto y entrega el teléfono mostrando la pantalla de \"Notas temporales\" vacía.",
                "Pide al espectador que escriba un número secreto de tres cifras que solo él conozca.",
                "En cuanto lo haya escrito, pide que bloquee el teléfono él mismo con el botón lateral y te lo devuelva.",
                "El número desaparece de la nota en el instante del bloqueo, sin que nadie lo vea borrarse.",
                "Unos segundos después, sin haber desbloqueado el teléfono todavía, recibirás la notificación con el número en la pantalla de bloqueo.",
                "Desbloquea el teléfono con normalidad: la nota ya está vacía, así que si el espectador vuelve a mirarla, no encontrará ningún rastro.",
                "Anuncia el número con seguridad, como si lo hubieras leído directamente de su mente."
            ],
            script: [
                "\"Voy a abrirte una app de notas temporales, todo lo que escribas aquí se borra solo.\"",
                "\"Escribe un número de tres cifras que solo tú sepas, y bloquea el teléfono cuando termines.\"",
                "\"Tu número es...\""
            ],
            recoveryTips: [
                "Si no concediste el permiso de notificaciones de antemano, iOS lo pedirá en ese momento y la notificación no llegará a tiempo; concede siempre el permiso fuera de la actuación, antes de empezar.",
                "Si el espectador desbloquea el teléfono antes de que llegue la notificación, la nota ya estará vacía igualmente: gana tiempo comentando algo mientras esperas el aviso."
            ],
            performanceTips: [
                "El hecho de que la nota quede vacía al instante refuerza la idea de \"notas temporales que se autodestruyen\", parte de la narrativa del efecto.",
                "No mires el teléfono de forma obvia al recibir la notificación: la verás de reojo en la pantalla de bloqueo antes incluso de desbloquearlo."
            ],
            variations: [
                "Usa la configuración secreta para recibir además el número en un Atajo de Siri propio, si prefieres que llegue a un Apple Watch o al teléfono de un cómplice en vez de a la pantalla de bloqueo del mismo iPhone.",
                "Pide una palabra corta en vez de un número, escribiendo el mismo guion adaptado."
            ],
            commonMistakes: [
                "No haber concedido el permiso de notificaciones antes de la actuación, lo que hace fallar el efecto en el peor momento.",
                "Configurar un retardo tan largo que te olvides de comprobar la notificación durante la actuación.",
                "Desbloquear el teléfono demasiado rápido sin haber esperado a que la nota se vacíe (aunque, en la práctica, se vacía instantáneamente al bloquear, no al desbloquear)."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Entrega el teléfono mostrando 'Notas temporales' vacía.",
                spectatorAction: "Escribe un número secreto de tres cifras sin que el mago mire.",
                simulationNote: "El texto se mantiene en pantalla mientras el espectador escribe, igual que una nota real."
            ),
            PracticeStep(
                performerAction: "Pide que bloquee el teléfono en cuanto termine de escribir.",
                spectatorAction: "Bloquea el teléfono y se lo devuelve al mago.",
                simulationNote: "En el instante del bloqueo, la app borra el número de la vista y programa la notificación."
            ),
            PracticeStep(
                performerAction: "Espera unos segundos y consulta la notificación en la pantalla de bloqueo.",
                spectatorAction: "No ve nada de esto: el teléfono está en manos del mago, bloqueado.",
                simulationNote: "La notificación la entrega el sistema operativo, por lo que llega de forma fiable."
            ),
            PracticeStep(
                performerAction: "Desbloquea el teléfono y revela el número.",
                spectatorAction: "Si pidiera ver la nota de nuevo, la encontraría completamente vacía.",
                simulationNote: "El número nunca queda guardado en ningún sitio visible tras el bloqueo."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Notas Seguras (alternativa con Atajos, opcional)",
        trigger: "Solo necesario si prefieres recibir el número en otro dispositivo en vez de en este mismo iPhone",
        actions: [
            "Cambia el nombre del atajo y su icono en pantalla de inicio para que parezca una app de notas",
            "Añade 'Solicitar entrada' configurada como Número",
            "Añade 'Enviar mensaje' a tu Apple Watch, o 'Obtener contenido de URL' a un webhook propio, con el número introducido",
            "Añade 'Abrir app' → Notas, como acción final"
        ],
        caveat: "Esta vía con Atajos es opcional: la versión integrada en iTricks ya entrega el número como notificación en este mismo iPhone sin necesitar ningún Atajo. Úsala solo si quieres que el aviso llegue a otro dispositivo."
    )

    static func performView() -> AnyView { AnyView(NumericMindReaderPerformView()) }
    static func settingsView() -> AnyView {
        AnyView(
            ShortcutEffectSettingsView(title: info.name, blueprint: blueprint) {
                NumericMindReaderExtraSettings()
            }
        )
    }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

// MARK: - Perform

private struct NumericMindReaderPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("numeric_mind_reader_notify_delay") private var notifyDelaySeconds = 6.0
    @State private var noteText = ""
    @FocusState private var isEditorFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Notas temporales")
                    .font(Theme.Typography.headline)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.top, Theme.Spacing.sm)

                Divider().padding(.top, Theme.Spacing.xs)

                ZStack(alignment: .topLeading) {
                    if noteText.isEmpty {
                        Text("Escribe aquí tu número secreto…")
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, Theme.Spacing.md + 4)
                            .padding(.top, Theme.Spacing.sm + 6)
                    }
                    TextEditor(text: $noteText)
                        .focused($isEditorFocused)
                        .font(.system(size: 17))
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, Theme.Spacing.sm)
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .onAppear {
                isEditorFocused = true
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
            }
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .background, !noteText.isEmpty else { return }
                scheduleNotification(with: noteText)
                noteText = ""
            }
        }
    }

    private func scheduleNotification(with number: String) {
        let content = UNMutableNotificationContent()
        content.title = "Notas temporales"
        content.body = "Número guardado: \(number)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(notifyDelaySeconds, 1), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Settings

private struct NumericMindReaderExtraSettings: View {
    @AppStorage("numeric_mind_reader_notify_delay") private var notifyDelaySeconds = 6.0

    var body: some View {
        Section("Retardo de la notificación") {
            Slider(value: $notifyDelaySeconds, in: 2...30, step: 1)
            Text("\(Int(notifyDelaySeconds)) segundos después de bloquear el teléfono")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
        Section {
            Text("En cuanto el teléfono se bloquea, iTricks borra el número de la pantalla y programa una notificación local de iOS para el número de segundos configurado aquí. Esto ya funciona dentro de la app, sin necesitar ningún Atajo de Siri.")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        } header: {
            Text("Cómo funciona")
        }
    }
}
