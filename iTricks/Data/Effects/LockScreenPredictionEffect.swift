import SwiftUI

/// "La Predicción en la Pantalla de Bloqueo" — Cartas.
///
/// Método real: la función Toque Posterior (Back Tap) del iPhone, que
/// dispara un Atajo con un doble toque en la parte trasera del teléfono.
/// El atajo busca una foto concreta en un álbum y la establece como fondo
/// de pantalla de bloqueo, justo cuando sacas el teléfono del bolsillo.
enum LockScreenPredictionEffect: EffectModule {
    static let info = EffectInfo(
        id: "lock_screen_prediction",
        name: "La Predicción en la Pantalla de Bloqueo",
        category: .cards,
        shortDescription: "Un espectador nombra una carta. Al sacar el teléfono del bolsillo, su pantalla de bloqueo ya la muestra.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "lock.rectangle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Un espectador nombra una carta cualquiera. Sacas tu teléfono del bolsillo y, al encender la pantalla, el fondo de bloqueo muestra una imagen gigante de esa misma carta.",
            preparation: [
                "Fotografía o diseña una imagen grande de cada carta que vayas a forzar y guárdalas en un álbum dedicado de Fotos.",
                "Activa Toque Posterior en Ajustes > Accesibilidad > Toque posterior > Doble toque, y asígnalo a este atajo.",
                "Combina este efecto con Adivina cualquier carta o cualquier técnica de fuerza de carta, para garantizar qué carta va a nombrar el espectador."
            ],
            performance: [
                "Fuerza la elección de la carta mediante la técnica que prefieras (cortes, equívoco, carta clásica forzada).",
                "Cuando el espectador nombre la carta, mete la mano al bolsillo con naturalidad.",
                "Da un doble toque discreto en la parte trasera del teléfono mientras lo sacas: el atajo cambiará el fondo de bloqueo en segundo plano.",
                "Enciende la pantalla mostrando la pantalla de bloqueo con la carta ya como fondo."
            ],
            script: [
                "\"Nombra cualquier carta de la baraja, la que tú quieras.\"",
                "\"Voy a sacar mi teléfono... fíjate en la pantalla de bloqueo.\"",
                "\"¿Cómo puede ser que ya estuviera ahí?\""
            ],
            recoveryTips: [
                "Practica el doble toque hasta que sea indistinguible de sostener el teléfono con normalidad; un toque mal ejecutado no disparará el atajo.",
                "Si el doble toque falla, tendrás que recurrir a otro cierre alternativo, así que ensaya la activación muchísimas veces antes de actuar en vivo."
            ],
            performanceTips: [
                "No mires el teléfono mientras lo sacas; mantén el contacto visual con el público para que el momento de la revelación sea más fuerte.",
                "Deja pasar un segundo entre sacar el teléfono y encender la pantalla, dando tiempo a que el atajo termine de cambiar el fondo."
            ],
            variations: [
                "En vez de cartas, usa esta misma técnica para forzar un número, un nombre o un emoji.",
                "Combínalo con la pantalla de inicio en vez de la de bloqueo, usando la acción equivalente."
            ],
            commonMistakes: [
                "No practicar suficiente el Toque Posterior, lo que provoca fallos de activación en pleno show.",
                "Olvidar regresar el fondo de pantalla a la imagen original después de la actuación, dejando la carta puesta para la próxima vez que uses el teléfono."
            ],
            recommendedDuration: "1-2 minutos (más el cierre del forzaje de carta)"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Fuerza la elección de una carta concreta mediante otra técnica del repertorio.",
                spectatorAction: "Cree elegir libremente una carta cualquiera.",
                simulationNote: "La carta nombrada debe coincidir con la foto ya guardada en el álbum de predicciones."
            ),
            PracticeStep(
                performerAction: "Da un doble toque discreto en la parte trasera del teléfono al sacarlo del bolsillo.",
                spectatorAction: "No nota ningún gesto especial al ver al mago sacar el teléfono.",
                simulationNote: "Toque Posterior dispara el atajo que cambia el fondo de bloqueo en segundo plano."
            ),
            PracticeStep(
                performerAction: "Enciende la pantalla y revela la predicción ya puesta como fondo.",
                spectatorAction: "Ve la carta exacta que nombró, ya en la pantalla de bloqueo.",
                simulationNote: "El cambio de fondo ocurrió en el segundo que tardaste en sacar el teléfono del bolsillo."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Predicción de Pantalla de Bloqueo",
        trigger: "Toque Posterior — Doble toque (Ajustes > Accesibilidad > Toque posterior)",
        actions: [
            "Añade 'Buscar fotos' filtrando por el álbum 'Predicciones' y el nombre de archivo de la carta forzada",
            "Añade 'Establecer fondo de pantalla' seleccionando 'Pantalla de bloqueo' y la foto encontrada"
        ],
        caveat: "Necesitas un atajo distinto (o una variable) por cada carta que quieras poder forzar; prepara con antelación las fotos de las cartas que vayas a usar."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .red)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
