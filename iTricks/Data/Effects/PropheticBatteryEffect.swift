import SwiftUI

/// "La Batería Profética" — Paranormal.
///
/// Método real: una automatización de Atajos basada en el evento "Cuando
/// el iPhone se conecta a la corriente". Al conectar el cable, la
/// automatización se dispara sola y lee en voz alta la predicción
/// preescrita, sin que el mago toque nada en ese instante.
enum PropheticBatteryEffect: EffectModule {
    static let info = EffectInfo(
        id: "prophetic_battery",
        name: "La Batería Profética",
        category: .paranormal,
        shortDescription: "Conectas el teléfono al cargador y, al instante, Siri anuncia en voz alta el animal exacto que el espectador pensó.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "battery.100.bolt",
        instructions: EffectInstructions(
            whatItDoes: "Le dices al espectador que tu teléfono puede sentir su energía. Le pides que lo conecte al cable de carga. En cuanto lo hace, Siri dice en voz alta: \"La energía es correcta, el animal en el que estás pensando es el león\".",
            preparation: [
                "Crea la automatización personal en la pestaña Automatización de Atajos, basada en el evento \"Cuando se conecta a la corriente\", descrita en los ajustes secretos.",
                "Aprende un forzaje psicológico de animal (preguntas en cascada que casi siempre llevan a \"león\" como primera respuesta espontánea, o al animal que prefieras forzar).",
                "Desactiva \"Preguntar antes de ejecutar\" en la automatización para que se dispare sin confirmación manual."
            ],
            performance: [
                "Conduce al espectador con el forzaje psicológico hacia el animal que ya tienes preparado en la automatización.",
                "Explica que el teléfono puede \"sentir su energía\" a través de la conexión eléctrica.",
                "Pide al espectador que conecte él mismo el cable de carga al teléfono.",
                "Deja que Siri responda automáticamente en voz alta con la predicción, sin que tú toques nada en ese momento."
            ],
            script: [
                "\"Piensa en un animal, el primero que te venga a la mente.\"",
                "\"Conecta tú mismo el cable, sin que yo lo toque.\"",
                "\"Escucha lo que dice el teléfono.\""
            ],
            recoveryTips: [
                "Si el forzaje no funciona del todo, ten una salida narrativa (\"a veces la energía tarda un poco en estabilizarse\") y repite el forzaje con otra pregunta.",
                "Verifica antes de cada actuación que la automatización sigue activa y que el volumen del teléfono está alto."
            ],
            performanceTips: [
                "Que sea el propio espectador quien conecte el cable refuerza que tú no controlaste nada en ese instante.",
                "El verdadero secreto es el forzaje del animal: dedícale más tiempo de práctica que a la propia automatización."
            ],
            variations: [
                "Usa la misma automatización para forzar un color, un número o una palabra en vez de un animal.",
                "Combínalo con la Batería al revés: en vez de conectar, desconectar el cable como disparador alternativo."
            ],
            commonMistakes: [
                "Dejar \"Preguntar antes de ejecutar\" activado, lo que añade un paso de confirmación que rompe la magia del momento.",
                "No practicar suficiente el forzaje psicológico del animal, dependiendo solo de la suerte."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce el forzaje psicológico hacia el animal preparado en la automatización.",
                spectatorAction: "Cree elegir un animal de forma completamente espontánea.",
                simulationNote: "El forzaje es la técnica real; la automatización solo presenta el resultado."
            ),
            PracticeStep(
                performerAction: "Pide al espectador que conecte él mismo el cable de carga.",
                spectatorAction: "Conecta el cable sin que el mago toque el teléfono en ese momento.",
                simulationNote: "El evento de conexión a la corriente dispara automáticamente la automatización."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Batería Profética (automatización)",
        trigger: "Automatización personal: 'Cuando el iPhone se conecta a la corriente'",
        actions: [
            "En la pestaña Automatización, crea 'Nueva automatización personal' → 'Carga' → 'Se conecta'",
            "Añade la acción 'Leer texto en voz alta' con tu predicción del animal",
            "Desactiva 'Preguntar antes de ejecutar' para que se dispare sin confirmación manual"
        ],
        caveat: "El verdadero método es el forzaje psicológico del animal antes de conectar el cable: practica esa parte tanto como la automatización."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .green)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
