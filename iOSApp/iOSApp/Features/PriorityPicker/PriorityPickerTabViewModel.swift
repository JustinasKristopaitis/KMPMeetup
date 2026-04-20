import Combine
import Dispatch
import Foundation
import Shared

@MainActor
final class PriorityPickerTabViewModel: ObservableObject {

    @Published private(set) var state: PriorityScreenState

    private let kmmViewModel: EnumTabViewModel
    private var subscription: FlowObserverHandle?

    init(
        kmmViewModel: EnumTabViewModel = EnumTabViewModel(),
        initialRaw: Int32 = DemoPriority.medium.rawValue
    ) {
        self.kmmViewModel = kmmViewModel
        self.state = PriorityPickerMapper.screenState(rawValue: initialRaw)
        bind()
    }

    func cycleKnownPriorities() {
        kmmViewModel.cycleKnownPriorities()
    }

    func simulateUnknownServerRaw() {
        kmmViewModel.simulateUnknownRawFromApi()
    }

    deinit {
        subscription?.cancel()
    }

    private func bind() {
        subscription = IosFlowObservers.shared.subscribeEnumTabViewModel(vm: kmmViewModel) { [weak self] raw in
            guard let self else { return }
            let intRaw = raw.int32Value
            let next = PriorityPickerMapper.screenState(rawValue: intRaw)
            DispatchQueue.main.async {
                self.state = next
            }
        }
    }
}
