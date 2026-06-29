import SwiftUI

/// "El Detector de Mentiras Háptico" — Paranormal.
///
/// Método real: una automatización ligada al botón de bajar volumen, que
/// dispara una vibración fuerte cuando el mago la activa discretamente.
/// El botón de subir volumen no hace nada, así que el mago controla por
/// completo en qué afirmación "detecta" la mentira.
enum HapticLieDetectorShortcutEffect: EffectModule {
    static let info = EffectInfo(
        id: "haptic_lie_detector_shortcut",
        name: "El Detector de Mentiras Háptico",
        category: .paranormal,
        shortDescription: "Sostienes el teléfono por los lados. Cuando el espectador miente, vibra fuerte de la nada.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "hand.raised.brakesignal",
        instructions: EffectInstructions(
            whatItDoes: "Le pides al espectador que diga tres afirmaciones, dos verdaderas y una mentira. Sostienes el iPhone por los lados y, cuando dice la mentira, el teléfono vibra fuertemente de la nada, delatándolo.",
            preparation: [
                "Configura la automatización ligada al botón de bajar volumen en los ajustes secretos de este efecto.",
                "Practica sostener el teléfono por los lados de forma que puedas presionar el botón de volumen con el dedo sin que se note el movimiento."
            ],
            performance: [
                "Pide al espectador tres afirmaciones, dos verdaderas y una falsa, sin decirte cuál es la mentira.",
                "Sostén el teléfono por los lados con ambas manos, con los dedos cerca de los botones de volumen.",
                "Mientras dice cada afirmación, presiona disimuladamente el botón de bajar volumen en la que tú decidas que sea la \"mentira\" detectada.",
                "Deja que la vibración fuerte sorprenda al espectador y al público, reforzando que el teléfono \"sabe\" la verdad."
            ],
            script: [
                "\"Dime tres cosas sobre ti: dos verdaderas y una mentira, en el orden que quieras.\"",
                "\"Voy a sostener el teléfono así, sujeto por los lados, sin tocar la pantalla.\"",
                "\"Ahí... ha vibrado en la segunda. Esa es la mentira.\""
            ],
            recoveryTips: [
                "Si presionas el botón equivocado por error, puedes salvarlo diciendo que el teléfono a veces detecta \"dudas\" además de mentiras directas, dejando ambigüedad.",
                "Practica con el sonido de los botones físicos apagado o con una funda que amortigüe el clic, para que no se oiga la pulsación."
            ],
            performanceTips: [
                "No mires tus propias manos mientras presionas el botón; mantén la mirada en el espectador para no delatar el gesto.",
                "Deja una pequeña pausa entre cada afirmación y la posible vibración, para que no parezca una reacción instantánea sospechosa."
            ],
            variations: [
                "Usa el mismo método para un juego de \"sí o no\" con preguntas directas en vez de afirmaciones.",
                "Combínalo con el Detector de mentiras (basado en micrófono) para una rutina de \"doble verificación\" más elaborada."
            ],
            commonMistakes: [
                "Sujetar el teléfono de forma rígida o forzada, lo que hace evidente que estás manipulando algo con los dedos.",
                "Disparar la vibración demasiado rápido tras la afirmación, sin dar sensación de \"análisis\"."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Sostén el teléfono por los lados con los dedos cerca de los botones de volumen.",
                spectatorAction: "Dice tres afirmaciones, dos verdaderas y una falsa.",
                simulationNote: "Solo el botón de bajar volumen está vinculado a la vibración; el de subir no hace nada."
            ),
            PracticeStep(
                performerAction: "Presiona disimuladamente el botón en la afirmación que decidas marcar como mentira.",
                spectatorAction: "Siente o ve vibrar el teléfono justo en esa afirmación.",
                simulationNote: "Tú controlas el resultado por completo; no hay análisis real de veracidad."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Detector Háptico (automatización)",
        trigger: "Automatización personal ligada al botón de bajar volumen",
        actions: [
            "En la pestaña Automatización, crea 'Nueva automatización personal'",
            "Elige el disparador de botón de volumen (bajar) si tu modelo lo soporta, o usa una automatización por accesibilidad equivalente",
            "Añade la acción 'Vibrar dispositivo' con intensidad fuerte",
            "Desactiva 'Preguntar antes de ejecutar' para que la vibración sea instantánea",
            "No crees ninguna automatización para el botón de subir volumen"
        ],
        caveat: "La disponibilidad de automatizaciones por botón físico de volumen depende de la versión de iOS; si tu modelo no la soporta, usa una alternativa de accesibilidad (toque triple en la parte trasera, por ejemplo)."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .indigo)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
