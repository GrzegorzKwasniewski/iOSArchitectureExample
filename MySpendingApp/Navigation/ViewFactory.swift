import Foundation
import SwiftUI

/// Use ViewFactory to create static computed properites or functions that reslove View dependency
public enum ViewFactory {
    static var example: EmptyView { EmptyView() }
}
