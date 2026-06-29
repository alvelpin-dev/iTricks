import SwiftUI

/// "La Agenda Psíquica del Pasado" — Mentalismo.
///
/// Método real: un Atajo que recibe la fecha de nacimiento dicha por el
/// espectador y crea, en el momento, un evento de calendario con fecha
/// retroactiva (el propio día que nació), conteniendo un mensaje
/// preescrito. El sistema permite crear eventos en cualquier fecha, pasada
/// o futura, así que el evento aparece "ya estaba ahí" al navegar a ese día.
enum PsychicPastAgendaEffect: EffectModule {
    static let info = EffectInfo(
        id: "psychic_past_agenda",
        name: "La Agenda Psíquica del Pasado",
        category: .mentalism,
        shortDescription: "Dices tu fecha de nacimiento. El calendario del mago, en ese día exacto de hace años, ya tenía un mensaje para ti.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "calendar.badge.clock",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a alguien que te diga su fecha de nacimiento. Abres el calendario de tu iPhone, viajas exactamente al día en que nació, y hay un evento creado ese mismo día que dice: \"Hoy nació la persona que verá este truco en el futuro\".",
            preparation: [
                "Configura el atajo descrito en los ajustes secretos, que crea el evento de calendario con fecha retroactiva en el momento de la actuación.",
                "Decide el texto exacto del evento (puedes personalizarlo en la configuración secreta)."
            ],
            performance: [
                "Pide a alguien que te diga su fecha de nacimiento completa.",
                "Introduce esa fecha en el atajo de forma disimulada, dejando que cree el evento en segundo plano.",
                "Abre la app Calendario real y navega hasta esa fecha exacta.",
                "Revela el evento ya creado en ese día, como si hubiera estado ahí desde siempre."
            ],
            script: [
                "\"Dime tu fecha de nacimiento completa, día, mes y año.\"",
                "\"Voy a ir a mi calendario, a ese día exacto, hace tantos años...\"",
                "\"Mira esto: ya había un evento creado ese mismo día.\""
            ],
            recoveryTips: [
                "Si el espectador no recuerda el año exacto, pídele que lo confirme con seguridad antes de introducirlo, ya que el evento debe coincidir con el día exacto que va a comprobar.",
                "Practica introducir la fecha rápidamente en el atajo para minimizar el tiempo de espera antes de abrir el calendario."
            ],
            performanceTips: [
                "Navega al calendario con calma, mostrando el recorrido por los meses y años para reforzar que realmente estás llegando a esa fecha concreta.",
                "No reveles el evento de inmediato: deja que el espectador busque la fecha contigo, aumentando la expectativa."
            ],
            variations: [
                "Personaliza el texto del evento con el nombre del espectador si lo conoces de antemano.",
                "Combínalo con un segundo evento en una fecha futura significativa, como cierre de la rutina."
            ],
            commonMistakes: [
                "Introducir mal la fecha en el atajo, lo que crea el evento en un día distinto al esperado.",
                "Mostrar el calendario con muchos otros eventos visibles alrededor, lo que puede distraer de la revelación."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide la fecha de nacimiento completa al espectador.",
                spectatorAction: "Comparte su fecha de nacimiento sin sospechar nada especial.",
                simulationNote: "La fecha se introduce en el atajo justo después de escucharla."
            ),
            PracticeStep(
                performerAction: "Crea el evento retroactivo en segundo plano y navega al calendario real hasta esa fecha.",
                spectatorAction: "Ve al mago navegar el calendario hasta el día exacto de su nacimiento.",
                simulationNote: "El evento se crea en el momento real, pero con la fecha pasada indicada por el espectador."
            ),
            PracticeStep(
                performerAction: "Revela el evento ya presente en ese día.",
                spectatorAction: "Descubre el mensaje preescrito en el día exacto de su nacimiento.",
                simulationNote: "El sistema de calendario permite crear eventos en cualquier fecha pasada sin restricción."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Agenda Psíquica",
        trigger: "Se activa manualmente, introduciendo la fecha dicha por el espectador",
        actions: [
            "Añade 'Solicitar entrada de texto' (o 'Fecha') para capturar día, mes y año de nacimiento",
            "Añade 'Crear evento de calendario' usando esa fecha como inicio del evento, con el texto preescrito como título",
            "Añade 'Abrir calendario' navegando a esa misma fecha como acción final"
        ],
        caveat: "El evento se crea en el momento real, no viaja en el tiempo de verdad: la magia está en que el sistema permite asignarle una fecha de inicio pasada."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .brown)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
