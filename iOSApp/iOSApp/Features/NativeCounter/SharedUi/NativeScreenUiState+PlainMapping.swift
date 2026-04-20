import Foundation
import Shared

extension NativeScreenUiState {
    func toPlainUiModel() throws -> NativeCounterPlainUiState {
        switch self {
        case _ as NativeScreenUiStateLoading:
            return .loading
        case let success as NativeScreenUiStateSuccess:
            return .success(
                count: Int(success.count),
                message: success.message as String
            )
        default:
            print("Unknown NativeScreenUiState for plain mapping: \(self)")
            throw NativeCounterPlainMappingError.unknown(status: "\(self)")
        }
    }
}
