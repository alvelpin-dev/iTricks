import Foundation
import Combine

@MainActor
final class PracticeViewModel: ObservableObject {
    let info: EffectInfo
    @Published private(set) var currentIndex = 0

    init(info: EffectInfo) {
        self.info = info
    }

    var steps: [PracticeStep] { info.practiceSteps }
    var currentStep: PracticeStep? { steps.indices.contains(currentIndex) ? steps[currentIndex] : nil }
    var isLastStep: Bool { currentIndex == steps.count - 1 }
    var progress: Double { steps.isEmpty ? 0 : Double(currentIndex + 1) / Double(steps.count) }

    func next() {
        guard !isLastStep else { return }
        HapticManager.shared.selectionChanged()
        currentIndex += 1
    }

    func previous() {
        guard currentIndex > 0 else { return }
        HapticManager.shared.selectionChanged()
        currentIndex -= 1
    }

    func restart() {
        currentIndex = 0
    }
}
