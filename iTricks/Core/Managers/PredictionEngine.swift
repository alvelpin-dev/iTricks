import Foundation

/// Centraliza la lógica de "forzar" o predecir resultados que parecen
/// libres para el espectador pero están condicionados por el efecto.
/// Mantener esta lógica aislada evita duplicarla en cada vista de efecto.
struct PredictionEngine {
    /// Lista clásica de 52 cartas en notación corta (ej. "AS", "10H", "KD").
    static let standardDeck: [String] = {
        let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        let suits = ["S", "H", "D", "C"]
        return suits.flatMap { suit in ranks.map { rank in "\(rank)\(suit)" } }
    }()

    /// Carta forzada por defecto en los efectos que usan "carta forzada clásica".
    /// Configurable desde la pantalla de ajustes ocultos de cada efecto.
    static let defaultForcedCard = "AS"

    /// Genera un número "aleatorio" dentro de un rango, con la posibilidad
    /// de forzar un resultado concreto cuando el efecto lo requiere.
    static func number(in range: ClosedRange<Int>, forcing forcedValue: Int? = nil) -> Int {
        if let forcedValue, range.contains(forcedValue) {
            return forcedValue
        }
        return Int.random(in: range)
    }

    /// Aplica el método matemático del "1089" / suma forzada usado en
    /// efectos de matemágia: cualquier número de 3 cifras con dígitos
    /// distintos, restado de su inverso y sumado al resultado invertido,
    /// siempre da 1089.
    static func forcedDigitSum() -> Int { 1089 }

    /// Deletrea una palabra letra a letra, útil para animar revelaciones
    /// de "ESTA ES TU CARTA" o nombres deletreados en pantalla.
    static func letters(of text: String) -> [Character] {
        Array(text.uppercased())
    }
}
