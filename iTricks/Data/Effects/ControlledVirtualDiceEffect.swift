import SwiftUI

/// "El Dado Virtual Controlado" — Números.
///
/// Método real: un Atajo con una condición "Si" que comprueba el estado
/// de "No molestar". Si está activado (algo que solo el mago controla
/// desde el Centro de Control), siempre muestra el número forzado. Si
/// está desactivado, lanza un número aleatorio real.
enum ControlledVirtualDiceEffect: EffectModule {
    static let info = EffectInfo(
        id: "controlled_virtual_dice",
        name: "El Dado Virtual Controlado",
        category: .numbers,
        shortDescription: "Un atajo lanza un dado virtual. Cuando lo lanza el espectador sale al azar; cuando lo lanzas tú, siempre aciertas tu predicción.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "die.face.6.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres un atajo que lanza un dado virtual y muestra el resultado en pantalla. El espectador intenta adivinarlo: por mucho que lo lance él, sale un número al azar genuino. Pero cuando lo lanzas tú, siempre sale el número que predijiste.",
            preparation: [
                "Configura el atajo con la condición \"Si\" descrita en los ajustes secretos, basada en el estado de \"No molestar\".",
                "Anuncia o anota tu predicción antes de empezar a lanzar el dado tú mismo.",
                "Practica activar y desactivar \"No molestar\" desde el Centro de Control de forma rápida y disimulada."
            ],
            performance: [
                "Antes de empezar, activa \"No molestar\" en secreto desde el Centro de Control.",
                "Lanza el dado tú primero, mostrando que siempre coincide con tu predicción anunciada.",
                "Desactiva \"No molestar\" disimuladamente antes de entregar el teléfono al espectador.",
                "Deja que el espectador lance varias veces: el resultado será realmente aleatorio cada vez, reforzando que \"él no tiene el don\"."
            ],
            script: [
                "\"He anotado un número del uno al seis antes de empezar.\"",
                "\"Voy a lanzar yo primero...\"",
                "\"Ahora intenta tú, a ver si tienes la misma suerte.\""
            ],
            recoveryTips: [
                "Si olvidas activar \"No molestar\" antes de lanzar tú, el resultado será aleatorio; simplemente preséntalo como un \"lanzamiento de calentamiento\" y repite.",
                "Verifica siempre el estado del icono de \"No molestar\" en la pantalla antes de lanzar, para confirmar que está en el modo correcto."
            ],
            performanceTips: [
                "Deja que el espectador lance varias veces seguidas para que perciba claramente que el resultado cambia cada vez, antes de que tú hagas tu lanzamiento forzado.",
                "No actives ni desactives \"No molestar\" justo delante de la cara del espectador; hazlo mientras hablas o mientras él mira el teléfono."
            ],
            variations: [
                "Usa la misma estructura condicional para forzar un color, una carta o cualquier resultado, no solo un número de dado.",
                "Combínalo con la Calculadora tóxica digital para una rutina de \"control numérico\" más larga."
            ],
            commonMistakes: [
                "Olvidar desactivar \"No molestar\" antes de entregar el teléfono al espectador, lo que haría que él también obtuviera siempre el mismo número.",
                "Activar \"No molestar\" de forma demasiado visible justo antes de lanzar, lo que puede generar sospechas si alguien presta atención."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Activa 'No molestar' en secreto y anuncia tu predicción antes de lanzar.",
                spectatorAction: "Escucha la predicción sin saber el método.",
                simulationNote: "El atajo comprobará el estado de 'No molestar' antes de decidir el resultado."
            ),
            PracticeStep(
                performerAction: "Lanza el dado tú mismo, acertando siempre gracias al modo activado.",
                spectatorAction: "Ve que el resultado coincide exactamente con la predicción.",
                simulationNote: "Con 'No molestar' activado, el atajo siempre devuelve el número forzado."
            ),
            PracticeStep(
                performerAction: "Desactiva 'No molestar' disimuladamente y entrega el teléfono al espectador.",
                spectatorAction: "Lanza varias veces obteniendo resultados realmente aleatorios.",
                simulationNote: "Sin 'No molestar', el atajo genera un número aleatorio genuino entre 1 y 6."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Dado Virtual Controlado",
        trigger: "Se abre manualmente; el resultado depende del estado de 'No molestar'",
        actions: [
            "Añade la acción 'Si' (condicional) comprobando 'Modo Enfoque' o 'No molestar' está activado",
            "Dentro del 'Si' (verdadero): añade 'Texto' fijo = 6 (o el número que quieras forzar)",
            "Dentro del 'En caso contrario': añade 'Número aleatorio entre 1 y 6'",
            "Añade 'Mostrar resultado' al final, fuera del condicional, mostrando el valor obtenido"
        ],
        caveat: "Activa y desactiva 'No molestar' siempre desde el Centro de Control de forma disimulada, nunca delante de la atención directa del espectador."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .blue)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
