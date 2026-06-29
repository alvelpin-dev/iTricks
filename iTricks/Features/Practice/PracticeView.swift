import SwiftUI

/// Modo práctica genérico: guía al mago paso a paso mostrando qué debe
/// hacer él, qué experimenta el espectador y cómo se simula el resultado.
struct PracticeView: View {
    @StateObject private var viewModel: PracticeViewModel
    @Environment(\.dismiss) private var dismiss
    @Namespace private var stepTransition

    init(info: EffectInfo) {
        _viewModel = StateObject(wrappedValue: PracticeViewModel(info: info))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.lg) {
                ProgressView(value: viewModel.progress)
                    .tint(.accentColor)
                    .padding(.horizontal, Theme.Spacing.md)

                if let step = viewModel.currentStep {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                            stepCard(
                                title: "Tú (mago)",
                                symbol: "person.fill",
                                text: step.performerAction,
                                tint: .accentColor
                            )
                            stepCard(
                                title: "Espectador",
                                symbol: "person",
                                text: step.spectatorAction,
                                tint: .secondary
                            )
                            stepCard(
                                title: "Simulación",
                                symbol: "wand.and.stars",
                                text: step.simulationNote,
                                tint: .purple
                            )
                        }
                        .padding(Theme.Spacing.md)
                    }
                    .id(viewModel.currentIndex)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                } else {
                    Text("Este efecto aún no tiene pasos de práctica.")
                        .foregroundStyle(.secondary)
                        .padding()
                }

                navigationButtons
            }
            .animation(Theme.AnimationCurve.standard, value: viewModel.currentIndex)
            .navigationTitle("Práctica · \(viewModel.info.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .background(Color.appGroupedBackground)
        }
    }

    private func stepCard(title: String, symbol: String, text: String, tint: Color) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Label(title, systemImage: symbol)
                    .font(Theme.Typography.headline)
                    .foregroundStyle(tint)
                Text(text)
                    .font(Theme.Typography.body)
            }
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: Theme.Spacing.sm) {
            SecondaryButton("Anterior", symbol: "chevron.left") {
                viewModel.previous()
            }
            .disabled(viewModel.currentIndex == 0)
            .opacity(viewModel.currentIndex == 0 ? 0.4 : 1)

            if viewModel.isLastStep {
                PrimaryButton("Reiniciar", symbol: "arrow.counterclockwise") {
                    viewModel.restart()
                }
            } else {
                PrimaryButton("Siguiente", symbol: "chevron.right") {
                    viewModel.next()
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
    }
}
