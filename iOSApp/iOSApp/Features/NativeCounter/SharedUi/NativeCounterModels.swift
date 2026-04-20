import Foundation

enum NativeCounterStrings {
    static let screenTitle = "Native iOS UI"
    static let increment = "Increment (shared logic)"
    static let loadingTitle = "Updating counter…"
    static let loadingHint = "Same loading / success model as the shared meetup tab."
    nonisolated static let initialSuccessMessage = "State comes from shared KMP code"

    static let runSuspendSkieButton = "Run shared suspend (Swift async/await via Skie)"
    static let runSuspendPlainButton = "Run shared suspend (Kotlin + callbacks, no Skie async)"
    static let suspendRunning = "Running shared suspend…"

    static let skieDocumentationUrl = "https://skie.touchlab.co"
    static let skieDocSheetTitle = "Skie"
    static let skieDocSheetSubtitle = "Official Touchlab Skie documentation — opens in-app like LinkedIn on the meetup tab."
    static let skieDocNavClose = "Close"
    static let skieDocInfoAccessibility = "Skie documentation"

    enum Tab {
        static let skieTitle = "Native (Skie)"
        static let skieSystemImageName = "sparkles"
        static let plainTitle = "Native (plain)"
        static let plainSystemImageName = "link"
    }

    enum Interop {
        static let skieExplainer =
            "Flows: Skie `onEnum` on `state`. Suspend: `try await dataModel.fetchAsyncPreview()` (SuspendInterop opt-in)."
        static let plainExplainer =
            "Flows: `toPlainUiModel()`. Suspend: `IosFlowObservers.runFetchAsyncPreview` → success/failure closures (same KMM `suspend`, no Skie `async`)."
    }
}
