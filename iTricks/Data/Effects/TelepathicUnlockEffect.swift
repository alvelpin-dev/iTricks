import SwiftUI

/// "El Desbloqueo Telepático" — Paranormal.
///
/// Método real: una ilusión de presentación cronometrada. El mago dispara
/// discretamente (con una frase clave casi inaudible o un gesto de
/// accesibilidad) una transición visual que imita el desbloqueo, mientras
/// controla con disimulo el verdadero desbloqueo biométrico del
/// dispositivo. No existe una forma real de que un espectador desbloquee
/// el teléfono con la mente: el efecto vive entera y honestamente en la
/// actuación y el timing.
enum TelepathicUnlockEffect: EffectModule {
    static let info = EffectInfo(
        id: "telepathic_unlock",
        name: "El Desbloqueo Telepático",
        category: .paranormal,
        shortDescription: "El espectador mira la pantalla bloqueada y se concentra en la palabra 'Abrir'. Sin tocarlo nadie, el teléfono se desbloquea.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "lock.open.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le das tu iPhone bloqueado al espectador. Le pides que mire la pantalla y se concentre en la palabra \"Abrir\". Sin que uses Face ID de forma visible y sin tocar el dispositivo, el teléfono se desbloquea solo ante sus ojos.",
            preparation: [
                "Practica sostener el teléfono en un ángulo donde Face ID pueda capturar tu rostro de reojo sin que parezca intencionado.",
                "Configura una frase clave discreta o un gesto de accesibilidad como disparador de la transición visual, descrito en los ajustes secretos.",
                "Ensaya la sincronización entre tu disparador discreto y el desbloqueo real, para que ambos coincidan en el tiempo."
            ],
            performance: [
                "Sujeta el teléfono de forma que tu rostro quede dentro del ángulo de Face ID sin que sea evidente.",
                "Pide al espectador que mire fijamente la pantalla bloqueada y se concentre en la palabra \"Abrir\".",
                "Dispara discretamente tu frase clave o gesto, mientras Face ID confirma tu rostro de reojo en el mismo instante.",
                "Deja que la pantalla se desbloquee de forma natural ante los ojos del espectador, atribuyendo el resultado a su concentración."
            ],
            script: [
                "\"Mira fijamente la pantalla y concéntrate en la palabra Abrir.\"",
                "\"No voy a tocarlo, ni siquiera lo estoy mirando yo.\"",
                "\"¿Ves? Tu mente lo ha desbloqueado.\""
            ],
            recoveryTips: [
                "Si Face ID no reconoce tu rostro a la primera (por el ángulo), tendrás que intentarlo de nuevo de forma disimulada; practica mucho el ángulo exacto antes de actuar.",
                "Ten una salida narrativa si falla (\"a veces necesita más concentración\") para poder reintentarlo con naturalidad."
            ],
            performanceTips: [
                "Este efecto depende casi enteramente de tu manejo del ángulo y del timing: practica frente a un espejo muchísimas veces.",
                "Nunca afirmes explícitamente que usaste Face ID; deja que el público asuma lo que quiera sobre el método."
            ],
            variations: [
                "Combínalo con una frase de presentación sobre energía mental para reforzar la narrativa paranormal.",
                "Usa el mismo principio con el desbloqueo por huella en modelos que la tengan, ajustando el método de captura disimulada."
            ],
            commonMistakes: [
                "Sostener el teléfono de forma demasiado rígida o forzada, lo que hace evidente que estás intentando posicionar tu rostro.",
                "Mirar directamente la pantalla en el momento del desbloqueo, en vez de mantener la mirada en el espectador."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Sujeta el teléfono en el ángulo practicado, con tu rostro dentro del alcance de Face ID de forma disimulada.",
                spectatorAction: "Mira fijamente la pantalla bloqueada, sin sospechar del ángulo del teléfono.",
                simulationNote: "El verdadero desbloqueo lo realiza Face ID reconociendo tu rostro, no la mente del espectador."
            ),
            PracticeStep(
                performerAction: "Pide concentración y deja que el desbloqueo ocurra de forma natural.",
                spectatorAction: "Ve la pantalla desbloquearse mientras se concentra en la palabra 'Abrir'.",
                simulationNote: "La sincronización entre la petición de concentración y el desbloqueo real es lo que vende el efecto."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Desbloqueo Telepático (apoyo visual opcional)",
        trigger: "Frase clave discreta o gesto de accesibilidad, sincronizado con el ángulo de Face ID",
        actions: [
            "Opcional: crea un atajo disparado por una frase de Siri en voz muy baja, que simplemente muestre una transición visual de apoyo",
            "El mecanismo principal no depende del atajo, sino del ángulo real de Face ID y el timing de la actuación"
        ],
        caveat: "No existe una forma real de que el dispositivo se desbloquee 'con la mente'. Este efecto es honestamente una ilusión de actuación y timing sobre el desbloqueo biométrico real del teléfono."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .indigo)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
