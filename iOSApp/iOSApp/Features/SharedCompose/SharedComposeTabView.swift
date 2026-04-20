import SwiftUI

struct SharedComposeTabView: View {
    @StateObject private var viewModel = SharedComposeTabViewModel()

    var body: some View {
        SharedComposeContainer(viewModel: viewModel)
    }
}

private struct SharedComposeContainer: UIViewControllerRepresentable {
    @ObservedObject var viewModel: SharedComposeTabViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        viewModel.makeComposeRootViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    SharedComposeTabView()
}
