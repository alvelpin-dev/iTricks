import SwiftUI

/// "El Lector de Mentes Numérico" — Mentalismo.
///
/// Método real: un Atajo de Siri camuflado como una app de notas. Al
/// abrirse, solicita un número al espectador y lo envía en segundo plano
/// (mensaje, Apple Watch o webhook a un cómplice) antes de abrir la app
/// Notas real para disimular que no ha pasado nada fuera de lo normal.
enum NumericMindReaderEffect: EffectModule {
    static let info = EffectInfo(
        id: "numeric_mind_reader",
        name: "El Lector de Mentes Numérico",
        category: .mentalism,
        shortDescription: "El espectador escribe un número secreto en una 'app de notas'. Sin mirar, lo adivinas al instante.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "note.text",
        instructions: EffectInstructions(
            whatItDoes: "Le pides al espectador que abra una supuesta app de notas de seguridad en tu iPhone y escriba un número secreto de tres cifras. Te devuelve el teléfono bloqueado y, sin mirar la pantalla, adivinas el número de inmediato.",
            preparation: [
                "Crea el atajo descrito en la configuración secreta de este efecto: cámbiale el icono y el nombre para que parezca una app de notas corriente.",
                "Configura el envío en segundo plano (mensaje a tu Apple Watch, o a un cómplice) y compruébalo varias veces antes de actuar.",
                "Verifica que el atajo termina abriendo la app Notas real, para que el espectador no note nada raro al devolverte el teléfono."
            ],
            performance: [
                "Entrega el teléfono ya con el atajo camuflado abierto y pide que escriba un número secreto de tres cifras que solo él conozca.",
                "Pide que bloquee el teléfono y te lo devuelva sin decirte el número.",
                "Sin mirar la pantalla, consulta discretamente la notificación o el Apple Watch donde ha llegado el número.",
                "Anuncia el número con seguridad, como si lo hubieras leído directamente de su mente."
            ],
            script: [
                "\"Voy a abrirte una app de notas seguras. Escribe un número de tres cifras que solo tú sepas.\"",
                "\"Bloquea el teléfono y dámelo, no necesito verlo.\"",
                "\"Tu número es...\""
            ],
            recoveryTips: [
                "Si el mensaje en segundo plano no llega a tiempo, gana segundos pidiendo al espectador que repita mentalmente el número \"para concentrarte mejor\".",
                "Ten siempre un método de respaldo (mirar el Apple Watch con disimulo) por si el cómplice no está disponible."
            ],
            performanceTips: [
                "Practica el lenguaje corporal de \"no mirar la pantalla\" de forma exagerada y visible, para remarcar que no hiciste trampa obvia.",
                "No reveles el número inmediatamente: deja una pausa dramática como si estuvieras \"recibiendo\" la información."
            ],
            variations: [
                "Pide una palabra corta en vez de un número, usando la acción de entrada de texto en lugar de número.",
                "Combínalo con un efecto de predicción sellada para reforzar el cierre."
            ],
            commonMistakes: [
                "No probar el envío en segundo plano en el lugar real de la actuación (el wifi o los datos pueden fallar).",
                "Dejar visible el verdadero nombre del atajo en la pantalla de inicio antes de camuflarlo."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Entrega el teléfono con el atajo camuflado como app de notas.",
                spectatorAction: "Escribe un número secreto de tres cifras sin que el mago mire.",
                simulationNote: "El atajo envía el número en segundo plano antes de abrir la app Notas real."
            ),
            PracticeStep(
                performerAction: "Recibe el número en tu Apple Watch o por el cómplice, sin mirar el teléfono.",
                spectatorAction: "Devuelve el teléfono bloqueado, convencido de que nadie pudo verlo.",
                simulationNote: "El envío ya ocurrió automáticamente al escribir el número, antes del bloqueo."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Notas Seguras (nombre e icono camuflados)",
        trigger: "Se abre manualmente, igual que cualquier app, al entregar el teléfono",
        actions: [
            "Cambia el nombre del atajo y su icono en pantalla de inicio para que parezca una app de notas",
            "Añade 'Solicitar entrada' configurada como Número",
            "Añade 'Enviar mensaje' (a tu Apple Watch) o 'Obtener contenido de URL' apuntando a un webhook propio, enviando el número introducido",
            "Añade 'Abrir app' → Notas, como acción final"
        ],
        caveat: "Prueba el envío en segundo plano en el lugar real de la actuación: sin wifi o datos, el mensaje puede no llegar a tiempo."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .purple)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
