import SwiftUI

/// Ajustes generales de la app, visibles públicamente (no son el modo
/// secreto de cada efecto). Incluye el interruptor de Modo Actuación.
struct AppSettingsView: View {
    @ObservedObject private var performanceMode = PerformanceModeManager.shared

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: Binding(
                        get: { performanceMode.isActive },
                        set: { _ in performanceMode.toggle() }
                    )) {
                        Label("Modo Actuación", systemImage: "theatermasks.fill")
                    }
                } footer: {
                    Text("Oculta todos los controles de configuración, ayudas y accesos secretos para que la app parezca completamente normal delante del público.")
                }

                Section {
                    Label("SwiftUI · iOS 15+", systemImage: "swift")
                    Label("Diseñado para magos profesionales", systemImage: "sparkles")
                } header: {
                    Text("Acerca de iTricks")
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}
