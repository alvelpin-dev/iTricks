import SwiftUI

/// Pantalla de detalle de un efecto: descripción y los cuatro accesos
/// principales (Comenzar, Configuración, Instrucciones, Práctica).
struct EffectDetailView: View {
    @StateObject private var viewModel: EffectDetailViewModel
    @StateObject private var secretInput = SecretInputManager()
    @ObservedObject private var performanceMode = PerformanceModeManager.shared

    init(info: EffectInfo) {
        _viewModel = StateObject(wrappedValue: EffectDetailViewModel(info: info))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                header

                HStack(spacing: Theme.Spacing.sm) {
                    PreparationBadge(time: viewModel.info.preparationTime)
                    Spacer()
                    DifficultyBadge(level: viewModel.info.difficulty)
                }
                .padding(.horizontal, Theme.Spacing.md)

                actionButtons
            }
            .padding(.vertical, Theme.Spacing.md)
        }
        .background(Color.appGroupedBackground)
        .navigationTitle(viewModel.info.name)
        .navigationBarTitleDisplayMode(.inline)
        // Zona invisible: triple toque en la esquina superior derecha
        // revela la configuración secreta, solo conocida por el mago.
        .if(!performanceMode.isActive) { view in
            view.secretUnlockZone(secretInput)
        }
        .fullScreenCover(isPresented: $viewModel.showPerformance) {
            viewModel.performView()
        }
        .sheet(isPresented: $viewModel.showInstructions) {
            InstructionView(info: viewModel.info)
        }
        .sheet(isPresented: $viewModel.showPractice) {
            viewModel.practiceView()
        }
        .sheet(isPresented: $secretInput.isUnlocked) {
            viewModel.settingsView()
        }
    }

    private var header: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: viewModel.info.symbol)
                .font(.system(size: 44, weight: .medium))
                .foregroundStyle(viewModel.info.category.tint)
                .frame(width: 88, height: 88)
                .background(viewModel.info.category.tint.opacity(0.12), in: Circle())

            Text(viewModel.info.shortDescription)
                .font(Theme.Typography.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.lg)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: Theme.Spacing.sm) {
            PrimaryButton("Comenzar", symbol: "play.fill") {
                MagicEngine.beginSession()
                viewModel.showPerformance = true
            }

            HStack(spacing: Theme.Spacing.sm) {
                SecondaryButton("Instrucciones", symbol: "book") {
                    viewModel.showInstructions = true
                }
                SecondaryButton("Práctica", symbol: "figure.walk") {
                    viewModel.showPractice = true
                }
            }

            Button {
                viewModel.quickReset()
            } label: {
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reinicio rápido")
                }
                .font(Theme.Typography.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.top, Theme.Spacing.xs)

            if !performanceMode.isActive {
                Text("Configuración: toca 3 veces la esquina superior derecha")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, Theme.Spacing.xs)
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
    }
}
