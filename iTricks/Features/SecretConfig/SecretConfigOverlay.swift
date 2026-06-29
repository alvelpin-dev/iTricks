import SwiftUI

/// Contenedor estándar para la pantalla de configuración secreta de un
/// efecto. Cada efecto define sus propios controles dentro de `content`;
/// este wrapper solo aporta la cabecera y el estilo consistente.
struct SecretConfigScreen<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("Solo visible para el mago", systemImage: "lock.fill")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                }
                content
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}
