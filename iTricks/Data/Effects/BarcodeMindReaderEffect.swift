import SwiftUI

/// "El Lector de Códigos de Barras Mental" — Mentalismo.
///
/// Método real: un Atajo que abre el escáner de códigos, pero ignora por
/// completo el resultado real del escaneo. La acción siguiente siempre
/// muestra una alerta con un texto de personalidad preescrito, dando la
/// apariencia de un análisis imposible.
enum BarcodeMindReaderEffect: EffectModule {
    static let info = EffectInfo(
        id: "barcode_mind_reader",
        name: "El Lector de Códigos de Barras Mental",
        category: .mentalism,
        shortDescription: "Escaneas el código de barras de cualquier objeto. En vez del precio, aparece un rasgo exacto de la personalidad del espectador.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "barcode.viewfinder",
        instructions: EffectInstructions(
            whatItDoes: "Escaneas el código de barras de cualquier producto de la habitación con tu iPhone. En lugar de aparecer el precio o el nombre del objeto, aparece una ventana emergente que describe un rasgo de la personalidad del espectador con precisión sorprendente.",
            preparation: [
                "Investiga discretamente algún rasgo de personalidad del espectador antes del show (observación, conversación previa, lectura en frío) para que el texto resulte impactante y específico.",
                "Escribe ese texto en la configuración secreta de este efecto antes de actuar."
            ],
            performance: [
                "Presenta el teléfono como un escáner capaz de leer la energía de los objetos y, a través de ellos, la personalidad de quien los toca.",
                "Pide al espectador que sostenga o señale cualquier objeto con código de barras en la sala.",
                "Escanea el código con normalidad, dejando que la cámara enfoque claramente la línea de barras.",
                "Revela la alerta con el rasgo de personalidad, presentándolo como un análisis preciso del objeto."
            ],
            script: [
                "\"Los objetos que tocamos guardan parte de nuestra energía. Vamos a escanear este código.\"",
                "\"El código en sí no importa, lo que importa es lo que revela de quien lo ha tocado.\"",
                "\"Esto describe exactamente cómo eres tú.\""
            ],
            recoveryTips: [
                "Si el escáner no reconoce el código a la primera, sigue intentándolo con normalidad: el resultado final no depende del escaneo real.",
                "Ten dos o tres textos de personalidad preparados para distintos espectadores si vas a repetir el efecto en la misma sesión."
            ],
            performanceTips: [
                "Cuanto más específico y personal sea el texto preparado, más impactante resulta el efecto; evita generalidades vagas.",
                "Deja que el espectador elija el objeto libremente: refuerza que no hay ningún control sobre qué se escanea."
            ],
            variations: [
                "Usa la misma estructura para revelar un secreto o un mensaje motivacional en vez de un rasgo de personalidad.",
                "Combínalo con el Detector de objetos para una rutina de \"escáner mágico\" más larga."
            ],
            commonMistakes: [
                "Usar un texto de personalidad demasiado genérico que podría aplicarse a cualquier persona.",
                "No practicar el enfoque de la cámara, lo que puede generar una pausa incómoda al intentar escanear repetidamente."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Investiga un rasgo de personalidad específico del espectador antes del show.",
                spectatorAction: "No sospecha que se está preparando información sobre él.",
                simulationNote: "Esta investigación previa es el verdadero método, no el escaneo en sí."
            ),
            PracticeStep(
                performerAction: "Escanea el código de barras de un objeto elegido libremente por el espectador.",
                spectatorAction: "Elige cualquier objeto con código de barras de la sala.",
                simulationNote: "El atajo ignora el resultado real del escaneo por completo."
            ),
            PracticeStep(
                performerAction: "Revela la alerta con el rasgo de personalidad preescrito.",
                spectatorAction: "Se sorprende de la precisión del análisis.",
                simulationNote: "El texto fue escrito de antemano en la configuración secreta del efecto."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Escáner de Personalidad",
        trigger: "Se abre manualmente para escanear cualquier código de barras",
        actions: [
            "Añade 'Escanear código QR/de barras' como primera acción",
            "Ignora el resultado del escaneo: no lo uses en ninguna acción posterior",
            "Añade 'Mostrar alerta' con el texto de personalidad preescrito en la configuración secreta"
        ],
        caveat: "El escaneo debe parecer real (apunta y enfoca con cuidado), aunque su resultado nunca se utilice en el efecto."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .purple)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
