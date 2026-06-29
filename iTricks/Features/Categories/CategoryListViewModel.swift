import Foundation
import Combine

@MainActor
final class CategoryListViewModel: ObservableObject {
    @Published private(set) var categories: [EffectCategory] = EffectCategory.allCases

    func effectCount(for category: EffectCategory) -> Int {
        EffectRepository.shared.effects(in: category).count
    }
}
