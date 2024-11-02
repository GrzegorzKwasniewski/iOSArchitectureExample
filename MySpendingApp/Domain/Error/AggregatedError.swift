import Foundation

final class AggregatedError: Error {
    
    private var list: [Error] = []
    
    func appendError(error: Error) -> AggregatedError {
        list.append(error)
        return self
    }
    
    func getFirstError() -> Error? {
        return list.first
    }
    
    func getLastError() -> Error? {
        return list.last
    }
    
    func getError(index: Int) -> Error? {
        return list[safe: index]
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
