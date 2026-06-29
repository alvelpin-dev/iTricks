import SwiftUI

/// Botón de acción principal ("Comenzar"). Estilo sólido, minimalista,
/// con feedback háptico integrado en cada pulsación.
struct PrimaryButton: View {
    let title: String
    let symbol: String?
    var tint: Color = .accentColor
    let action: () -> Void

    init(_ title: String, symbol: String? = nil, tint: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.symbol = symbol
        self.tint = tint
        self.action = action
    }

    var body: some View {
        Button {
            HapticManager.shared.impact(.medium)
            action()
        } label: {
            HStack(spacing: Theme.Spacing.xs) {
                if let symbol {
                    Image(systemName: symbol)
                }
                Text(title)
            }
            .font(Theme.Typography.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background(tint, in: RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous))
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityAddTraits(.isButton)
    }
}

/// Botón secundario de contorno, usado para acciones como "Configuración"
/// o "Instrucciones" que acompañan a la acción principal.
struct SecondaryButton: View {
    let title: String
    let symbol: String?
    let action: () -> Void

    init(_ title: String, symbol: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.symbol = symbol
        self.action = action
    }

    var body: some View {
        Button {
            HapticManager.shared.impact(.light)
            action()
        } label: {
            HStack(spacing: Theme.Spacing.xs) {
                if let symbol {
                    Image(systemName: symbol)
                }
                Text(title)
            }
            .font(Theme.Typography.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.primary)
            .background(Color.appSecondaryBackground, in: RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

/// Estilo de botón compartido que aplica una ligera reducción de escala
/// al pulsar, imitando el feedback táctil de las apps nativas de Apple.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(Theme.AnimationCurve.snappy, value: configuration.isPressed)
    }
}
