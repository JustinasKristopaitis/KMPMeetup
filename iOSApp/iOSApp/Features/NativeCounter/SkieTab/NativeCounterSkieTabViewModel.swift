import Combine
import Foundation
import Shared

@MainActor
final class NativeCounterSkieTabViewModel: ObservableObject, NativeCounterCoordinating {

    let tabDataModel: NativeCounterSkieTabDataModel

    @Published private(set) var kmmUiState: NativeScreenUiState

    @Published private(set) var asyncSuspendResult: String?

    var dataModel: NativeScreenDataModel { tabDataModel }

    init(
        tabDataModel: NativeCounterSkieTabDataModel = NativeCounterSkieTabDataModel(),
        initialKmmUiState: NativeScreenUiState = NativeScreenUiStateSuccess(
            count: 0,
            message: NativeCounterStrings.initialSuccessMessage
        )
    ) {
        self.tabDataModel = tabDataModel
        self.kmmUiState = initialKmmUiState
    }

    func increment() {
        tabDataModel.increment()
    }

    func runSharedSuspendWithSkieAsync() async {
        asyncSuspendResult = NativeCounterStrings.suspendRunning
        do {
            let text = try await tabDataModel.fetchAsyncPreview()
            asyncSuspendResult = text
        } catch {
            asyncSuspendResult = "Error: \(error.localizedDescription)"
        }
    }

    func activate() async {
        let model = tabDataModel
        for await state in model.state {
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.kmmUiState = state
            }
        }
    }
}
