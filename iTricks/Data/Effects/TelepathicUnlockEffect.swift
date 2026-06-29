import SwiftUI

/// "El Desbloqueo Telepático" — Paranormal.
///
/// Método real (integrado en la app): una réplica de la pantalla de
/// bloqueo, dentro de iTricks, que se "desbloquea" con una animación de
/// deslizamiento cuando el mago toca discretamente una zona invisible.
/// No existe una forma real de que un espectador desbloquee el sistema
/// con la mente: el efecto vive honestamente en la actuación y el
/// timing del gesto oculto, no en ninguna biometría real.
enum TelepathicUnlockEffect: EffectModule {
    static let info = EffectInfo(
        id: "telepathic_unlock",
        name: "El Desbloqueo Telepático",
        category: .paranormal,
        shortDescription: "El espectador mira la pantalla bloqueada y se concentra en la palabra 'Abrir'. Sin tocarlo nadie, el teléfono se desbloquea.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "lock.open.fill",
        instructions: EffectInstructions(
            whatItDoes: "Le das tu iPhone bloqueado al espectador. Le pides que mire la pantalla y se concentre en la palabra \"Abrir\". Sin que uses Face ID de forma visible y sin tocar el dispositivo, el teléfono se desbloquea solo ante sus ojos.",
            preparation: [
                "Practica el toque oculto en la esquina superior de la pantalla hasta poder activarlo sin que se note ningún gesto especial.",
                "Ensaya la temporización: dejar pasar 2-3 segundos de \"concentración\" antes de activar el desbloqueo, para que no parezca instantáneo."
            ],
            performance: [
                "Abre el efecto, que muestra una réplica de la pantalla de bloqueo.",
                "Pide al espectador que mire fijamente la pantalla y se concentre en la palabra \"Abrir\".",
                "Tras unos segundos, toca discretamente la esquina superior de la pantalla.",
                "Deja que la animación de desbloqueo se reproduzca de forma natural ante los ojos del espectador, atribuyendo el resultado a su concentración."
            ],
            script: [
                "\"Mira fijamente la pantalla y concéntrate en la palabra Abrir.\"",
                "\"No voy a tocarlo, ni siquiera lo estoy mirando yo.\"",
                "\"¿Ves? Tu mente lo ha desbloqueado.\""
            ],
            recoveryTips: [
                "Si tocas la zona oculta por error demasiado pronto, deja que la animación termine con normalidad: nadie nota la diferencia.",
                "Ten una salida narrativa (\"necesita más concentración\") para poder reintentarlo con naturalidad si quieres alargar el momento."
            ],
            performanceTips: [
                "Este efecto depende casi enteramente del timing: deja pasar suficiente tiempo de \"concentración\" antes de tocar la zona oculta.",
                "Nunca expliques el mecanismo; deja que el público asuma lo que quiera sobre el método."
            ],
            variations: [
                "Combínalo con una frase de presentación sobre energía mental para reforzar la narrativa paranormal.",
                "Alarga la espera antes de tocar la zona oculta para rutinas donde quieras generar más tensión."
            ],
            commonMistakes: [
                "Tocar la zona oculta demasiado rápido, sin dar sensación de \"concentración\" previa.",
                "Mirar directamente la pantalla en el momento del desbloqueo, en vez de mantener la mirada en el espectador."
            ],
            recommendedDuration: "1-2 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Abre la réplica de pantalla de bloqueo y pide concentración en la palabra 'Abrir'.",
                spectatorAction: "Mira fijamente la pantalla bloqueada, concentrándose.",
                simulationNote: "Es una vista de iTricks idéntica a una pantalla de bloqueo, no el sistema real."
            ),
            PracticeStep(
                performerAction: "Tras unos segundos, toca discretamente la zona oculta para iniciar la animación de desbloqueo.",
                spectatorAction: "Ve la pantalla 'desbloquearse' ante sus ojos.",
                simulationNote: "La animación de deslizamiento simula visualmente un desbloqueo real."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(TelepathicUnlockPerformView()) }
    static func settingsView() -> AnyView { AnyView(TelepathicUnlockSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

private struct TelepathicUnlockPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var unlocked = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.md) {
                Spacer()
                Image(systemName: unlocked ? "lock.open.fill" : "lock.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                Text(unlocked ? "Desbloqueado" : "Abrir")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                Button("Cerrar") { dismiss() }
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, Theme.Spacing.md)
            }
            .offset(y: unlocked ? -700 : 0)
            .opacity(unlocked ? 0 : 1)
        }
        .overlay(alignment: .topTrailing) {
            Color.clear
                .frame(width: 70, height: 70)
                .contentShape(Rectangle())
                .onTapGesture { triggerUnlock() }
                .accessibilityHidden(true)
        }
    }

    private func triggerUnlock() {
        guard !unlocked else { return }
        HapticManager.shared.impact(.medium)
        withAnimation(.easeIn(duration: 0.6)) { unlocked = true }
        MagicEngine.performReveal()
    }
}

private struct TelepathicUnlockSettingsView: View {
    var body: some View {
        SecretConfigScreen(title: "El Desbloqueo Telepático") {
            Section {
                Text("Toca la esquina superior derecha de la pantalla, tras unos segundos de 'concentración', para iniciar la animación de desbloqueo. No hay ninguna biometría real implicada: es una ilusión de actuación y temporización.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }
}
