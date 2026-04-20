import Foundation

/// Swift-side metadata for the tab that hosts Kotlin Compose. Counter state remains in KMP.
struct SharedComposePresentationModel: Equatable {
    let tabTitle: String
    let tabSystemImageName: String

    static let `default` = SharedComposePresentationModel(
        tabTitle: "Shared",
        tabSystemImageName: "square.grid.2x2"
    )
}
