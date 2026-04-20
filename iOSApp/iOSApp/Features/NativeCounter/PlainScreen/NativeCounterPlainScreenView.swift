import SwiftUI

struct NativeCounterPlainScreenView: View {
    @ObservedObject var viewModel: NativeCounterPlainTabViewModel
    let interopExplainer: String

    var body: some View {
        NativeCounterDemoScreenLayout(
            kind: .plain,
            interopExplainer: interopExplainer,
            phase: plainPhase,
            onIncrement: viewModel.increment,
            suspendButtonTitle: NativeCounterStrings.runSuspendPlainButton,
            onRunSuspend: viewModel.runSharedSuspendViaKotlinCallbacks,
            asyncSuspendResult: viewModel.asyncSuspendResult
        )
    }

    private var plainPhase: NativeCounterDemoPhase {
        switch viewModel.presentationState {
        case .loading:
            return .loading
        case let .success(count, message):
            return .success(count: count, message: message)
        }
    }
}
