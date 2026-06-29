import SwiftUI

/// "La Calculadora Tóxica Digital" — Números.
///
/// Método real: un Atajo que simula visualmente una calculadora, pero
/// ignora por completo las operaciones matemáticas reales que introduce
/// el espectador. El resultado final siempre es el texto fijo que el mago
/// predeterminó (unas coordenadas, un número de teléfono, una fecha).
enum ToxicCalculatorEffect: EffectModule {
    static let info = EffectInfo(
        id: "toxic_calculator",
        name: "La Calculadora Tóxica Digital",
        category: .numbers,
        shortDescription: "Varias personas suman y multiplican números al azar. El resultado final siempre coincide con tu predicción.",
        difficulty: .intermediate,
        preparationTime: .minutes,
        symbol: "plusminus.circle.fill",
        instructions: EffectInstructions(
            whatItDoes: "Abres una supuesta calculadora y pides a varias personas que sumen y multipliquen números al azar (fechas de cumpleaños, números de la suerte). Al pulsar \"igual\", el resultado coincide exactamente con una predicción que ya tenías preparada.",
            preparation: [
                "Decide de antemano el número que vas a forzar (coordenadas, tu número de teléfono, una fecha significativa).",
                "Construye el atajo simulando una interfaz de calculadora mediante menús de selección o solicitudes de número consecutivas."
            ],
            performance: [
                "Pide a varias personas distintas que aporten un número cada una, aparentando que los vas introduciendo y operando en la calculadora.",
                "Simula pulsar las operaciones (suma, multiplicación) con normalidad en la pantalla.",
                "Al pulsar \"igual\", revela el resultado fijo que coincide con tu predicción.",
                "Conecta el resultado con algo significativo (una ubicación, una fecha) para reforzar el impacto."
            ],
            script: [
                "\"Dime cualquier número, el primero que se te ocurra.\"",
                "\"Vamos a sumarlo, multiplicarlo... y a ver qué sale.\"",
                "\"Este número no es casualidad: son las coordenadas exactas de donde estamos ahora mismo.\""
            ],
            recoveryTips: [
                "Si alguien pide ver el cálculo paso a paso, distrae con humor (\"esta calculadora es bastante reservada con sus procesos\") y sigue adelante con seguridad."
            ],
            performanceTips: [
                "Cuantas más personas aporten números distintos, más imposible parece que el resultado esté predeterminado.",
                "Prepara una buena historia para justificar por qué ese número final es relevante (coordenadas del lugar, fecha especial, etc.)."
            ],
            variations: [
                "Usa como resultado final un número de teléfono real al que llamar en el momento para reforzar la sorpresa.",
                "Combínalo con una fecha relevante para el espectador, presentándolo como \"el destino calculado\"."
            ],
            commonMistakes: [
                "Mostrar la pantalla demasiado tiempo durante la fase de \"cálculo\", dando oportunidad a que alguien note que las operaciones no afectan al resultado.",
                "Usar un número final demasiado largo o complicado de verificar en el momento."
            ],
            recommendedDuration: "2-3 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Pide números a varias personas y simula introducirlos y operarlos.",
                spectatorAction: "Aporta números al azar creyendo que afectan al resultado final.",
                simulationNote: "El atajo ignora por completo los números introducidos."
            ),
            PracticeStep(
                performerAction: "Revela el resultado fijo predeterminado y conéctalo con algo significativo.",
                spectatorAction: "Comprueba que el resultado coincide con algo real e impactante.",
                simulationNote: "El resultado es siempre el mismo texto fijo, sin importar las operaciones simuladas."
            )
        ]
    )

    private static let blueprint = ShortcutBlueprint(
        shortcutName: "Calculadora (interfaz simulada)",
        trigger: "Se abre manualmente como una calculadora normal",
        actions: [
            "Diseña la interfaz con 'Elegir de menú' o 'Solicitar entrada' repetidas, simulando pulsaciones de números y operadores",
            "Ignora los valores introducidos: añade 'Texto' fijo con el resultado predeterminado (coordenadas, teléfono, fecha)",
            "Añade 'Mostrar resultado' con ese texto fijo como pantalla final"
        ],
        caveat: "Cuantos más 'pasos' de introducción simules, más creíble resulta que la calculadora realmente está operando con los números reales."
    )

    static func performView() -> AnyView { AnyView(ShortcutEffectPerformView(info: info, accent: .blue)) }
    static func settingsView() -> AnyView { AnyView(ShortcutEffectSettingsView(title: info.name, blueprint: blueprint)) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}
