import SwiftUI

/// Sección reutilizable que aparece dentro de la configuración secreta de
/// cualquier efecto basado en Atajos de Siri, guiando al mago para
/// construir el atajo real paso a paso, con un acceso directo a la app
/// Atajos para empezar a crearlo de inmediato.
struct ShortcutGuideSection: View {
    let blueprint: ShortcutBlueprint

    var body: some View {
        Section {
            Label(blueprint.shortcutName, systemImage: "bolt.square.fill")
                .font(Theme.Typography.headline)
            Label(blueprint.trigger, systemImage: "hand.tap.fill")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        } header: {
            Text("Atajo necesario")
        }

        Section("Acciones a añadir, en este orden") {
            ForEach(Array(blueprint.actions.enumerated()), id: \.offset) { index, action in
                HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.sm) {
                    Text("\(index + 1)")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.accentColor, in: Circle())
                    Text(action)
                        .font(Theme.Typography.body)
                }
            }
        }

        if let caveat = blueprint.caveat {
            Section("Importante") {
                Text(caveat)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }
        }

        Section {
            Link(destination: URL(string: "shortcuts://create-shortcut")!) {
                Label("Abrir app Atajos para crearlo", systemImage: "arrow.up.forward.app.fill")
            }
        } footer: {
            Text("iTricks no puede crear el atajo automáticamente: Apple no permite que apps de terceros generen Atajos de Siri por programación. Este es el motivo por el que debes construirlo tú mismo siguiendo estos pasos, una sola vez.")
        }
    }
}
