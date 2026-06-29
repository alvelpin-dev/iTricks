import SwiftUI

/// "El Destello Espiritista" — Paranormal.
///
/// Método real: una automatización ligada a una pulsación sutil del botón
/// de volumen (activada por el mago, por un disparador bluetooth con el
/// pie, o por un cómplice), que enciende y apaga la linterna del iPhone
/// el número exacto de veces que el mago decide, codificando así
/// respuestas de sí/no.
enum SpiritistFlashEffect: EffectModule {
    static let info = EffectInfo(
        id: "spiritist_flash",
        name: "El Destello Espiritista",
        category: .paranormal,
        shortDescription: "Haces preguntas al más allá. La linterna del teléfono parpadea una vez para sí, dos veces para no, y siempre acierta.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "flashlight.on.fill",
        instructions: EffectInstructions(
            whatItDoes: "Colocas el iPhone en el centro de la mesa con la linterna lista. Haces preguntas al \"más allá\". Si la respuesta es sí, la linterna parpadea una vez; si es no, parpadea dos veces. El teléfono responde correctamente a preguntas que el mago no podía saber.",
            preparation: [
                "Configura la automatización por botón de volumen descrita en los ajustes secretos.",
                "Si usas un disparador bluetooth oculto (activado con el pie) o un cómplice, practica la señal hasta que sea completamente disimulada.",
                "Prepara de antemano las respuestas a las preguntas que vas a hacer, usando técnicas de mentalismo (información previa, lectura en frío, o un cómplice que te las transmita)."
            ],
            performance: [
                "Coloca el teléfono en el centro de la mesa, con la pantalla apagada o mostrando solo el icono de linterna.",
                "Haz preguntas de sí/no al \"más allá\" sobre algo que ya sepas la respuesta por algún método de mentalismo.",
                "Activa discretamente uno o dos parpadeos según la respuesta que quieras dar.",
                "Deja que el público interprete los parpadeos como una comunicación genuina con el más allá."
            ],
            script: [
                "\"Si hay alguien aquí con nosotros, que responda a través de la luz.\"",
                "\"Una vez para sí, dos veces para no.\"",
                "\"¿Puedes confirmarnos algo sobre esta persona?\""
            ],
            recoveryTips: [
                "Si te equivocas en el número de parpadeos, puedes recuperarlo diciendo que \"la energía es inestable\" y repitiendo la pregunta para una segunda confirmación.",
                "Practica el ritmo exacto de pulsaciones para que el número de parpadeos sea siempre nítido y no se confunda con un parpadeo accidental."
            ],
            performanceTips: [
                "El verdadero secreto está en cómo obtienes la información para responder las preguntas, no en el mecanismo del parpadeo: dedica tiempo a esa parte.",
                "Mantén las manos visiblemente alejadas del teléfono mientras parpadea, para reforzar que no lo estás tocando."
            ],
            variations: [
                "Usa un código de parpadeos más elaborado (por ejemplo, contar hasta un número) para preguntas de \"cuánto\" en vez de sí/no.",
                "Combínalo con El Mensaje del más allá para una rutina paranormal de cierre más larga."
            ],
            commonMistakes: [
                "Activar el disparador de forma visible, como mover demasiado el pie o las manos cerca del teléfono.",
                "Hacer preguntas cuya respuesta no puedas conocer por ningún método previo, dejando el resultado al azar."
            ],
            recommendedDuration: "3-5 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Coloca el teléfono en el centro de la mesa y formula una pregunta cuya respuesta ya conoces.",
                spectatorAction: "Hace o escucha la pregunta al 'más allá', sin saber que el mago ya tiene la respuesta.",
                simulationNote: "El verdadero método de obtención de información ocurre fuera del mecanismo del parpadeo."
            ),
            PracticeStep(
                performerAction: "Activa discretamente uno o dos parpadeos según la respuesta deseada.",
                spectatorAction: "Ve la linterna parpadear el número exacto de veces que corresponde a sí o no.",
                simulationNote: "La automatización por botón de volumen controla el número de parpadeos de la linterna."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Destello Espiritista (Sí / No)",
        trigger: "Automatización personal por botón de volumen, disparador bluetooth con el pie, o señal de un cómplice",
        actions: [
            "Crea una automatización para 'Sí': 'Configurar linterna' Encendido → 'Esperar' 0.3s → 'Configurar linterna' Apagado",
            "Crea una automatización distinta para 'No': repite el parpadeo completo dos veces en lugar de una",
            "Asigna cada automatización a un disparador discreto distinto (por ejemplo, subir volumen = sí, bajar volumen = no)"
        ],
        caveat: "El verdadero secreto de este efecto es cómo obtienes la información para responder correctamente, no el mecanismo de la linterna: trabaja esa parte con técnicas de mentalismo."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .yellow)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
