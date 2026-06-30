import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Effect descriptor
// ─────────────────────────────────────────────────────────────────────────────

enum MagicTransferEffect: EffectModule {
    static let info = EffectInfo(
        id: "magic_transfer",
        name: "Magic Transfer",
        category: .technology,
        shortDescription: "Una carta abandona físicamente tu iPhone y aparece en el teléfono Android del espectador, sin que instale nada.",
        difficulty: .expert,
        preparationTime: .minutes,
        symbol: "arrow.up.forward.app.fill",
        instructions: EffectInstructions(
            whatItDoes: "Una carta es elegida por el espectador mediante un forzaje psicológico. La abres en tu iPhone y, ante sus ojos, se desintegra en partículas que salen hacia los bordes de la pantalla. En ese mismo instante, en el teléfono Android del espectador —que ya tenía una página web abierta— aparece la misma carta formada por partículas de luz.",
            preparation: [
                "Configura en los ajustes secretos la URL de tu servidor Magic Transfer (o usa la URL pública que hayas desplegado).",
                "Elige qué carta vas a forzar. La configuración secreta la guarda.",
                "Antes de la actuación, abre el efecto en modo actuación: te mostrará un código QR. Pide al espectador que lo escanee con su teléfono Android y que deje la página abierta.",
                "Cuando el ícono 'Receptor conectado' aparezca en tu pantalla, estás listo para actuar.",
                "El servidor puede ser cualquier VPS con Node.js. Ejecuta: npm install && node server.js"
            ],
            performance: [
                "Fuerza la carta usando la técnica de equívoco o cualquier método de tu repertorio.",
                "Abre este efecto y muestra el código QR al espectador para que lo escanee.",
                "Una vez veas 'Receptor conectado' en tu pantalla, realiza el forzaje o revela la selección.",
                "Toca la zona oculta en la esquina inferior derecha de tu pantalla para iniciar la transferencia.",
                "Tu pantalla muestra la carta desvaneciéndose en partículas. En el teléfono del espectador, las partículas la reconstruyen."
            ],
            script: [
                "\"Vamos a hacer algo que va más allá de cualquier truco de cartas.\"",
                "\"Quiero que abras este enlace en tu teléfono. Sin instalar nada.\"",
                "\"Elige una carta. La que tú quieras.\"",
                "\"Mira mi pantalla. Y mira la tuya al mismo tiempo.\""
            ],
            recoveryTips: [
                "Si no hay conexión a internet, el modo offline activa una revelación con retardo automático basada en la URL: la carta ya viaja codificada en el enlace.",
                "Si el espectador tarda en escanear el QR, puedes dejar el iPhone en la mesa con el QR visible mientras charlas."
            ],
            performanceTips: [
                "La magia real está en el forzaje de carta, no en la tecnología. Domina primero el equívoco.",
                "Practica tocar la zona oculta sin mirar la pantalla, para que parezca que el teléfono actúa solo.",
                "El momento de mayor impacto es cuando la carta aparece en el teléfono del espectador: orienta toda la atención hacia su pantalla en ese instante."
            ],
            variations: [
                "Usa el modo offline si actúas en lugares sin WiFi: prepara la URL con la carta codificada de antemano.",
                "Combínalo con Predicción sellada: el sobre contiene la misma carta que 'viaja' digitalmente."
            ],
            commonMistakes: [
                "Tocar la zona de transferencia antes de que el receptor esté conectado.",
                "No tener el servidor corriendo o con la URL mal configurada. Verifica siempre antes de actuar."
            ],
            recommendedDuration: "3-5 minutos"
        ),
        practiceSteps: [
            PracticeStep(
                performerAction: "Abre el efecto y escanea el QR con tu propio segundo teléfono.",
                spectatorAction: "Observa la pantalla web mientras espera la carta.",
                simulationNote: "Practica el flujo completo solo antes de actuar frente al público."
            ),
            PracticeStep(
                performerAction: "Toca la zona oculta para iniciar la transferencia.",
                spectatorAction: "Ve la carta formarse en partículas en su pantalla.",
                simulationNote: "La animación en la web dura ~5 segundos desde que se recibe la señal."
            )
        ]
    )

