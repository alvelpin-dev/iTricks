import SwiftUI

/// "El Peso Digital Imposible" — Herramientas.
///
/// El iPhone 11 no tiene ningún sensor capaz de pesar objetos reales. El
/// Atajo simula visualmente una báscula, y el "peso" mostrado depende por
/// completo de en qué zona de la pantalla el mago indique que se colocó
/// el objeto, no de ninguna medición física genuina.
enum ImpossibleWeightEffect: EffectModule {
    static let info = EffectInfo(
        id: "impossible_weight",
        name: "El Peso Digital Imposible",
        category: .tools,
        shortDescription: "Tu iPhone se convierte en una báscula de precisión. Cuando tú pesas un objeto, siempre acierta su peso real.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "scalemass.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres una supuesta aplicación que convierte la pantalla de tu iPhone en una báscula de alta precisión. Colocas un objeto pequeño y la pantalla muestra el peso exacto en gramos. Cuando un espectador coloca el mismo objeto, el peso mostrado cambia drásticamente.",
            preparation: [
                "Pesa de antemano el objeto que vas a usar (una llave, una moneda) en una báscula real, y memoriza su peso exacto.",
                "Configura el atajo descrito en los ajustes secretos, que pregunta en qué zona de la pantalla se coloca el objeto antes de mostrar el resultado."
            ],
            performance: [
                "Presenta el teléfono como una báscula de precisión usando la sensibilidad de la pantalla.",
                "Coloca tú mismo el objeto en la esquina superior derecha (la zona que has memorizado como \"tu zona\"), y responde así cuando el atajo te pregunte dónde lo colocaste.",
                "Muestra el peso exacto y correcto, reforzando la credibilidad del aparato.",
                "Pide a un espectador que coloque el mismo objeto, indicando esta vez que lo puso en el centro: el resultado será aleatorio o un mensaje de error de calibración."
            ],
            script: [
                "\"Esta pantalla tiene sensores de presión capaces de medir peso con precisión.\"",
                "\"Mira, coloco la llave aquí... exactamente 4 gramos.\"",
                "\"Ahora pruébalo tú... interesante, el peso ha cambiado por completo.\""
            ],
            recoveryTips: [
                "Si te equivocas al indicar la zona donde colocaste el objeto, el atajo mostrará un resultado distinto al esperado; responde siempre con seguridad sobre qué zona elegiste.",
                "Ten preparada una explicación divertida para el \"error de calibración\" cuando lo active un espectador, como parte del espectáculo."
            ],
            performanceTips: [
                "Practica indicar siempre la misma zona para tus propias mediciones, de forma consistente y memorizable.",
                "Deja que distintas personas prueben colocando el objeto en el centro, reforzando que solo tú obtienes mediciones \"correctas\"."
            ],
            variations: [
                "Usa dos objetos de pesos distintos y memorizados, ampliando la rutina con varias mediciones \"precisas\" tuyas.",
                "Presenta el efecto como una prueba de \"conexión especial\" con los objetos en vez de hablar de sensores."
            ],
            commonMistakes: [
                "Olvidar en qué zona memorizada debes colocar el objeto para obtener el peso correcto.",
                "Dejar que el espectador vea tu mano elegir deliberadamente una zona concreta de la pantalla."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Memoriza el peso real de tu objeto y la zona de pantalla que vas a indicar siempre como la tuya.",
                spectatorAction: "No participa todavía.",
                simulationNote: "El peso 'correcto' es simplemente el dato real que memorizaste de antemano."
            ),
            PracticeStep(
                performerAction: "Coloca el objeto en tu zona memorizada e indica esa zona cuando el atajo lo pregunte.",
                spectatorAction: "Ve el peso exacto y correcto aparecer en pantalla.",
                simulationNote: "El atajo simplemente muestra el número fijo asociado a esa zona."
            ),
            PracticeStep(
                performerAction: "Pide al espectador que coloque el mismo objeto en el centro.",
                spectatorAction: "Ve un peso completamente distinto o un mensaje de error.",
                simulationNote: "La zona 'centro' está asociada a un resultado aleatorio o de error, no a una medición real."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Báscula de Precisión (interfaz simulada)",
        trigger: "Se abre manualmente como una app de báscula",
        actions: [
            "Añade 'Elegir de menú' preguntando en qué zona se coloca el objeto (por ejemplo: 'Esquina superior derecha' / 'Centro')",
            "Si la respuesta es 'Esquina superior derecha': añade 'Texto' fijo con el peso real memorizado del objeto",
            "Si la respuesta es 'Centro': añade 'Número aleatorio' o el texto 'Error de calibración'",
            "Añade 'Mostrar resultado' con el valor correspondiente"
        ],
        caveat: "El iPhone 11 no tiene ningún sensor de presión capaz de pesar objetos reales; todo el efecto depende de que tú indiques siempre la misma zona memorizada para tus propias mediciones."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .gray)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
