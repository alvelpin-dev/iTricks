import SwiftUI

/// "El Reloj Detenido en el Tiempo" — Tecnología.
///
/// Método real: el iPhone nunca cambia su hora de sistema mediante un
/// Atajo (Apple no lo permite). En su lugar, el atajo abre a pantalla
/// completa una imagen pre-editada idéntica a la interfaz del teléfono,
/// pero con la hora forzada ya escrita en ella, sustituyendo visualmente
/// a la pantalla real durante unos segundos.
enum FrozenClockEffect: EffectModule {
    static let info = EffectInfo(
        id: "frozen_clock",
        name: "El Reloj Detenido en el Tiempo",
        category: .technology,
        shortDescription: "Le pides al espectador una hora especial para él. Frotas la pantalla y la hora del teléfono cambia al instante.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "clock.badge.fill",
        instructions: EffectInstructions(
            whatItDoes: "Muestras la pantalla de tu iPhone con la hora real. Le pides al espectador que piense en una hora especial para él. La nombra, frotas la pantalla y, mágicamente, la hora mostrada cambia instantáneamente a la que dijo.",
            preparation: [
                "Haz una captura de pantalla de tu pantalla de inicio o bloqueo real y edítala para mostrar distintas horas posibles (cubre las más probables: horas redondas, horas con significado como cumpleaños).",
                "Guarda cada imagen editada como una opción distinta en el atajo o en un álbum identificable.",
                "Practica el gesto de \"frotar\" la pantalla de forma natural justo antes de abrir la imagen."
            ],
            performance: [
                "Muestra la pantalla real con la hora actual, dejando claro que es la hora normal del teléfono.",
                "Pide al espectador que piense en una hora especial para él y que la diga en voz alta.",
                "Frota la pantalla con la mano mientras, con la otra, activas discretamente el atajo correspondiente a esa hora.",
                "Revela la imagen con la hora forzada como si fuera la pantalla real cambiando en tiempo real."
            ],
            script: [
                "\"Mira la hora real de mi teléfono.\"",
                "\"Piensa en una hora que sea especial para ti, y dime cuál es.\"",
                "\"Voy a frotar la pantalla... y mira lo que pasa.\""
            ],
            recoveryTips: [
                "Si el espectador dice una hora para la que no tienes imagen preparada, redirige sutilmente la pregunta (\"piensa en una hora en punto o y media, más fácil de recordar\") antes de pedir que la diga.",
                "Mantén el teléfono ligeramente alejado del espectador durante el \"cambio\", para que no pueda ver el gesto de activar el atajo."
            ],
            performanceTips: [
                "El gesto de frotar la pantalla debe ser visualmente convincente y coincidir en tiempo con la apertura de la imagen.",
                "Vuelve a la pantalla real de forma natural después de la revelación, sin dejar la imagen abierta demasiado tiempo."
            ],
            variations: [
                "Usa el mismo método para cambiar \"mágicamente\" la fecha en vez de la hora.",
                "Combínalo con una predicción sellada física que indique la hora antes de que el espectador la diga."
            ],
            commonMistakes: [
                "Usar una imagen que no coincide exactamente con tu fondo de pantalla real, lo que delata el cambio al ojo entrenado.",
                "Dejar la imagen abierta tanto tiempo que el espectador intente tocar la pantalla y se dé cuenta de que no responde como una interfaz real."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Muestra la hora real del teléfono y pide una hora especial al espectador.",
                spectatorAction: "Piensa y nombra una hora significativa para él.",
                simulationNote: "Necesitas tener preparada una imagen editada para esa hora exacta o una muy cercana."
            ),
            PracticeStep(
                performerAction: "Frota la pantalla mientras activas discretamente la imagen correspondiente.",
                spectatorAction: "Ve la hora 'cambiar' ante sus ojos.",
                simulationNote: "La hora del sistema nunca cambió: solo se muestra una imagen idéntica a la interfaz real."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Reloj Detenido (una imagen por hora forzada)",
        trigger: "Se activa manualmente al frotar la pantalla",
        actions: [
            "Haz una captura de tu pantalla real y edítala para cada hora que quieras poder forzar",
            "Añade 'Abrir foto' a pantalla completa con la imagen correspondiente a la hora elegida"
        ],
        caveat: "El iPhone no permite que una app de terceros cambie la hora real del sistema; este efecto es una ilusión visual con una imagen idéntica a tu interfaz, no un cambio real."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .orange)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
