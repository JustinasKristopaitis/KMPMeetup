import Foundation

struct PriorityScreenState: Equatable {
    let summaryLine: String
    let footnoteUnknownExample: String
    let isFallbackUnknown: Bool
}

enum PriorityPickerStrings {
    static let tabTitle = "Enum"
    static let tabSystemImageName = "list.bullet"
    static let screenTitle = "Native iOS UI (enum)"
    static let explainer = "SwiftUI only. KMP exposes raw integers; map with DemoPriority.fromRaw so unexpected values become unknown — no Skie."
    static let cycle = "Cycle LOW → MEDIUM → HIGH"
    static let badRaw = "Simulate bad API raw"
}
