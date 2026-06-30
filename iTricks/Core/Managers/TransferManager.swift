import Foundation
import Combine

/// Gestiona la conexión WebSocket con el servidor Magic Transfer.
/// El mago actúa siempre como "sender"; la página web del espectador es el "receiver".
@MainActor
final class TransferManager: NSObject, ObservableObject {
    static let shared = TransferManager()

    // ── Estado público ────────────────────────────────────────────────────────
    enum ConnectionState: Equatable {
        case idle
        case connecting
        case connected         // sin receptores aún
        case receiverReady(count: Int)
        case transferring
        case transferComplete
        case offline           // sin servidor: modo simulación
        case error(String)
    }

    @Published private(set) var connectionState: ConnectionState = .idle
    @Published private(set) var sessionToken: String = ""
    @Published private(set) var receiverCount: Int = 0

    // ── Privado ───────────────────────────────────────────────────────────────
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pingTimer: AnyCancellable?
    private var serverURL: String = ""

    private override init() { super.init() }

    // MARK: – API pública

    /// Genera un token único, conecta al servidor y espera receptores.
    func start(serverURL: String) async {
        self.serverURL = serverURL
        sessionToken   = Self.generateToken()
        receiverCount  = 0

        guard !serverURL.isEmpty, let url = buildWebSocketURL(serverURL) else {
            connectionState = .offline
            return
        }

        connectionState = .connecting
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        self.urlSession = session
        webSocketTask  = session.webSocketTask(with: url)
        webSocketTask?.resume()

        await send(["type": "join_sender", "token": sessionToken])
        listen()
        startPing()
    }

    /// Envía la carta al servidor (y por ende a todos los receptores conectados).
    func transfer(card: String, cardName: String, rank: String, suitSymbol: String, suitColor: String) async {
        connectionState = .transferring
        await send([
            "type":       "transfer",
            "card":       card,
            "cardName":   cardName,
            "rank":       rank,
            "suitSymbol": suitSymbol,
            "suitColor":  suitColor,
        ])
    }

    /// Señala que la transferencia terminó visualmente.
    func markComplete() {
        connectionState = .transferComplete
    }

    /// URL completa que el espectador debe abrir.
    func spectatorURL(serverURL: String) -> String {
        let base = serverURL.hasSuffix("/") ? String(serverURL.dropLast()) : serverURL
        return "\(base)/?t=\(sessionToken)"
    }

    /// URL de fallback offline (carta embebida en el hash, sin servidor).
    func offlineURL(baseURL: String, card: String, revealDelay: Int = 3) -> String {
        let base = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        return "\(base)/#c=\(card)&d=\(revealDelay)"
    }

    func disconnect() {
        pingTimer?.cancel()
        pingTimer = nil
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        urlSession = nil
        connectionState = .idle
    }

    // MARK: – Privado

    private func buildWebSocketURL(_ serverURL: String) -> URL? {
        var urlStr = serverURL
        if urlStr.hasPrefix("http://")  { urlStr = "ws://"  + urlStr.dropFirst(7) }
        if urlStr.hasPrefix("https://") { urlStr = "wss://" + urlStr.dropFirst(8) }
        if !urlStr.hasPrefix("ws://") && !urlStr.hasPrefix("wss://") {
            urlStr = "ws://" + urlStr
        }
        return URL(string: urlStr)
    }

    private func send(_ dict: [String: String]) async {
        guard let task = webSocketTask,
              let data = try? JSONSerialization.data(withJSONObject: dict),
              let str  = String(data: data, encoding: .utf8) else { return }
        try? await task.send(.string(str))
    }

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                if case .string(let str) = message {
                    Task { @MainActor in self.handleMessage(str) }
                }
                self.listen()
            case .failure:
                Task { @MainActor in
                    if self.connectionState != .idle {
                        self.connectionState = .error("Conexión perdida")
                    }
                }
            }
        }
    }

    private func handleMessage(_ str: String) {
        guard let data = str.data(using: .utf8),
              let msg  = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = msg["type"] as? String else { return }

        switch type {
        case "joined":
            connectionState = .connected

        case "receiver_joined":
            let count = (msg["count"] as? Int) ?? 1
            receiverCount = count
            connectionState = .receiverReady(count: count)

        case "receiver_left":
            let count = (msg["count"] as? Int) ?? 0
            receiverCount = count
            if count == 0 { connectionState = .connected }
            else { connectionState = .receiverReady(count: count) }

        case "transfer_ack":
            connectionState = .transferComplete

        case "pong":
            break

        default:
            break
        }
    }

    private func startPing() {
        pingTimer = Timer.publish(every: 20, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { await self?.send(["type": "ping"]) }
            }
    }

    private static func generateToken() -> String {
        var bytes = [UInt8](repeating: 0, count: 5)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return bytes.map { String(format: "%02X", $0) }.joined()
    }
}

// MARK: – URLSessionWebSocketDelegate

extension TransferManager: URLSessionWebSocketDelegate {
    nonisolated func urlSession(_ session: URLSession,
                                webSocketTask: URLSessionWebSocketTask,
                                didOpenWithProtocol protocol: String?) {
        // handled by listen()
    }

    nonisolated func urlSession(_ session: URLSession,
                                webSocketTask: URLSessionWebSocketTask,
                                didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                                reason: Data?) {
        Task { @MainActor [weak self] in
            guard let self, self.connectionState != .idle else { return }
            self.connectionState = .error("Servidor desconectado")
        }
    }
}
