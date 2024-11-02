import Combine
import OSLog
import SwiftUI

public protocol NavigationResolving: Hashable, Codable {
    associatedtype V: View
    @ViewBuilder func view() -> V
}

open class BaseNavigation<P: NavigationResolving>: ObservableObject {
    // MARK: - PUBLIC PROPERTIES

    @Published public var path = [P]()

    // MARK: - PRIVATE PROPERTIES

    private var cancelable: AnyCancellable?

    // MARK: - INITIALIZERS

    public init() {
        cancelable = $path.sink { path in
            Logger.navigation.info("navigationStack: \(path)")
        }
    }

    // MARK: - PUSH METHODS

    public func push(_ view: P) {
        path.append(view)
    }

    public func push(_ views: P...) {
        path.append(contentsOf: views)
    }

    public func push(_ views: [P]) {
        path.append(contentsOf: views)
    }

    // MARK: - POP METHODS

    public func pop() {
        if path.count > 1 {
            path.removeLast()
        }
    }

    public func popToRoot() {
        guard path.count > 1 else { return }
        path.removeLast(path.count - 1)
    }

    @discardableResult
    public func popTo(_ view: P) -> Bool {
        if let index = path.lastIndex(of: view) {
            let viewsToRemove = path.count - index - 1
            path.removeLast(viewsToRemove)
            return true
        }
        return false
    }

    /// Tries to pop `view` form `views` until first success occurs
    public func popTo(firstExisting views: P...) {
        for view in views {
            if popTo(view) {
                break
            }
        }
    }

    // MARK: - REPLACE

    /// Replaces navigaionStack with provided `views`
    public func replace(_ views: [P]) {
        path = views
    }

    // MARK: - UTILITY

    public func contains(_ view: P) -> Bool {
        path.contains(view)
    }
}
