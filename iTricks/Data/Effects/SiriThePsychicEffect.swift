import SwiftUI

/// "Siri la Psíquica" — Tecnología.
///
/// Método real: un Atajo cuyo nombre es exactamente la frase que vas a
/// decirle a Siri, y que responde en voz alta con una predicción fija
/// mediante "Leer texto en voz alta". El verdadero método mágico es un
/// forzaje psicológico que hace que el espectador piense en el color que
/// tú ya escribiste en el atajo, antes incluso de preguntarle a Siri.
enum SiriThePsychicEffect: EffectModule {
    static let info = EffectInfo(
        id: "siri_the_psychic",
        name: "Siri la Psíquica",
        category: .technology,
        shortDescription: "Le preguntas a Siri en qué color piensa tu amigo. Siri responde en voz alta, y acierta.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "waveform.circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a Siri en voz alta que adivine en qué color está pensando tu amigo. Siri responde de inmediato por el altavoz con el color exacto, acertando por completo.",
            preparation: [
                "Crea el atajo descrito en la configuración secreta, usando como nombre la frase exacta que le dirás a Siri.",
                "Aprende y practica un forzaje psicológico de color (por ejemplo, preguntas en cascada que casi siempre llevan a 'azul' como primera respuesta espontánea).",
                "Ensaya la frase de activación hasta que Siri la reconozca de forma fiable, en distintos entornos de ruido."
            ],
            performance: [
                "Antes de preguntar a Siri, conduce al espectador (con preguntas o juegos verbales) a pensar en el color que ya tienes escrito en el atajo.",
                "Saca el teléfono y di la frase de activación exacta en voz alta: \"Oye Siri, [tu frase]\".",
                "Deja que Siri responda con la predicción en voz alta, sin que tú digas nada más.",
                "Reacciona con naturalidad, dejando que el público asuma que Siri realmente \"sabe\" el color."
            ],
            script: [
                "\"Piensa en un color, cualquiera, rápido, sin pensarlo demasiado.\"",
                "\"Oye Siri, ¿en qué color está pensando mi amigo?\"",
                "\"Está pensando en el color azul.\""
            ],
            recoveryTips: [
                "Si el forzaje no funciona y el espectador dice otro color, ten preparada una salida (\"Siri suele acertar con los primeros pensamientos, vamos a intentarlo de nuevo en un momento\") y repite el forzaje más adelante.",
                "Practica el reconocimiento de la frase de activación en el lugar real, ya que el ruido ambiente puede hacer que Siri no la entienda."
            ],
            performanceTips: [
                "El verdadero secreto es el forzaje psicológico, no la tecnología: dedica más tiempo de práctica a este apartado que al propio atajo.",
                "No repitas el mismo color con el mismo grupo de personas en la misma sesión."
            ],
            variations: [
                "Sustituye el color por un número del 1 al 10, usando técnicas de forzaje numérico equivalentes.",
                "Crea varios atajos con frases y colores distintos para poder elegir según cómo reaccione el espectador durante el forzaje."
            ],
            commonMistakes: [
                "Usar una frase de activación demasiado larga o con palabras poco comunes que Siri reconoce mal.",
                "No practicar suficiente el forzaje psicológico, lo que hace que el método dependa solo de la suerte."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce al espectador con un forzaje psicológico hacia el color predeterminado.",
                spectatorAction: "Cree elegir un color de forma completamente espontánea.",
                simulationNote: "El forzaje psicológico es la técnica real; la tecnología solo presenta el resultado."
            ),
            PracticeStep(
                performerAction: "Pregunta a Siri en voz alta usando la frase de activación exacta del atajo.",
                spectatorAction: "Escucha a Siri responder con el color exacto que pensó.",
                simulationNote: "El atajo simplemente lee en voz alta el texto que escribiste de antemano."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "¿En qué color está pensando mi amigo?",
        trigger: "Frase de Siri: el nombre del atajo debe ser exactamente esa pregunta",
        actions: [
            "Pon como nombre del atajo la frase exacta que dirás a Siri",
            "Añade 'Leer texto en voz alta' con el texto 'Está pensando en el color azul' (o el color que fuerces)"
        ],
        caveat: "El verdadero método es el forzaje psicológico del color, no el atajo: practica primero esa parte hasta dominarla."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .blue)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
