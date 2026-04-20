import Combine
import Foundation
import Shared

@MainActor
protocol NativeCounterCoordinating: ObservableObject {
    var dataModel: NativeScreenDataModel { get }
    var kmmUiState: NativeScreenUiState { get }
    func increment()
}
