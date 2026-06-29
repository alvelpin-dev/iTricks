import SwiftUI

/// Lista de efectos disponibles dentro de una categoría.
struct EffectListView: View {
    @StateObject private var viewModel: EffectListViewModel

    init(category: EffectCategory) {
        _viewModel = StateObject(wrappedValue: EffectListViewModel(category: category))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.sm) {
                if viewModel.effects.isEmpty {
                    EmptyCategoryView()
                        .padding(.top, Theme.Spacing.xl)
                } else {
                    ForEach(viewModel.effects) { effect in
                        NavigationLink(value: effect.info) {
                            EffectRow(info: effect.info)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .background(Color.appGroupedBackground)
        .navigationTitle(viewModel.category.title)
        .navigationDestination(for: EffectInfo.self) { info in
            EffectDetailView(info: info)
        }
    }
}

private struct EffectRow: View {
    let info: EffectInfo

    var body: some View {
        GlassCard {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: info.symbol)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(info.category.tint)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(info.name)
                        .font(Theme.Typography.headline)
                    Text(info.shortDescription)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    DifficultyBadge(level: info.difficulty)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

private struct EmptyCategoryView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("Próximamente nuevos efectos")
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
        }
    }
}
