import SwiftUI

/// "El Clima Imposible" — Tecnología.
///
/// Método real (integrado en la app): una sola pantalla con dos etapas.
/// Primero el mago teclea discretamente el nombre captado al inicio de
/// la rutina; más tarde, en la misma pantalla, introduce la ciudad que
/// nombre el espectador. Una interfaz que imita visualmente la app
/// Clima combina ambos datos en una condición climática extrema forzada.
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

    static func performView() -> AnyView { AnyView(ImpossibleWeatherPerformView()) }
    static func settingsView() -> AnyView { AnyView(ImpossibleWeatherSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private enum WeatherStage {
    case nameEntry, cityEntry, result
}

private struct ImpossibleWeatherPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("impossible_weather_condition") private var condition = "Tormenta de nieve"
    @AppStorage("impossible_weather_icon") private var iconName = "cloud.snow.fill"
    @State private var stage: WeatherStage = .nameEntry
    @State private var name = ""
    @State private var city = ""

    var body: some View {
        NavigationStack {
            Group {
                switch stage {
                case .nameEntry: nameEntryContent
                case .cityEntry: cityEntryContent
                case .result: resultContent
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var nameEntryContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Text("Nombre captado al inicio del show")
                .font(Theme.Typography.headline)
            TextField("Nombre", text: $name)
                .multilineTextAlignment(.center)
                .padding().glassCardStyle()
                .padding(.horizontal, Theme.Spacing.lg)
            PrimaryButton("Guardar y continuar", symbol: "checkmark", tint: .cyan) {
                withAnimation { stage = .cityEntry }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            Spacer()
        }
    }

    private var cityEntryContent: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Text("Ciudad nombrada por el espectador")
                .font(Theme.Typography.headline)
            TextField("Ciudad", text: $city)
                .multilineTextAlignment(.center)
                .padding().glassCardStyle()
                .padding(.horizontal, Theme.Spacing.lg)
            PrimaryButton("Mostrar el clima", symbol: "cloud.fill", tint: .cyan) {
                withAnimation(Theme.AnimationCurve.standard) { stage = .result }
                MagicEngine.performReveal()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .disabled(city.trimmingCharacters(in: .whitespaces).isEmpty)
            Spacer()
        }
    }

    private var resultContent: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Spacer()
            Text(city)
                .font(.system(size: 34, weight: .semibold, design: .rounded))
            Image(systemName: iconName)
                .font(.system(size: 64))
                .foregroundStyle(.cyan)
            Text(condition)
                .font(Theme.Typography.headline)
            Text("Ideal para que \(name) viaje hoy")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
                .padding(.top, Theme.Spacing.sm)
            Spacer()
        }
    }
}

private struct ImpossibleWeatherSettingsView: View {
    @AppStorage("impossible_weather_condition") private var condition = "Tormenta de nieve"
    @AppStorage("impossible_weather_icon") private var iconName = "cloud.snow.fill"

    var body: some View {
        SecretConfigScreen(title: "El Clima Imposible") {
            Section("Condición forzada") {
                TextField("Ej. Tormenta de nieve", text: $condition)
                TextField("Nombre de SF Symbol", text: $iconName)
            }
            Section {
                Text("La pantalla de actuación pide primero el nombre captado y después la ciudad nombrada por el espectador, combinándolos en una interfaz que imita la app Clima con la condición configurada aquí.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