    static func performView() -> AnyView { AnyView(MagicTransferPerformView()) }
    static func settingsView() -> AnyView { AnyView(MagicTransferSettingsView()) }
    static func practiceView() -> AnyView { AnyView(PracticeView(info: info)) }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Particle types
// ─────────────────────────────────────────────────────────────────────────────

private struct MagicParticle {
    var x0: CGFloat      // origin x (normalized 0-1 in card rect)
    var y0: CGFloat      // origin y
    var vx: CGFloat      // velocity x (pts/s)
    var vy: CGFloat      // velocity y
    var lifetime: CGFloat // seconds
    var delay: CGFloat    // start delay seconds
    var size: CGFloat
    var red: Bool        // determines color
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Particle system (time-based, no mutation in render)
// ─────────────────────────────────────────────────────────────────────────────

private final class CardParticleSystem {
    private(set) var particles: [MagicParticle] = []
    private(set) var startDate: Date = .distantFuture
    let duration: CGFloat = 2.2   // total animation seconds

    func explode(cardRect: CGRect, isRed: Bool) {
        startDate = Date()
        particles = (0..<500).map { _ in
            let ox = CGFloat.random(in: 0...1)
            let oy = CGFloat.random(in: 0...1)
            let cx = cardRect.midX
            let cy = cardRect.midY
            let px = cardRect.minX + ox * cardRect.width
            let py = cardRect.minY + oy * cardRect.height

            // velocity: outward from card center + spread
            let dx = px - cx
            let dy = py - cy
            let mag = sqrt(dx*dx + dy*dy) + 0.01
            let speed = CGFloat.random(in: 120...420)
            let angle = atan2(dy, dx) + CGFloat.random(in: -0.6...0.6)

            return MagicParticle(
                x0: px, y0: py,
                vx: cos(angle) * speed,
                vy: sin(angle) * speed,
                lifetime: CGFloat.random(in: 1.2...duration),
                delay: CGFloat.random(in: 0...0.35),
                size: CGFloat.random(in: 2...5),
                red: isRed
            )
        }
    }

    /// Position + opacity for a particle at elapsed time t.
    func state(of p: MagicParticle, at t: CGFloat) -> (x: CGFloat, y: CGFloat, opacity: CGFloat, scale: CGFloat) {
        let live = t - p.delay
        guard live > 0 else { return (p.x0, p.y0, 0, 0) }
        let frac    = min(live / p.lifetime, 1)
        let gravity : CGFloat = 40
        let x       = p.x0 + p.vx * live
        let y       = p.y0 + p.vy * live + 0.5 * gravity * live * live
        let opacity = pow(1 - frac, 1.4)
        let scale   = 1 - frac * 0.6
        return (x, y, opacity, scale)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Performance view
// ─────────────────────────────────────────────────────────────────────────────

private struct MagicTransferPerformView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("magic_transfer_server_url") private var serverURL = ""
    @AppStorage("magic_transfer_forced_card") private var forcedCard = "AS"

    @StateObject private var transfer = TransferManager.shared
    @State private var stage: Stage = .setup
    @State private var particleSystem = CardParticleSystem()
    @State private var cardGeometry: CGRect = .zero
    @State private var showCard = true

    private enum Stage { case setup, ready, transferring, complete }

    // Derived card info from the code (e.g. "AH")
    private var rank: String        { String(forcedCard.dropLast()) }
    private var suitChar: Character { forcedCard.last ?? "S" }
    private var suitSymbol: String  { ["H":"♥","D":"♦","C":"♣","S":"♠"][String(suitChar)] ?? "?" }
    private var suitColor: Color    { ["H","D"].contains(String(suitChar)) ? .red : Color(.label) }
    private var isRed: Bool         { ["H","D"].contains(String(suitChar)) }
    private var cardName: String {
        let r = ["A":"As","J":"Jota","Q":"Reina","K":"Rey"][rank] ?? rank
        let s = ["H":"Corazones","D":"Diamantes","C":"Tréboles","S":"Picas"][String(suitChar)] ?? String(suitChar)
        return "\(r) de \(s)"
    }
    private var spectatorURL: String { transfer.spectatorURL(serverURL: serverURL) }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch stage {
            case .setup:    setupView
            case .ready:    readyView
            case .transferring: transferView
            case .complete: completeView
            }
        }
        .statusBarHidden(true)
        .onAppear {
            Task { await transfer.start(serverURL: serverURL) }
        }
        .onChange(of: transfer.connectionState) { state in
            switch state {
            case .receiverReady: if stage == .setup { withAnimation { stage = .ready } }
            default: break
            }
        }
        .onDisappear {
            transfer.disconnect()
        }
    }

