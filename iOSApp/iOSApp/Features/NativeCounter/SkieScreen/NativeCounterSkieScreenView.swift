import Shared
import SwiftUI

struct NativeCounterSkieScreenView: View {

    @ObservedObject var viewModel: NativeCounterSkieTabViewModel
    let interopExplainer: String
    @State private var showSkieDocumentation = false

    private let skieAccent = Color(red: 0.39, green: 0.27, blue: 0.85)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NativeCounterDemoScreenLayout(
                kind: .skie,
                interopExplainer: interopExplainer,
                phase: skiePhase,
                onIncrement: viewModel.increment,
                suspendButtonTitle: NativeCounterStrings.runSuspendSkieButton,
                onRunSuspend: { Task { await viewModel.runSharedSuspendWithSkieAsync() } },
                asyncSuspendResult: viewModel.asyncSuspendResult
            )

            Button {
                showSkieDocumentation = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(skieAccent, in: Circle())
            }
            .shadow(color: .black.opacity(0.22), radius: 8, y: 4)
            .padding(20)
            .accessibilityLabel(NativeCounterStrings.skieDocInfoAccessibility)
        }
        .sheet(isPresented: $showSkieDocumentation) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(NativeCounterStrings.skieDocSheetSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    if let url = URL(string: NativeCounterStrings.skieDocumentationUrl) {
                        SkieDocumentationWebView(url: url)
                            .ignoresSafeArea(edges: .bottom)
                    } else {
                        Text("Invalid documentation URL")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .navigationTitle(NativeCounterStrings.skieDocSheetTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(NativeCounterStrings.skieDocNavClose) {
                            showSkieDocumentation = false
                        }
                    }
                }
            }
        }
    }

    private var skiePhase: NativeCounterDemoPhase {
        switch onEnum(of: viewModel.kmmUiState) {
        case .loading:
            return .loading
        case let .success(success):
            return .success(count: Int(success.count), message: success.message)
        }
    }
}
