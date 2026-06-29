import SwiftUI

/// "El Color de la Mente" — Mentalismo.
///
/// Método real: tres atajos distintos, uno por color, cada uno disparado
/// por una combinación discreta diferente (pulsaciones de volumen, o la
/// orientación del teléfono). El mago elige cuál activar según el color
/// que el espectador haya pensado, dando la apariencia de que la
/// pantalla "sabe" el color sin que nadie la haya tocado.
enum MindColorEffect: EffectModule {
    static let info = EffectInfo(
        id: "mind_color",
        name: "El Color de la Mente",
        category: .mentalism,
        shortDescription: "El espectador piensa en un color. Pasas la mano sobre la pantalla apagada y se ilumina exactamente de ese color.",
        difficulty: .advanced,
        preparationTime: .minutes,
        symbol: "paintpalette.fill",
        instructions: EffectInstructions(
            whatItDoes: "El espectador piensa en un color primario. Miras fijamente la pantalla apagada de tu iPhone, pasas la mano por encima sin tocarla, y toda la pantalla se enciende brillando intensamente con el color exacto que el espectador pensó.",
            preparation: [
                "Crea los tres atajos descritos en la configuración secreta (uno por color: rojo, azul, verde), cada uno con su propio disparador discreto.",
                "Practica cada disparador hasta poder activarlo sin que se note ningún gesto especial con las manos.",
                "Aprende un forzaje psicológico de color como respaldo, para aumentar tus probabilidades de tener preparado el color correcto."
            ],
            performance: [
                "Pide al espectador que piense en un color primario (rojo, azul o verde) sin decirlo en voz alta todavía.",
                "Si usas forzaje psicológico, condúcelo hacia uno de los tres colores preparados antes de seguir.",
                "Pide que diga el color en voz alta, y activa discretamente el disparador correspondiente mientras pasas la mano sobre la pantalla.",
                "Deja que la pantalla se ilumine con el color exacto, como si hubiera \"sentido\" el pensamiento."
            ],
            script: [
                "\"Piensa en un color: rojo, azul o verde. El que tú quieras.\"",
                "\"Dime cuál es, y voy a pasar la mano sobre la pantalla sin tocarla.\"",
                "\"Mira cómo se ilumina exactamente de ese color.\""
            ],
            recoveryTips: [
                "Si activas el disparador equivocado por error, recupera el momento diciendo que el primer color fue \"un eco residual\" y repite con el color correcto.",
                "Practica los tres disparadores por separado hasta que actives cada uno sin pensar, evitando confundirlos en el momento."
            ],
            performanceTips: [
                "El gesto de pasar la mano sobre la pantalla debe ser lento y deliberado, dando tiempo a que el disparador se active antes de que la mano termine su recorrido.",
                "Practica frente a un espejo el momento exacto de la activación para que coincida visualmente con el gesto de la mano."
            ],
            variations: [
                "Limita la elección a solo dos colores si te resulta más manejable controlar únicamente dos disparadores.",
                "Combínalo con Siri la Psíquica para una rutina de \"colores imposibles\" con doble confirmación."
            ],
            commonMistakes: [
                "Intentar controlar más de tres colores, lo que complica demasiado los disparadores y aumenta el riesgo de error.",
                "Tocar la pantalla en vez de solo pasar la mano por encima, lo que rompe la idea de que no hay contacto físico."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide al espectador que piense en un color primario.",
                spectatorAction: "Elige mentalmente rojo, azul o verde.",
                simulationNote: "Tienes preparado un atajo distinto para cada uno de los tres colores."
            ),
            PracticeStep(
                performerAction: "Activa discretamente el disparador del color que diga el espectador mientras pasas la mano sobre la pantalla.",
                spectatorAction: "Dice el color en voz alta y ve la pantalla iluminarse de ese color exacto.",
                simulationNote: "El disparador correcto simplemente abre la imagen de ese color a pantalla completa."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Color de la Mente (tres atajos: Rojo, Azul, Verde)",
        trigger: "Tres disparadores discretos distintos: combinaciones de volumen, o automatización por orientación del teléfono",
        actions: [
            "Crea tres atajos, cada uno con 'Abrir foto' a pantalla completa de un color sólido distinto (rojo, azul, verde)",
            "Asigna a cada atajo una automatización personal distinta: por ejemplo, una combinación de pulsaciones de volumen, o el evento de 'orientación del dispositivo' boca arriba/boca abajo",
            "Practica cada disparador por separado hasta poder diferenciarlos sin dudar"
        ],
        caveat: "Tres disparadores simultáneos son difíciles de gestionar en directo: domina cada uno por separado antes de combinarlos en una actuación real."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .purple)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
