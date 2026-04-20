import SwiftUI

struct NativeCounterSkieTabView: View {
    @StateObject private var viewModel = NativeCounterSkieTabViewModel()

    var body: some View {
        NativeCounterSkieScreenView(
            viewModel: viewModel,
            interopExplainer: NativeCounterStrings.Interop.skieExplainer
        )
        .task {
            await viewModel.activate()
        }
    }
}

#Preview {
    NativeCounterSkieTabView()
}
