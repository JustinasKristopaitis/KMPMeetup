import Combine
import Shared
import UIKit

@MainActor
final class SharedComposeTabViewModel: ObservableObject {

    let presentation: SharedComposePresentationModel

    nonisolated init(
        presentation: SharedComposePresentationModel
    ) {
        self.presentation = presentation
    }
    
    convenience init() {
        self.init(presentation: .default)
    }

    func makeComposeRootViewController() -> UIViewController {
        DemoComposeViewControllers.shared.sharedScreen()
    }
}
