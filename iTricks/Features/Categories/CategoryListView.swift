import SwiftUI

/// Pantalla raíz de la app: lista de categorías de efectos.
struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel()
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.sm) {
                    ForEach(viewModel.categories) { category in
                        NavigationLink(value: category) {
                            CategoryRow(
                                category: category,
                                effectCount: viewModel.effectCount(for: category)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Theme.Spacing.md)
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("iTricks")
            .navigationDestination(for: EffectCategory.self) { category in
                EffectListView(category: category)
            }
        }
    }
}

private struct CategoryRow: View {
    let category: EffectCategory
    let effectCount: Int

    var body: some View {
        GlassCard {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: category.symbol)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(category.tint)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.title)
                        .font(Theme.Typography.headline)
                        .foregroundStyle(.primary)
                    Text(category.subtitle)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(effectCount)")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("\(effectCount) efectos disponibles")
    }
}

#Preview {
    CategoryListView()
}
