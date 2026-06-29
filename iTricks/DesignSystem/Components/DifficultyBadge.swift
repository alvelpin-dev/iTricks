import SwiftUI

/// Indicador visual de dificultad mediante puntos rellenos, similar a los
/// indicadores de intensidad de Apple en Salud o Reloj.
struct DifficultyBadge: View {
    let level: DifficultyLevel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...DifficultyLevel.expert.rawValue, id: \.self) { index in
                Circle()
                    .fill(index <= level.rawValue ? Color.accentColor : Color.appSeparator)
                    .frame(width: 6, height: 6)
            }
            Text(level.title)
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Dificultad \(level.title)")
    }
}

/// Etiqueta compacta para el tiempo de preparación, con su SF Symbol asociado.
struct PreparationBadge: View {
    let time: PreparationTime

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: time.symbol)
            Text(time.rawValue)
        }
        .font(Theme.Typography.caption)
        .foregroundStyle(.secondary)
        .accessibilityElement(children: .combine)
    }
}
