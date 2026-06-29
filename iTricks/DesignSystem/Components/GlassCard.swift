import SwiftUI

/// Contenedor de tarjeta con efecto "glass" reutilizado por listas y
/// pantallas de detalle. Mantiene padding y radio de esquina consistentes.
struct GlassCard<Content: View>: View {
    @ViewBuilder var content: Content
    var padding: CGFloat = Theme.Spacing.md

    var body: some View {
        content
            .padding(padding)
            .glassCardStyle(cornerRadius: Theme.Radius.medium)
    }
}

/// Cabecera de sección reutilizable, con tipografía y espaciado consistentes
/// para títulos como "Instrucciones", "Variaciones", "Errores comunes".
struct SectionHeader: View {
    let title: String
    var symbol: String?

    var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            if let symbol {
                Image(systemName: symbol)
                    .foregroundStyle(.secondary)
            }
            Text(title)
                .font(Theme.Typography.title)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}
