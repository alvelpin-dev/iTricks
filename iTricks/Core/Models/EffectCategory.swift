import SwiftUI

/// Categoría temática de efectos. Añadir un caso nuevo aquí registra
/// automáticamente la categoría en la pantalla principal.
enum EffectCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case mentalism = "Mentalismo"
    case cards = "Cartas"
    case paranormal = "Paranormal"
    case numbers = "Números"
    case technology = "Tecnología"
    case tools = "Herramientas"

    var id: String { rawValue }

    var title: String { rawValue }

    var symbol: String {
        switch self {
        case .mentalism: return "brain.head.profile"
        case .cards: return "suit.club.fill"
        case .paranormal: return "sparkles"
        case .numbers: return "number"
        case .technology: return "iphone.gen3"
        case .tools: return "wrench.and.screwdriver.fill"
        }
    }

    var tint: Color {
        switch self {
        case .mentalism: return .purple
        case .cards: return .red
        case .paranormal: return .indigo
        case .numbers: return .blue
        case .technology: return .teal
        case .tools: return .gray
        }
    }

    var subtitle: String {
        switch self {
        case .mentalism: return "Lectura de mente y predicciones"
        case .cards: return "Cartas y juegos de manipulación"
        case .paranormal: return "Fenómenos inexplicables"
        case .numbers: return "Matemágia y cálculo imposible"
        case .technology: return "El iPhone como herramienta mágica"
        case .tools: return "Utilidades para el mago"
        }
    }
}
