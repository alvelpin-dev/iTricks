import SwiftUI

/// "La Foto del Futuro" — Tecnología.
///
/// Método real: un Atajo que simula abrir la Cámara, toma una foto real,
/// y le superpone una capa transparente pre-editada con el nombre del
/// espectador sobre la zona de la mano del mago, guardándola como si
/// fuera la fotografía original sin retoques.
enum FutureSelfieEffect: EffectModule {
    static let info = EffectInfo(
        id: "future_selfie",
        name: "La Foto del Futuro",
        category: .technology,
        shortDescription: "Te haces una selfie con el espectador. Al verla en la galería, sostienes un cartel con su nombre que nunca existió.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "camera.badge.ellipsis",
        instructions: EffectInstructions(
            whatItDoes: "Te haces una selfie con el espectador con tu app de cámara camuflada. Cuando entran a la galería a ver la foto, descubren que en ella el mago sostiene un cartel con el nombre del espectador, aunque nunca tocó ningún cartel real.",
            preparation: [
                "Averigua el nombre del espectador de forma casual al principio de la rutina, antes de llegar a este efecto.",
                "Prepara con antelación una capa transparente con el nombre escrito a mano (o usa una variable de texto editable si tu flujo de edición lo permite) que se superponga sobre la zona de tu mano.",
                "Practica sostener la mano en la posición exacta donde se superpondrá el cartel digital, para que el resultado final sea coherente visualmente."
            ],
            performance: [
                "Abre el atajo camuflado como app de Cámara y haz la selfie con el espectador con normalidad.",
                "Deja que el atajo procese la foto en segundo plano, superponiendo la capa con el nombre.",
                "Espera unos segundos antes de abrir la galería, dando tiempo a que el procesamiento termine.",
                "Muestra la foto final: el espectador verá su nombre en un cartel que nunca existió en el momento de la foto."
            ],
            script: [
                "\"Vamos a hacernos una foto juntos, sonríe.\"",
                "\"Espera, vamos a verla...\"",
                "\"¿Cómo puede ser que yo esté sosteniendo tu nombre si nunca tuve ningún cartel?\""
            ],
            recoveryTips: [
                "Si el procesamiento tarda más de lo esperado, gana tiempo comentando la foto en general antes de abrir la galería.",
                "Ten siempre verificada la ortografía exacta del nombre antes de la actuación, ya que un error sería muy visible en el cartel."
            ],
            performanceTips: [
                "Sostén la mano de forma natural durante la foto, en la posición exacta donde se superpondrá el cartel, para que el resultado parezca auténtico.",
                "No mires la pantalla del teléfono justo después de la foto: deja que sea el espectador quien la abra y descubra el detalle."
            ],
            variations: [
                "En vez de un nombre, usa una palabra que el espectador haya elegido libremente durante la rutina.",
                "Combínalo con el Post de Instagram fantasma para un cierre de rutina con doble impacto visual."
            ],
            commonMistakes: [
                "No comprobar la iluminación y el ángulo de la mano antes de la foto, lo que puede hacer que la superposición se vea poco natural.",
                "Mostrar la foto demasiado rápido, sin dar tiempo a que el espectador procese lo que está viendo."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pregunta el nombre del espectador de forma casual al principio de la rutina.",
                spectatorAction: "Comparte su nombre sin saber que se usará más adelante.",
                simulationNote: "El nombre se necesita preparado antes de llegar a la fase de la foto."
            ),
            PracticeStep(
                performerAction: "Haz la selfie con el atajo camuflado como Cámara, sosteniendo la mano en la posición acordada.",
                spectatorAction: "Posa con normalidad para la foto, sin sospechar nada especial.",
                simulationNote: "El atajo toma la foto real y superpone la capa con el nombre en segundo plano."
            ),
            PracticeStep(
                performerAction: "Abre la galería y muestra el resultado final.",
                spectatorAction: "Descubre su nombre en un cartel que nunca existió durante la foto.",
                simulationNote: "La superposición ya estaba aplicada antes de guardar la imagen en el carrete."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Cámara (interfaz camuflada)",
        trigger: "Se abre manualmente, como si fuera la app Cámara",
        actions: [
            "Cambia el icono y nombre del atajo para que parezca la app Cámara",
            "Añade 'Tomar foto' como primera acción",
            "Añade 'Superponer imagen' con la capa transparente pre-editada del nombre, posicionada sobre la zona de tu mano",
            "Añade 'Guardar en Fotos' con el resultado combinado"
        ],
        caveat: "Necesitas preparar la capa con el nombre antes del show, lo que implica conocer el nombre del espectador con antelación (pregúntalo de forma casual al inicio de la rutina)."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .teal)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
