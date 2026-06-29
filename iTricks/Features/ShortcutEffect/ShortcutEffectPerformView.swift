import SwiftUI

/// Vista de actuación reutilizada por los efectos cuyo mecanismo real
/// ocurre fuera de iTricks (en un Atajo de Siri, en la app Cámara, en
/// Mensajes...). Como la app no puede ejecutar esa parte del truco por
/// ti, esta pantalla actúa como chuleta de guion de rápida consulta
/// durante la actuación: recuerda los pasos y las frases exactas sin que
/// tengas que salir a mirar las instrucciones completas.
struct ShortcutEffectPerformView: View {
    let info: EffectInfo
    var accent: Color = .accentColor

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    VStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: info.symbol)
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(accent)
                            .frame(width: 88, height: 88)
                            .background(accent.opacity(0.12), in: Circle())
                        Text("Este efecto se ejecuta a través de un Atajo de Siri configurado fuera de la app.")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)

                    cueCard(title: "Qué decir", symbol: "quote.bubble.fill", lines: info.instructions.script)
                    cueCard(title: "Pasos en escena", symbol: "list.number", lines: info.instructions.performance)
                }
                .padding(Theme.Spacing.md)
            }
            .background(Color.appBackground)
            .navigationTitle(info.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private func cueCard(title: String, symbol: String, lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: title, symbol: symbol)
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    Text(line)
                        .font(Theme.Typography.body)
                }
            }
            .padding(Theme.Spacing.md)
            .glassCardStyle()
        }
    }
}
