import Foundation
import Combine

@MainActor
final class EffectListViewModel: ObservableObject {
    @Published private(set) var effects: [EffectDescriptor]
    let category: EffectCategory

    init(category: EffectCategory) {
        self.category = category
        self.effects = EffectRepository.shared.effects(in: category)
    }
}
