import Foundation

enum NativeCounterPlainUiState: Equatable {
    case loading
    case success(count: Int, message: String)
}

enum NativeCounterPlainMappingError: Error {
    case unknown(status: String)
}
