import SwiftUI

/// "El Mensaje del Más Allá" — Paranormal.
///
/// Método real: un Atajo que recibe el nombre tecleado o dictado por el
/// mago de forma disimulada, y lo convierte en una notificación
/// personalizada que imita la apariencia de un mensaje de texto entrante
/// de remitente desconocido.
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

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Mensaje del Más Allá",
        trigger: "Se activa manualmente, introduciendo el nombre captado en el momento",
        actions: [
            "Añade 'Solicitar entrada de texto' (o 'Dictado') para introducir el nombre captado",
            "Añade 'Mostrar notificación' personalizando el título como 'Mensaje de Texto' o el nombre de tu app de mensajería",
            "Configura el cuerpo de la notificación como 'Estoy aquí, firmado: [nombre]', combinando el texto fijo con el nombre introducido"
        ],
        caveat: "El nombre debe introducirse en el momento, ya que no puedes saberlo de antemano: practica mucho la captación discreta del nombre antes de actuar."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .indigo)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
