import SwiftUI

extension View {
    /// Aplica una tarjeta de fondo translúcido al estilo "glass" de iOS,
    /// con esquinas redondeadas consistentes en toda la app.
    func glassCardStyle(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    /// Condicionalmente aplica una transformación a la vista. Útil para
    /// alternar modificadores sin duplicar la jerarquía de vistas.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
