import SwiftUI

/// Nivel de dificultad técnica y de actuación de un efecto.
enum DifficultyLevel: Int, CaseIterable, Codable, Comparable {
    case beginner = 1
    case intermediate = 2
    case advanced = 3
    case expert = 4

    var title: String {
        switch self {
        case .beginner: return "Principiante"
        case .intermediate: return "Intermedio"
        case .advanced: return "Avanzado"
        case .expert: return "Experto"
        }
    }

    var symbolFillCount: Int { rawValue }

    static func < (lhs: DifficultyLevel, rhs: DifficultyLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Tiempo de preparación necesario antes de poder ejecutar el efecto.
enum PreparationTime: String, Codable, CaseIterable {
    case none = "Sin preparación"
    case seconds = "Segundos"
    case minutes = "Pocos minutos"
    case longSetup = "Preparación previa"

    var symbol: String {
        switch self {
        case .none: return "bolt.fill"
        case .seconds: return "timer"
        case .minutes: return "clock"
        case .longSetup: return "calendar.badge.clock"
        }
    }
}
