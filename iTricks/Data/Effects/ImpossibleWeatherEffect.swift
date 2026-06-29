import SwiftUI

/// "El Clima Imposible" — Tecnología.
///
/// Método real: un Atajo en dos fases. Al principio del show, captura el
/// nombre del espectador discretamente. Más tarde, abre una página web
/// simple (HTML básico) que imita visualmente la app Clima, combinando
/// la ciudad nombrada con el nombre guardado previamente.
enum ImpossibleWeatherEffect: EffectModule {
    static let info = EffectInfo(
        id: "impossible_weather",
        name: "El Clima Imposible",
        category: .technology,
        shortDescription: "Alguien nombra una ciudad cualquiera. Tu 'app del clima' muestra un pronóstico imposible con su nombre incluido.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "cloud.snow.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a alguien que te diga una ciudad del mundo donde le encantaría estar. Abres tu \"app del clima\" y el pronóstico dice que en esa ciudad hay una tormenta de nieve, con un mensaje flotante: \"Ideal para que [nombre del espectador] viaje hoy\".",
            preparation: [
                "Al principio de tu rutina (o de la sesión), pide el nombre del espectador de forma casual e introdúcelo en la primera fase del atajo.",
                "Prepara la página HTML simple que imita la interfaz de la app Clima en la configuración secreta de este efecto."
            ],
            performance: [
                "Pide el nombre del espectador casualmente al principio de tu actuación, antes de llegar a este efecto.",
                "Más adelante, pide que nombre una ciudad del mundo donde le encantaría estar.",
                "Abre el atajo camuflado como app del Clima.",
                "Muestra el resultado combinando la ciudad nombrada con el nombre guardado previamente, como si fuera un pronóstico real y personalizado."
            ],
            script: [
                "\"Antes de empezar, ¿cómo te llamas?\" (pregúntalo casualmente, sin relacionarlo con el truco)",
                "\"Dime una ciudad del mundo donde te encantaría estar ahora mismo.\"",
                "\"Mira esto... el clima ya sabe que tú deberías estar ahí.\""
            ],
            recoveryTips: [
                "Si olvidaste pedir el nombre al principio, puedes pedirlo en cualquier momento previo a abrir el atajo, siempre que parezca una pregunta casual y no conectada.",
                "Ten preparado un mensaje genérico sin nombre como salida de emergencia si no llegaste a capturarlo."
            ],
            performanceTips: [
                "Separa claramente en el tiempo el momento de pedir el nombre y el de pedir la ciudad, para que no parezcan relacionados.",
                "Usa una interfaz visual lo más parecida posible a la app Clima real para reforzar la credibilidad."
            ],
            variations: [
                "Sustituye la tormenta de nieve por cualquier condición climática extrema, ajustada al tono de tu actuación.",
                "Combínalo con El Post de Instagram fantasma para una rutina de \"apps falsas\" más larga."
            ],
            commonMistakes: [
                "Pedir el nombre del espectador justo antes de la ciudad, lo que delata la conexión entre ambos datos.",
                "Usar un diseño poco convincente que no se parece a la app Clima real."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide el nombre del espectador de forma casual al principio del show.",
                spectatorAction: "Comparte su nombre sin sospechar que se usará más adelante.",
                simulationNote: "El nombre se guarda en el atajo para usarse mucho más tarde, separado en el tiempo."
            ),
            PracticeStep(
                performerAction: "Pide una ciudad y abre el atajo camuflado como app del Clima.",
                spectatorAction: "Nombra libremente cualquier ciudad del mundo.",
                simulationNote: "El atajo combina la ciudad nombrada con el nombre guardado previamente en una página HTML simulada."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "App del Clima (interfaz simulada)",
        trigger: "Se ejecuta en dos fases: primero pide el nombre, después muestra el resultado",
        actions: [
            "Fase 1 (al inicio del show): añade 'Solicitar entrada de texto' para el nombre del espectador y guárdalo en una variable",
            "Fase 2 (más adelante): añade 'Solicitar entrada de texto' para la ciudad nombrada",
            "Añade 'Mostrar página web' con un HTML simple que imite la interfaz del Clima, combinando ciudad + nombre guardado mediante texto"
        ],
        caveat: "Necesitas mantener la app Atajos abierta o reanudar el mismo atajo entre la fase 1 y la fase 2 para conservar el nombre guardado."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .cyan)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