    // ── Stage 1: setup / QR ──────────────────────────────────────────────────

    private var setupView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Acerca el teléfono del espectador")
                .font(.system(size: 22, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let qr = generateQR(spectatorURL) {
                Image(uiImage: qr)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .white.opacity(0.15), radius: 20)
            }

            // Short display token
            VStack(spacing: 6) {
                Text("CÓDIGO")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.4))
                    .tracking(4)
                Text(transfer.sessionToken)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .tracking(6)
            }

            connectionIndicator

            Spacer()
            closeButton
        }
        .padding(.bottom, 32)
    }

    // ── Stage 2: ready ───────────────────────────────────────────────────────

    private var readyView: some View {
        ZStack {
            // Card display
            cardView
                .opacity(showCard ? 1 : 0)
                .overlay(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            cardGeometry = geo.frame(in: .global)
                        }
                    }
                )

            // Receiver badge
            VStack {
                HStack {
                    Spacer()
                    Label("\(transfer.receiverCount) receptor", systemImage: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(.green.opacity(0.15), in: Capsule())
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.trailing, 20)

            // Hidden trigger — bottom-right zone
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Color.clear
                        .frame(width: 100, height: 100)
                        .contentShape(Rectangle())
                        .onTapGesture { beginTransfer() }
                        .accessibilityHidden(true)
                }
            }

            closeButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 32).padding(.leading, 24)
        }
    }

    // ── Stage 3: transferring ────────────────────────────────────────────────

    private var transferView: some View {
        TimelineView(.animation) { timeline in
            let t = CGFloat(timeline.date.timeIntervalSince(particleSystem.startDate))
            Canvas { ctx, size in
                for p in particleSystem.particles {
                    let s = particleSystem.state(of: p, at: t)
                    guard s.opacity > 0.01 else { continue }
                    ctx.opacity = s.opacity
                    let r = p.size * s.scale
                    let rect = CGRect(x: s.x - r, y: s.y - r, width: r*2, height: r*2)
                    let color = p.red ? Color.red : Color.white
                    ctx.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.9)))
                    // glow halo
                    let halo = CGRect(x: s.x - r*2.5, y: s.y - r*2.5, width: r*5, height: r*5)
                    ctx.fill(Path(ellipseIn: halo), with: .color(color.opacity(s.opacity * 0.15)))
                }
            }
        }
        .ignoresSafeArea()
        .background(Color.black)
    }

    // ── Stage 4: complete ────────────────────────────────────────────────────

    private var completeView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.green)
                .transition(.scale.combined(with: .opacity))
            Text("Transferencia completada.")
                .font(.system(size: 22, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
            Text("Esperando receptor...")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.4))
            Spacer()
            closeButton
        }
        .padding(.bottom, 40)
    }

    // ── Sub-views ────────────────────────────────────────────────────────────

    private var cardView: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .white.opacity(0.12), radius: 30)

                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(rank)
                                .font(.system(size: 40, weight: .bold, design: .serif))
                            Text(suitSymbol)
                                .font(.system(size: 32))
                        }
                        .foregroundStyle(suitColor)
                        Spacer()
                    }
                    .padding(20)

                    Spacer()

                    Text(suitSymbol)
                        .font(.system(size: 140))
                        .foregroundStyle(suitColor)

                    Spacer()

                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(suitSymbol)
                                .font(.system(size: 32))
                            Text(rank)
                                .font(.system(size: 40, weight: .bold, design: .serif))
                        }
                        .foregroundStyle(suitColor)
                        .rotationEffect(.degrees(180))
                    }
                    .padding(20)
                }
            }
            .frame(width: 220, height: 308)
            Spacer()
        }
    }

    private var connectionIndicator: some View {
        HStack(spacing: 8) {
            switch transfer.connectionState {
            case .connecting:
                ProgressView().tint(.white).scaleEffect(0.7)
                Text("Conectando...").font(.system(size: 13)).foregroundStyle(.white.opacity(0.5))
            case .connected:
                Circle().fill(.yellow).frame(width: 8, height: 8)
                Text("Esperando que el espectador abra el enlace").font(.system(size: 13)).foregroundStyle(.white.opacity(0.6))
            case .receiverReady(let n):
                Circle().fill(.green).frame(width: 8, height: 8)
                Text("Receptor conectado (\(n))").font(.system(size: 13)).foregroundStyle(.green)
            case .offline:
                Circle().fill(.orange).frame(width: 8, height: 8)
                Text("Modo sin servidor").font(.system(size: 13)).foregroundStyle(.orange)
            case .error(let msg):
                Circle().fill(.red).frame(width: 8, height: 8)
                Text(msg).font(.system(size: 13)).foregroundStyle(.red)
            default:
                EmptyView()
            }
        }
        .padding(.top, 8)
    }

    private var closeButton: some View {
        Button("Cerrar") { dismiss() }
            .font(.system(size: 14))
            .foregroundStyle(.white.opacity(0.45))
    }

    // ── Transfer logic ───────────────────────────────────────────────────────

    private func beginTransfer() {
        guard stage == .ready else { return }

        // Haptic ramp
        HapticManager.shared.impact(.light)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)  { HapticManager.shared.impact(.medium) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { HapticManager.shared.impact(.heavy) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) { HapticManager.shared.success() }

        // Capture card rect and start particles
        particleSystem.explode(cardRect: cardGeometry, isRed: isRed)
        withAnimation(.easeIn(duration: 0.25)) {
            showCard = false
            stage = .transferring
        }

        // Send WebSocket message (timed to match iOS animation ~0.4s in)
        Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            await transfer.transfer(
                card: forcedCard,
                cardName: cardName,
                rank: rank,
                suitSymbol: suitSymbol,
                suitColor: isRed ? "red" : "black"
            )
        }

        // Complete stage after particle animation finishes
        DispatchQueue.main.asyncAfter(deadline: .now() + particleSystem.duration + 0.4) {
            transfer.markComplete()
            withAnimation(.easeInOut(duration: 0.6)) { stage = .complete }
        }
    }

    // ── QR generation ────────────────────────────────────────────────────────

    private func generateQR(_ string: String) -> UIImage? {
        guard let data = string.data(using: .isoLatin1),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 12, y: 12))
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Settings view
// ─────────────────────────────────────────────────────────────────────────────

