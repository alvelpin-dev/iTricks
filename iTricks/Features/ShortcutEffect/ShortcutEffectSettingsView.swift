import SwiftUI

/// Configuración secreta reutilizada por todos los efectos basados en
/// Atajos de Siri: siempre muestra la guía de construcción del atajo
/// necesario (`ShortcutGuideSection`), y opcionalmente controles
/// adicionales específicos del efecto (textos a personalizar, etc.).
struct ShortcutEffectSettingsView<Extra: View>: View {
    let title: String
    let blueprint: ShortcutBlueprint
    @ViewBuilder var extraSettings: Extra

    init(title: String, blueprint: ShortcutBlueprint, @ViewBuilder extraSettings: () -> Extra) {
        self.title = title
        self.blueprint = blueprint
        self.extraSettings = extraSettings()
    }

    var body: some View {
        SecretConfigScreen(title: title) {
            extraSettings
            ShortcutGuideSection(blueprint: blueprint)
        }
    }
}

extension ShortcutEffectSettingsView where Extra == EmptyView {
    init(title: String, blueprint: ShortcutBlueprint) {
        self.init(title: title, blueprint: blueprint) { EmptyView() }
    }
}
