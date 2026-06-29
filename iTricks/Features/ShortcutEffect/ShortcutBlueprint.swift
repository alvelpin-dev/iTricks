import Foundation

/// Describe el Atajo de Siri (app Atajos de Apple) real que el mago debe
/// construir fuera de iTricks para que un efecto basado en Atajos
/// funcione. iTricks no puede crear atajos por sí misma (Apple no expone
/// esa API a apps de terceros), así que en su lugar guía al mago paso a
/// paso para construirlo él mismo, con las acciones exactas a usar.
struct ShortcutBlueprint {
    /// Nombre sugerido para el atajo dentro de la app Atajos.
    let shortcutName: String
    /// Cómo se dispara el atajo: frase de Siri, Toque posterior, automatización…
    let trigger: String
    /// Acciones de Atajos a añadir, en el orden exacto.
    let actions: [String]
    /// Advertencia o matiz importante sobre limitaciones reales de iOS.
    let caveat: String?

    init(shortcutName: String, trigger: String, actions: [String], caveat: String? = nil) {
        self.shortcutName = shortcutName
        self.trigger = trigger
        self.actions = actions
        self.caveat = caveat
    }
}
