import SwiftUI

/// "Telepatía Musical con Shazam" — Tecnología.
///
/// Método real: un Atajo disparado de forma discreta (botón de volumen o
/// frase clave) que simplemente busca y reproduce una canción concreta.
/// El verdadero secreto es un forzaje psicológico de canción: la
/// tecnología solo ejecuta la reproducción en el momento exacto.
enum MusicalTelepathyEffect: EffectModule {
    static let info = EffectInfo(
        id: "musical_telepathy",
        name: "Telepatía Musical con Shazam",
        category: .technology,
        shortDescription: "Alguien piensa en una canción famosa. El teléfono, boca abajo sobre la mesa, empieza a reproducirla solo.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "music.note",
        instructions: EffectInstructions(
            whatItDoes: "Pides a alguien que piense en una canción muy famosa. Colocas el teléfono boca abajo sobre la mesa. El espectador se concentra, y de repente el teléfono empieza a reproducir exactamente esa canción.",
            preparation: [
                "Aprende un forzaje psicológico de canción (preguntas en cascada hacia un puñado de canciones muy famosas y predecibles).",
                "Crea un atajo por cada canción que puedas forzar, cada uno con su propio disparador discreto (combinación de botón de volumen, o frase clave).",
                "Practica el disparador hasta que puedas activarlo sin mover visiblemente las manos."
            ],
            performance: [
                "Conduce al espectador con el forzaje psicológico hacia una de las canciones que tienes preparadas.",
                "Coloca el teléfono boca abajo sobre la mesa, lejos de tus manos si es posible.",
                "Pide que se concentre intensamente en la canción durante unos segundos.",
                "Dispara discretamente el atajo correspondiente; la música empezará a sonar como si el teléfono \"hubiera escuchado\" su mente."
            ],
            script: [
                "\"Piensa en una canción muy famosa, de las que todo el mundo conoce.\"",
                "\"Concéntrate en ella, en la melodía, en la letra.\"",
                "\"Vamos a ver si el teléfono puede escuchar tu mente.\""
            ],
            recoveryTips: [
                "Si el forzaje no funciona del todo, ten un atajo de \"comodín\" con una canción universalmente reconocible como salida.",
                "Practica el disparador discreto en distintas posiciones de mano para no depender de un solo gesto reconocible."
            ],
            performanceTips: [
                "Aléjate físicamente del teléfono tras colocarlo en la mesa, reforzando que no lo estás tocando cuando empieza a sonar.",
                "El verdadero trabajo está en el forzaje de canción: dedícale más tiempo de práctica que al propio atajo."
            ],
            variations: [
                "Usa la misma técnica con un álbum o artista en vez de una canción concreta, dando más margen al forzaje.",
                "Combínalo con un altavoz inteligente en la sala en vez del propio teléfono, para distanciar aún más la sospecha."
            ],
            commonMistakes: [
                "Forzar siempre la misma canción ante el mismo grupo de personas en sesiones distintas.",
                "Tener las manos demasiado cerca del teléfono o de los botones de volumen, lo que delata el disparador."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Conduce el forzaje psicológico de canción.",
                spectatorAction: "Cree elegir una canción famosa de forma completamente libre.",
                simulationNote: "El forzaje es la técnica real; determina qué atajo vas a disparar después."
            ),
            PracticeStep(
                performerAction: "Coloca el teléfono boca abajo y dispara discretamente el atajo correspondiente.",
                spectatorAction: "Se concentra en la canción mientras observa el teléfono en reposo.",
                simulationNote: "El atajo solo busca y reproduce la canción; no hay ningún análisis real del pensamiento."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Telepatía Musical (uno por canción)",
        trigger: "Disparador discreto: combinación de botón de volumen, o frase clave de Siri en voz muy baja",
        actions: [
            "Crea una automatización personal asociada al disparador elegido",
            "Añade 'Buscar música' con el título exacto de la canción que vas a forzar",
            "Añade 'Reproducir música' con el resultado de la búsqueda anterior"
        ],
        caveat: "Necesitas un atajo distinto por cada canción que quieras poder forzar; prepara solo las 3-4 más probables según tu forzaje."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .pink)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