private struct MagicTransferSettingsView: View {
    @AppStorage("magic_transfer_server_url") private var serverURL = ""
    @AppStorage("magic_transfer_forced_card") private var forcedCard = "AS"

    private var offlinePreviewURL: String {
        let base = serverURL.isEmpty ? "https://tu-servidor.com" : serverURL
        let tr = TransferManager.shared
        return tr.offlineURL(baseURL: base, card: forcedCard, revealDelay: 3)
    }

    var body: some View {
        SecretConfigScreen(title: "Magic Transfer") {
            Section("Servidor") {
                TextField("https://tu-servidor.com", text: $serverURL)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                Text("Node.js con ws instalado. Arranca con: npm install && node server.js")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Carta forzada") {
                Picker("Carta", selection: $forcedCard) {
                    ForEach(PredictionEngine.standardDeck, id: \.self) { card in
                        Text(cardLabel(card)).tag(card)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
            }

            Section("Modo offline (sin servidor)") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Si no tienes servidor, usa esta URL para la carta seleccionada. La web espera 3 s y luego revela la carta automáticamente.")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(.secondary)
                    Text(offlinePreviewURL)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .textSelection(.enabled)
                }
            }

            Section {
                Text("El espectador escanea el QR en la pantalla de actuación y deja la página abierta. Cuando el mago toca la zona oculta (esquina inferior derecha), la carta se desintegra en su iPhone y reaparece en el teléfono del espectador vía WebSocket.")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Cómo funciona")
            }
        }
    }

    private func cardLabel(_ code: String) -> String {
        let suit = String(code.last ?? "S")
        let rank = String(code.dropLast())
        let r = ["A":"As","J":"Jota","Q":"Reina","K":"Rey"][rank] ?? rank
        let s = ["H":"♥ Corazones","D":"♦ Diamantes","C":"♣ Tréboles","S":"♠ Picas"][suit] ?? suit
        return "\(r) de \(s)"
    }
}
