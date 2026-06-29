import SwiftUI

/// "El Post de Instagram Fantasma" — Tecnología.
///
/// Método real: una captura de pantalla pre-editada de tu perfil de
/// Instagram, con el área de un papel dejada en blanco a propósito. Un
/// Atajo solicita la palabra elegida por el espectador y la superpone
/// sobre esa zona en blanco, mostrando el resultado a pantalla completa
/// como si fuera la app real.
enum GhostInstagramPostEffect: EffectModule {
    static let info = EffectInfo(
        id: "ghost_instagram_post",
        name: "El Post de Instagram Fantasma",
        category: .technology,
        shortDescription: "Alguien elige una palabra de un libro. Tu perfil de Instagram ya tiene, desde hace horas, una foto sosteniendo esa palabra.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "photo.stack.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le pides a alguien que elija una palabra de un libro. Entras a tu perfil de Instagram y le muestras tu última publicación: una foto tuya subida horas antes donde sostienes un papel con esa palabra exacta escrita a mano.",
            preparation: [
                "Prepara con antelación una captura de pantalla editada de tu perfil de Instagram, donde sostienes un papel cuya área central queda en blanco.",
                "Guarda esa imagen en un lugar accesible para el atajo.",
                "Configura el atajo para que solicite la palabra elegida y la \"dibuje\" sobre el área en blanco antes de mostrar la imagen a pantalla completa."
            ],
            performance: [
                "Pide a alguien que elija libremente una palabra de cualquier libro disponible.",
                "Introduce esa palabra en el atajo de forma disimulada, mientras hablas de otra cosa.",
                "Abre el atajo camuflado como Instagram, mostrando la imagen ya combinada a pantalla completa.",
                "Deja que el espectador vea la \"publicación\" con la palabra exacta, fechada horas antes de la actuación."
            ],
            script: [
                "\"Elige cualquier palabra de este libro, la que tú quieras.\"",
                "\"Vamos a entrar a mi Instagram a ver mi última publicación...\"",
                "\"Esta foto la subí hace horas. Mira lo que sostengo.\""
            ],
            recoveryTips: [
                "Si tardas en introducir la palabra, gana tiempo charlando sobre el libro o la elección antes de \"abrir Instagram\".",
                "Ten siempre la imagen base bien encuadrada y editada para que el papel en blanco sea perfectamente creíble como un papel real en la foto original."
            ],
            performanceTips: [
                "Cuanto más casual sea tu manera de \"entrar a Instagram\", más creíble resulta que es tu perfil real.",
                "No reveles que la imagen es una sola foto estática: desplázate ligeramente como si estuvieras navegando por el perfil antes de mostrarla."
            ],
            variations: [
                "Usa la misma técnica con un mensaje en vez de una palabra suelta, ajustando el área en blanco del papel.",
                "Combínalo con la Foto del futuro para una rutina de \"redes sociales imposibles\" más larga."
            ],
            commonMistakes: [
                "Usar una imagen base de mala calidad o con una iluminación distinta a la palabra superpuesta, lo que rompe la ilusión.",
                "Introducir la palabra demasiado despacio, generando una pausa sospechosa antes de mostrar el resultado."
            ],
            recommendedDuration: "2-4 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide que se elija libremente una palabra de un libro.",
                spectatorAction: "Elige una palabra cualquiera, creyendo que es completamente al azar.",
                simulationNote: "La palabra se introduce en el atajo en el momento, de forma disimulada."
            ),
            PracticeStep(
                performerAction: "Abre el atajo camuflado como Instagram y muestra el resultado combinado.",
                spectatorAction: "Ve la publicación con la palabra exacta, fechada antes de la actuación.",
                simulationNote: "La imagen es una vista rápida de una captura pre-editada con la palabra superpuesta sobre el área en blanco."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Instagram (interfaz camuflada)",
        trigger: "Se abre manualmente, como si fuera la app Instagram",
        actions: [
            "Añade 'Solicitar entrada de texto' para la palabra elegida por el espectador",
            "Añade 'Superponer texto' sobre la imagen pre-editada de tu perfil, posicionando la palabra en el área en blanco del papel",
            "Añade 'Vista rápida' mostrando la imagen combinada a pantalla completa"
        ],
        caveat: "La imagen base debe prepararse con mucho cuidado de antemano: la calidad de la edición es lo que determina si el efecto resulta creíble."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .pink)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
