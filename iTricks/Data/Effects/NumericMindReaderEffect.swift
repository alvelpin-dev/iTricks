import SwiftUI

/// "El Lector de Mentes Numérico" — Mentalismo.
///
/// Método real: un Atajo de Siri camuflado como una app de notas. Al
/// abrirse, solicita un número al espectador y, sin guardarlo nunca en
/// ningún sitio visible, programa un Recordatorio del sistema con la
/// hora de aviso unos minutos en el futuro y el número como contenido,
/// antes de abrir la app Notas real para disimular que no ha pasado nada
/// fuera de lo normal.
///
/// Por qué un Recordatorio y no un simple "Esperar + Notificación" dentro
/// del propio Atajo: si Atajos pasa a segundo plano o se suspende (algo
/// habitual en iOS), un retardo interno puede no llegar a dispararse. Un
/// Recordatorio con hora de aviso lo entrega el sistema operativo, no el
/// Atajo, así que la notificación llega siempre, aunque haya pasado un
/// buen rato y Atajos ya ni siquiera esté en memoria.
enum NumericMindReaderEffect: EffectModule {
    static let info = EffectInfo(
        id: "numeric_mind_reader",
        name: "El Lector de Mentes Numérico",
        category: .mentalism,
        shortDescription: "El espectador escribe un número secreto en una 'app de notas'. Minutos después, una notificación te lo revela.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "note.text",
        instructions: EffectInstructions(
            whatItDoes: "Le pides al espectador que abra una supuesta app de notas de seguridad en tu iPhone y escriba un número secreto de tres cifras. El número nunca se guarda como nota real: en el momento en que lo escribe, el atajo programa un aviso para minutos después y abre la app Notas real, vacía, para que todo parezca normal al devolverte el teléfono. Más tarde, una notificación te revela el número sin que el espectador relacione ambos momentos.",
            preparation: [
                "Crea el atajo descrito en la configuración secreta de este efecto: cámbiale el icono y el nombre para que parezca una app de notas corriente.",
                "Configura el retardo del aviso (en minutos) en la configuración secreta; cuanto más tiempo pase, menos evidente será la relación entre escribir el número y recibir el aviso.",
                "Comprueba que el Recordatorio programado realmente te avisa pasado ese tiempo, incluso con la pantalla apagada y la app Atajos cerrada.",
                "Verifica que el atajo termina abriendo la app Notas real vacía, para que el espectador no note nada raro al devolverte el teléfono."
            ],
            performance: [
                "Entrega el teléfono ya con el atajo camuflado abierto y pide que escriba un número secreto de tres cifras que solo él conozca.",
                "En el instante en que lo escribe y confirma, el atajo programa el aviso futuro y abre la app Notas real vacía, sin dejar ningún rastro del número en pantalla.",
                "Pide que bloquee el teléfono y te lo devuelva; sigue con el resto de tu actuación con normalidad.",
                "Minutos después, cuando llegue la notificación del Recordatorio, consúltala con disimulo.",
                "Vuelve junto al espectador y anuncia el número con seguridad, como si lo hubieras sabido desde el principio."
            ],
            script: [
                "\"Voy a abrirte una app de notas seguras. Escribe un número de tres cifras que solo tú sepas.\"",
                "\"Bloquea el teléfono y dámelo, no necesito verlo.\"",
                "(minutos después) \"¿Recuerdas el número que escribiste antes? Era el...\""
            ],
            recoveryTips: [
                "Si por algún motivo no recibes el aviso a tiempo, alarga la rutina con otro efecto antes de volver a este; el Recordatorio seguirá esperando en tu pantalla hasta que lo consultes.",
                "Lleva siempre las notificaciones del Centro de Control silenciadas en pantalla de bloqueo para que nadie más que tú pueda leer el aviso antes que tú."
            ],
            performanceTips: [
                "El retardo es lo que hace creíble el efecto: si revelas el número justo al momento, parece magia barata; si lo haces minutos después, parece lectura de mente real.",
                "No mires el teléfono de forma obvia cuando llegue la notificación; consúltala como si comprobaras la hora."
            ],
            variations: [
                "Pide una palabra corta en vez de un número, usando la acción de entrada de texto en lugar de número.",
                "Combínalo con un efecto de predicción sellada para reforzar el cierre."
            ],
            commonMistakes: [
                "Configurar un retardo demasiado corto, lo que hace evidente la relación entre escribir el número y la notificación.",
                "Dejar visible el verdadero nombre del atajo en la pantalla de inicio antes de camuflarlo.",
                "Olvidar borrar o completar el Recordatorio después de leerlo, dejando el número visible si alguien revisa tus Recordatorios más tarde."
            ],
            recommendedDuration: "2-3 minutos en el momento, más el retardo configurado hasta la revelación"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Entrega el teléfono con el atajo camuflado como app de notas.",
                spectatorAction: "Escribe un número secreto de tres cifras sin que el mago mire.",
                simulationNote: "El número nunca se guarda como nota real; el atajo solo lo usa para programar el aviso futuro."
            ),
            PracticeStep(
                performerAction: "Deja que el atajo abra la app Notas real vacía y recupera el teléfono bloqueado.",
                spectatorAction: "Devuelve el teléfono convencido de que nadie pudo ver el número.",
                simulationNote: "El Recordatorio ya quedó programado en segundo plano antes de que se abriera Notas."
            ),
            PracticeStep(
                performerAction: "Minutos después, consulta la notificación del Recordatorio con disimulo y revela el número.",
                spectatorAction: "Se sorprende al escuchar el número exacto, sin relacionarlo con el momento en que lo escribió.",
                simulationNote: "La notificación llega aunque Atajos ya no esté abierto, porque la entrega el sistema, no el atajo."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Notas Seguras (nombre e icono camuflados)",
        trigger: "Se abre manualmente, igual que cualquier app, al entregar el teléfono",
        actions: [
            "Cambia el nombre del atajo y su icono en pantalla de inicio para que parezca una app de notas",
            "Añade 'Solicitar entrada' configurada como Número",
            "Añade 'Fecha actual' y luego 'Ajustar fecha' sumando el retardo en minutos configurado, para calcular la hora del aviso",
            "Añade 'Añadir recordatorio nuevo': título = el número introducido, fecha de vencimiento/aviso = la fecha ajustada anterior",
            "Añade 'Abrir app' → Notas, como acción final, sin haber creado ni guardado ninguna nota real con el número"
        ],
        caveat: "No se crea ninguna nota real en ningún momento, así que no hay nada que 'borrar': el número solo vive dentro del Recordatorio programado, que tú mismo deberías completar o eliminar después de leerlo."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .purple)) }
    static func settingsView() -> AnyView {
        AnyView(
            ShortcutEffectSettingsView(title: info.name, blueprint: blueprint) {
                NumericMindReaderExtraSettings()
            }
        )
    }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct NumericMindReaderExtraSettings: View {
    @AppStorage("numeric_mind_reader_delay_minutes") private var delayMinutes = 8.0

    var body: some View {
        Section("Retardo del aviso") {
            Slider(value: $delayMinutes, in: 2...30, step: 1)
            Text("\(Int(delayMinutes)) minutos después de escribir el número")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
    }
}
