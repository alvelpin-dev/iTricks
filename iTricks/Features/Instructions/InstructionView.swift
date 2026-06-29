import SwiftUI

/// Pantalla de instrucciones completa de un efecto. Genérica: cualquier
/// efecto nuevo obtiene esta pantalla gratis a partir de su `EffectInstructions`.
struct InstructionView: View {
    let info: EffectInfo
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    metaRow

                    section("Qué hace el efecto", symbol: "eye", text: info.instructions.whatItDoes)

                    listSection("Preparación", symbol: "checklist", items: info.instructions.preparation)

                    listSection("Cómo realizarlo", symbol: "hand.point.up.left", items: info.instructions.performance)

                    listSection("Qué decir", symbol: "quote.bubble", items: info.instructions.script)

                    listSection("Si algo sale mal", symbol: "exclamationmark.triangle", items: info.instructions.recoveryTips)

                    listSection("Consejos de actuación", symbol: "star", items: info.instructions.performanceTips)

                    listSection("Variaciones", symbol: "arrow.triangle.branch", items: info.instructions.variations)

                    listSection("Errores comunes", symbol: "xmark.octagon", items: info.instructions.commonMistakes)
                }
                .padding(Theme.Spacing.md)
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("Instrucciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var metaRow: some View {
        HStack(spacing: Theme.Spacing.md) {
            DifficultyBadge(level: info.difficulty)
            Spacer()
            Label(info.instructions.recommendedDuration, systemImage: "clock")
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func section(_ title: String, symbol: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            SectionHeader(title: title, symbol: symbol)
            Text(text)
                .font(Theme.Typography.body)
                .foregroundStyle(.primary)
        }
    }

    private func listSection(_ title: String, symbol: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: title, symbol: symbol)
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.xs) {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 5, height: 5)
                            .padding(.top, 7)
                        Text(item)
                            .font(Theme.Typography.body)
                    }
                }
            }
        }
    }
}
