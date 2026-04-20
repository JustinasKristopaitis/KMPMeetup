import SwiftUI

struct PriorityPickerTabView: View {
    @StateObject private var viewModel = PriorityPickerTabViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text(PriorityPickerStrings.screenTitle)
                .font(.title2)
            Text(PriorityPickerStrings.explainer)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text(viewModel.state.summaryLine)
                .font(.title3)
                .multilineTextAlignment(.center)
            Button(PriorityPickerStrings.cycle, action: viewModel.cycleKnownPriorities)
                .buttonStyle(.bordered)
            Button(PriorityPickerStrings.badRaw, action: viewModel.simulateUnknownServerRaw)
                .buttonStyle(.borderedProminent)
            Text(viewModel.state.footnoteUnknownExample)
                .font(.footnote)
                .foregroundStyle(viewModel.state.isFallbackUnknown ? .orange : .secondary)
        }
        .padding()
    }
}

#Preview {
    PriorityPickerTabView()
}
