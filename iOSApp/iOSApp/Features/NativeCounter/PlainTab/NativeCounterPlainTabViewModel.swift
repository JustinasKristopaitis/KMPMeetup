import Combine
import Dispatch
import Foundation
import Shared

@MainActor
final class NativeCounterPlainTabViewModel: ObservableObject {
    @Published private(set) var presentationState: NativeCounterPlainUiState
    @Published private(set) var asyncSuspendResult: String?

    let tabDataModel: NativeCounterPlainTabDataModel

    private var subscription: FlowObserverHandle?
    private var fetchAsyncHandle: FlowObserverHandle?

    init(
        tabDataModel: NativeCounterPlainTabDataModel = NativeCounterPlainTabDataModel(),
        initialKotlinState: NativeScreenUiState = NativeScreenUiStateSuccess(
            count: 0,
            message: NativeCounterStrings.initialSuccessMessage
        )
    ) {
        self.tabDataModel = tabDataModel
        do {
            self.presentationState = try initialKotlinState.toPlainUiModel()
        } catch {
            print("NativeCounter plain initial map error: \(error)")
            self.presentationState = .loading
        }
        bind()
    }
    

    func increment() {
        tabDataModel.increment()
    }

    func runSharedSuspendViaKotlinCallbacks() {
        fetchAsyncHandle?.cancel()
        asyncSuspendResult = NativeCounterStrings.suspendRunning
        fetchAsyncHandle = IosFlowObservers.shared.runFetchAsyncPreview(
            dataModel: tabDataModel,
            onSuccess: { [weak self] text in
                DispatchQueue.main.async {
                    self?.asyncSuspendResult = text
                }
            },
            onFailure: { [weak self] message in
                DispatchQueue.main.async {
                    self?.asyncSuspendResult = "Error: \(message)"
                }
            },
        )
    }

    deinit {
        subscription?.cancel()
        fetchAsyncHandle?.cancel()
    }

    private func bind() {
        subscription = IosFlowObservers.shared.subscribeNativeScreenDataModel(dataModel: tabDataModel) { [weak self] sealed in
            guard let self else { return }
            DispatchQueue.main.async {
                do {
                    self.presentationState = try sealed.toPlainUiModel()
                } catch {
                    print("NativeCounter plain map error: \(error)")
                }
            }
        }
    }
}
