import SwiftUI

/// Contenedor raíz con la navegación por pestañas de la app.
struct RootView: View {
    @ObservedObject private var performanceMode = PerformanceModeManager.shared

    var body: some View {
        TabView {
            CategoryListView()
                .tabItem { Label("Efectos", systemImage: "wand.and.stars") }

            if !performanceMode.isActive {
                AppSettingsView()
                    .tabItem { Label("Ajustes", systemImage: "gearshape") }
            }
        }
        .tint(.accentColor)
        .animation(Theme.AnimationCurve.gentle, value: performanceMode.isActive)
    }
}
