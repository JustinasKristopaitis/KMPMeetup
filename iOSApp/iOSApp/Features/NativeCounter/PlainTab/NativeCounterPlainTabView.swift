import SwiftUI

struct NativeCounterPlainTabView: View {
    @StateObject private var viewModel = NativeCounterPlainTabViewModel()

    var body: some View {
        NativeCounterPlainScreenView(
            viewModel: viewModel,
            interopExplainer: NativeCounterStrings.Interop.plainExplainer
        )
    }
}

#Preview {
    NativeCounterPlainTabView()
}
